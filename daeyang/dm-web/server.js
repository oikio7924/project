/**
 * DAEYANG 태양광 모니터링 — Express + MariaDB
 * 인증: u_userinfo (Spring SHA-256^1024)  /  발전소: dy_power_plant  /  게시판: b_board_notice
 * 공사현황: dm_construction + dm_construction_contacts  /  설정: dm_settings
 */
require("dotenv").config();
const express = require("express");
const session = require("express-session");
const path = require("path");
const mysql = require("mysql2/promise");
const crypto = require("crypto");
const { initDb } = require("./lib/initDb");
const { registerAdminRoutes } = require("./lib/adminRoutes");
const { getMapKeys } = require("./lib/mapSettings");
const { SQL, buildPlantSelect, getPlantSelect } = require("./db/queries");

// Spring StandardPasswordEncoder(SHA-256, 1024 iterations, secret)
// 저장 형식: hex(salt 8bytes) + hex(sha256^1024(salt + secret + password))
const SPRING_SECRET = Buffer.from("TRONIX$(%&@!CTCMS", "utf8");
const SPRING_ITERATIONS = 1024;

function verifySpringPassword(rawPassword, encodedPassword) {
  if (!encodedPassword || encodedPassword.length !== 80) return false;
  try {
    const saltBytes = Buffer.from(encodedPassword.slice(0, 16), "hex");
    const storedDigest = encodedPassword.slice(16);
    const pwBytes = Buffer.from(rawPassword, "utf8");
    const input = Buffer.concat([saltBytes, SPRING_SECRET, pwBytes]);
    let digest = crypto.createHash("sha256").update(input).digest();
    for (let i = 1; i < SPRING_ITERATIONS; i++) {
      digest = crypto.createHash("sha256").update(digest).digest();
    }
    return digest.toString("hex") === storedDigest;
  } catch (e) {
    return false;
  }
}

function encodeSpringPassword(rawPassword) {
  const saltBytes = crypto.randomBytes(8);
  const pwBytes = Buffer.from(rawPassword, "utf8");
  const input = Buffer.concat([saltBytes, SPRING_SECRET, pwBytes]);
  let digest = crypto.createHash("sha256").update(input).digest();
  for (let i = 1; i < SPRING_ITERATIONS; i++) {
    digest = crypto.createHash("sha256").update(digest).digest();
  }
  return saltBytes.toString("hex") + digest.toString("hex");
}

const app = express();
const PORT = Number(process.env.PORT || 3010);
const SITE_DOMAIN = process.env.SITE_DOMAIN || "http://localhost:" + PORT;

const DB_CONFIG = {
  host: process.env.MARIADB_HOST || "127.0.0.1",
  port: Number(process.env.MARIADB_PORT || 3306),
  user: process.env.MARIADB_USER || "",
  password: process.env.MARIADB_PASSWORD || "",
  database: process.env.MARIADB_DATABASE || "monitering",
  charset: "utf8mb4",
  waitForConnections: true,
  connectionLimit: 10,
  dateStrings: true,
  timezone: "+09:00",
};

let dbPool = null;

function getDb() {
  if (!dbPool) dbPool = mysql.createPool(DB_CONFIG);
  return dbPool;
}

function q(sql, params) {
  return getDb().execute(sql, params || []);
}

function errHandler(fn) {
  return async function (req, res) {
    try {
      await fn(req, res);
    } catch (e) {
      console.error(e);
      res.status(500).json({ error: e.message || "서버 오류" });
    }
  };
}

function needLogin(req, res, next) {
  if (req.session && req.session.user) return next();
  return res.status(401).json({ error: "로그인이 필요합니다." });
}

// dy_power_plant 행 → 프론트엔드 객체
function mapPlant(row) {
  return {
    id: Number(row.id),
    name: String(row.name || ""),
    region: String(row.region || ""),
    address: String(row.address || ""),
    lat: row.lat != null ? Number(row.lat) : null,
    lng: row.lng != null ? Number(row.lng) : null,
    capacityKw: parseFloat(row.capacity_kw) || 0,
    inverterCount: Number(row.inverter_count) || 0,
    invBrand: String(row.inv_brand || ""),
    brand: String(row.brand || ""),
    model: String(row.model || ""),
    status: String(row.status || "normal"),
    registeredAt: row.registered_at || "",
    lastReceivedAt: row.last_received_at || "",
    todayKwh: Number(row.today_kwh) || 0,
    yesterdayKwh: Number(row.yesterday_kwh) || 0,
  };
}

// 수집 시각 기준 status 계산
function computeStatus(lastReceivedAt, currentKw) {
  if (!lastReceivedAt) return "offline";
  const diffH = (Date.now() - new Date(lastReceivedAt).getTime()) / 3600000;
  if (diffH > 2) return "no_comm";
  return Number(currentKw) > 0 ? "normal" : "fault";
}

// ── 미들웨어 ───────────────────────────────────────────────────────────────
app.use(express.json());
app.use(
  session({
    secret: process.env.SESSION_SECRET || "dm-web-dev-secret",
    resave: false,
    saveUninitialized: false,
    cookie: { maxAge: 1000 * 60 * 60 * 8 },
  })
);
// 프로덕션: React 빌드 결과물 서빙 (npm run build 후 client/dist 생성)
const clientDist = path.join(__dirname, "client", "dist");
const fs = require("fs");
if (fs.existsSync(clientDist)) {
  app.use(express.static(clientDist));
}

// ── Config ──────────────────────────────────────────────────────────────────
app.get(
  "/api/config",
  errHandler(async function (req, res) {
    const keys = await getMapKeys(getDb());
    res.json({
      siteDomain: SITE_DOMAIN,
      mapKeys: {
        kakao: keys.kakao || "",
        naver: keys.naver || "",
        google: keys.google || "",
      },
    });
  })
);

// ── 인증 ────────────────────────────────────────────────────────────────────
app.post(
  "/api/login",
  errHandler(async function (req, res) {
    const username = String((req.body && req.body.username) || "").trim();
    const password = String((req.body && req.body.password) || "");
    const [rows] = await q(SQL.login, [username]);
    if (!rows.length) {
      return res.status(401).json({ error: "아이디 또는 비밀번호가 올바르지 않습니다." });
    }
    const user = rows[0];
    if (!verifySpringPassword(password, user.UI_PASSWORD)) {
      return res.status(401).json({ error: "아이디 또는 비밀번호가 올바르지 않습니다." });
    }
    await q(SQL.loginUpdateMeta, [user.UI_KEYNO]);
    req.session.user = {
      id: user.UI_KEYNO,
      username: user.UI_ID,
      displayName: user.UI_NAME || user.UI_ID,
      role: "admin",
    };
    res.json({ ok: true, user: req.session.user });
  })
);

app.post("/api/logout", function (req, res) {
  req.session.destroy(function () {
    res.json({ ok: true });
  });
});

app.get(
  "/api/me",
  needLogin,
  errHandler(async function (req, res) {
    res.json({ user: req.session.user });
  })
);

// ── 대시보드 요약 ────────────────────────────────────────────────────────────
app.get(
  "/api/dashboard/summary",
  needLogin,
  errHandler(async function (req, res) {
    const [[agg]] = await q(SQL.dashboardSummary);
    res.json({
      totalSites: Number(agg.total_sites),
      running: Number(agg.running || 0),
      inverterError: 0,
      unregistered: 0,
      noCommunication: 0,
      totalOutputKw: Number(agg.total_output_kw),
      todayMwh: Number(agg.today_mwh),
      yesterdayMwh: Number(agg.yesterday_mwh),
      cumulativeGwh: Number(agg.cumulative_gwh),
      totalCapacityKw: Number(agg.total_capacity_kw),
    });
  })
);

// ── 발전소 목록 ──────────────────────────────────────────────────────────────
app.get(
  "/api/sites",
  needLogin,
  errHandler(async function (req, res) {
    const region = String(req.query.region || "").trim();
    const search = String(req.query.q || "").trim();
    const wheres = ["p.DPP_DEL_YN = 'N'", "p.DPP_STATUS = 'Y'"];
    const params = [];
    if (region) { wheres.push("p.DPP_AREA LIKE ?"); params.push("%" + region + "%"); }
    if (search) { wheres.push("p.DPP_NAME LIKE ?"); params.push("%" + search + "%"); }
    const [rows] = await q(
      getPlantSelect() + "WHERE " + wheres.join(" AND ") + " ORDER BY p.DPP_KEYNO",
      params
    );
    res.json({
      sites: rows.map(function (r) {
        return mapPlant(Object.assign({}, r, { status: computeStatus(r.last_received_at, r.current_kw) }));
      }),
    });
  })
);

// ── 발전소 상세 ──────────────────────────────────────────────────────────────
app.get(
  "/api/sites/:id",
  needLogin,
  errHandler(async function (req, res) {
    const id = Number(req.params.id);
    const [plants] = await q(
      getPlantSelect() + "WHERE p.DPP_KEYNO = ? AND p.DPP_DEL_YN = 'N' LIMIT 1",
      [id]
    );
    if (!plants.length) return res.status(404).json({ error: "현장을 찾을 수 없습니다." });
    const row = plants[0];

    const keynoStr = String(id);
    const [invRows] = await q(SQL.inverterLatest, [keynoStr, keynoStr]);
    const inverters = invRows.map(function (inv, idx) {
      const isError = inv.DSP_Error_Code && String(inv.DSP_Error_Code).replace(/0/g, "").length > 0;
      return {
        id: idx + 1,
        name: inv.DI_NAME || "",
        acKw: Number(inv.Active_Power) || 0,
        status: isError ? "error" : inv.Work_Mode ? "normal" : "no_comm",
        workMode: inv.Work_Mode || "",
        dspError: inv.DSP_Error_Code || "",
        lastConn: inv.Conn_date || "",
      };
    });

    const [[ghRow]] = await q(SQL.todayGenHours, [keynoStr]);
    const todayGenHours = Math.round((Number(ghRow.slot_cnt) || 0) * 10 / 60 * 10) / 10;

    res.json({
      site: mapPlant(Object.assign({}, row, { status: computeStatus(row.last_received_at, row.current_kw) })),
      inverters: inverters,
      generation: {
        currentKw: Number(row.current_kw) || 0,
        todayKwh: Number(row.today_kwh) || 0,
        yesterdayKwh: Number(row.yesterday_kwh) || 0,
        monthKwh: 0,
        yearKwh: 0,
        cumulativeKwh: Number(row.cumulative_kwh) || 0,
        todayGenHours: todayGenHours,
      },
    });
  })
);

// ── 인버터 실시간 상세 데이터 ────────────────────────────────────────────────
app.get(
  "/api/sites/:id/inverter-data",
  needLogin,
  errHandler(async function (req, res) {
    const keynoStr = String(req.params.id);
    const [rows] = await q(SQL.inverterDetail, [keynoStr]);
    res.json({
      inverters: rows.map(function (r) {
        return {
          name: r.DI_NAME,
          activePower: Number(r.Active_Power) || 0,
          dailyGen: r.Daily_Generation,
          cumulativeGen: r.Cumulative_Generation,
          workMode: r.Work_Mode,
          dspError: r.DSP_Error_Code,
          dspAlarm: r.DSP_Alarm_Code,
          connDate: r.Conn_date,
          voltA: r.Phase_voltage_of_phase_A,
          voltB: r.Phase_voltage_of_phase_B,
          voltC: r.Phase_voltage_of_phase_C,
          currA: r.Current_of_phase_A,
          currB: r.Current_of_phase_B,
          currC: r.Current_of_phase_C,
          temp: r.Internal_temperature,
          freq: r.Grid_Frequency,
        };
      }),
    });
  })
);

// ── 알람 ────────────────────────────────────────────────────────────────────
app.get(
  "/api/alarms",
  needLogin,
  errHandler(async function (req, res) {
    const limit = Math.min(100, Math.max(1, parseInt(req.query.limit, 10) || 50));
    const siteId = req.query.siteId ? parseInt(req.query.siteId, 10) : null;
    const [rows] = await q(SQL.alarms(!!siteId, limit), siteId ? [siteId] : []);
    res.json({
      alarms: rows.map(function (a) {
        return {
          siteName: a.DIE_DPP_NAME || "",
          inverterName: a.DIE_INVERTER_NAME || "",
          time: a.DIE_DATE ? new Date(a.DIE_DATE).toLocaleString("ko-KR") : "",
          inverterStatus: a.DIE_ARM_ALARM || a.DIE_ARM_ERROR || a.DIE_DSP_ERROR || "",
          dspError: a.DIE_DSP_ERROR || "",
          dspSlave: a.DIE_DSP_S_ERROR || "",
        };
      }),
    });
  })
);

// ── 시간별 발전 곡선 ─────────────────────────────────────────────────────────
app.get(
  "/api/sites/:id/hourly",
  needLogin,
  errHandler(async function (req, res) {
    const keynoStr = String(req.params.id);
    let statDate = req.query.date || new Date().toISOString().slice(0, 10);

    const [[latest]] = await q(SQL.hourlyLatestDate, [keynoStr]);
    if (latest && latest.d) {
      const latestDate = latest.d instanceof Date
        ? latest.d.toISOString().slice(0, 10)
        : String(latest.d).slice(0, 10);
      if (latestDate < statDate) statDate = latestDate;
    }

    const invName = req.query.inverter ? String(req.query.inverter) : "";
    const invFilter = invName ? " AND DI_NAME = ?" : "";
    const baseParams = invName ? [keynoStr, statDate, invName] : [keynoStr, statDate];
    const params = [...baseParams, ...baseParams];

    const [rows] = await q(SQL.hourly(invFilter), params);
    const series = rows.map(function (r) {
      return {
        time: r.slot_time,
        kw:  Math.round((Number(r.kw)  || 0) * 100) / 100,
        kwh: Math.round((Number(r.kwh) || 0) * 100) / 100,
      };
    });

    res.json({ series: series, date: statDate });
  })
);

// ── 게시판 (b_board_notice) ──────────────────────────────────────────────────
app.get(
  "/api/board",
  needLogin,
  errHandler(async function (req, res) {
    const category = String(req.query.category || "").trim();
    const wheres = ["BN_DEL_YN = 'N'"];
    const params = [];
    if (category && category !== "all") {
      wheres.push("BN_CATEGORY_NAME = ?");
      params.push(category);
    }
    const where = "WHERE " + wheres.join(" AND ");
    const [[{ total }]] = await q(SQL.boardCount(where), params);
    const [posts] = await q(SQL.boardList(where), params);
    res.json({
      total: Number(total),
      posts: posts.map(function (p) {
        return {
          id: p.id,
          category: p.category || "",
          siteName: p.site_name || "",
          title: p.title || "",
          author: p.author || "",
          views: Number(p.views) || 0,
          createdAt: p.created_at || "",
        };
      }),
    });
  })
);

app.post(
  "/api/board",
  needLogin,
  errHandler(async function (req, res) {
    const b = req.body || {};
    const title = String(b.title || "").trim();
    if (!title) return res.status(400).json({ error: "제목을 입력하세요." });
    const author = req.session.user.displayName || req.session.user.username;
    await q(SQL.boardInsert, [
      String(b.category || "").trim(),
      String(b.siteName || "").trim(),
      title,
      author,
    ]);
    res.json({ ok: true });
  })
);

app.put(
  "/api/board/:id",
  needLogin,
  errHandler(async function (req, res) {
    const id = Number(req.params.id);
    const b = req.body || {};
    const title = String(b.title || "").trim();
    if (!title) return res.status(400).json({ error: "제목을 입력하세요." });
    await q(SQL.boardUpdate, [
      String(b.category || "").trim(),
      String(b.siteName || "").trim(),
      title,
      id,
    ]);
    res.json({ ok: true });
  })
);

app.delete(
  "/api/board/:id",
  needLogin,
  errHandler(async function (req, res) {
    await q(SQL.boardDelete, [Number(req.params.id)]);
    res.json({ ok: true });
  })
);

// ── 공사현황 (dm_construction / dm_construction_contacts) ────────────────────
app.get(
  "/api/construction/:siteId",
  needLogin,
  errHandler(async function (req, res) {
    const siteId = Number(req.params.siteId);
    const [plants] = await q(SQL.constructionSite, [siteId]);
    if (!plants.length) return res.status(404).json({ error: "발전소를 찾을 수 없습니다." });

    const [contacts] = await q(SQL.constructionContacts);
    const contactList = contacts.map(function (c) {
      return { id: c.code, dbId: c.id, name: c.name, dept: c.dept, position: c.position, phone: c.phone };
    });

    const [rows] = await q(SQL.constructionGet, [siteId]);
    if (!rows.length) {
      return res.json({
        siteId: siteId,
        currentStep: 1,
        operator: { businessName: "", address: "", phone: "", email: "" },
        permit: { plantName: "", capacity: "", location: "", installType: "", receivedAt: "", expectedAt: "" },
        contacts: contactList,
        selectedContactId: contactList[0] ? contactList[0].id : "",
      });
    }
    const row = rows[0];
    const sel = contacts.find(function (c) { return c.id === row.selected_contact_id; });
    res.json({
      siteId: siteId,
      currentStep: Number(row.current_step) || 1,
      operator: {
        businessName: row.operator_business,
        address: row.operator_address,
        phone: row.operator_phone,
        email: row.operator_email,
      },
      permit: {
        plantName: row.permit_plant_name,
        capacity: row.permit_capacity,
        location: row.permit_location,
        installType: row.permit_install_type,
        receivedAt: row.permit_received_at || "",
        expectedAt: row.permit_expected_at || "",
      },
      contacts: contactList,
      selectedContactId: sel ? sel.code : (contactList[0] ? contactList[0].id : ""),
    });
  })
);

app.put(
  "/api/construction/:siteId",
  needLogin,
  errHandler(async function (req, res) {
    const siteId = Number(req.params.siteId);
    const b = req.body || {};
    const op = b.operator || {};
    const p = b.permit || {};
    const step = Number(b.currentStep) || 1;
    const contactCode = String(b.selectedContactId || "");
    const [crows] = contactCode
      ? await q(SQL.constructionContactByCode, [contactCode])
      : [[]];
    const contactDbId = crows[0] ? crows[0].id : null;

    const [existing] = await q(SQL.constructionCheck, [siteId]);
    const vals = [
      step,
      op.businessName || "", op.address || "", op.phone || "", op.email || "",
      p.plantName || "", p.capacity || "", p.location || "", p.installType || "",
      p.receivedAt || null, p.expectedAt || null, contactDbId,
    ];
    if (existing.length) {
      await q(SQL.constructionUpdate, [...vals, siteId]);
    } else {
      await q(SQL.constructionInsert, [siteId, ...vals]);
    }
    res.json({ ok: true });
  })
);

// ── 개인설정 (u_userinfo) ────────────────────────────────────────────────────
app.get(
  "/api/settings",
  needLogin,
  errHandler(async function (req, res) {
    const [rows] = await q(SQL.settingsGet, [req.session.user.id]);
    if (!rows.length) return res.status(404).json({ error: "사용자를 찾을 수 없습니다." });
    const u = rows[0];
    res.json({
      username: u.UI_ID || "",
      mobile: u.UI_PHONE || "",
      email: u.UI_EMAIL || "",
      manager: "",
      managerPhone: "",
    });
  })
);

app.put(
  "/api/settings",
  needLogin,
  errHandler(async function (req, res) {
    const body = req.body || {};
    const email = String(body.email || "");
    const mobile = String(body.mobile || "");
    const password = String(body.password || "");
    if (password) {
      await q(SQL.settingsUpdateWithPw, [encodeSpringPassword(password), email, mobile, req.session.user.id]);
    } else {
      await q(SQL.settingsUpdate, [email, mobile, req.session.user.id]);
    }
    res.json({ ok: true });
  })
);

// ── 관리자 라우트 ────────────────────────────────────────────────────────────
registerAdminRoutes(app, {
  q: q,
  getDb: getDb,
  errHandler: errHandler,
  needLogin: needLogin,
  encodeSpringPassword: encodeSpringPassword,
});

app.use("/api", function (req, res) {
  res.status(404).json({ error: "API를 찾을 수 없습니다." });
});

// React Router: API가 아닌 모든 경로는 index.html로 (새로고침 대응)
app.get("*", function (req, res) {
  const indexPath = path.join(clientDist, "index.html");
  if (fs.existsSync(indexPath)) {
    res.sendFile(indexPath);
  } else {
    res.status(404).send("React 빌드가 없습니다. client 폴더에서 npm run build를 실행하세요.");
  }
});

// ── 시작 ─────────────────────────────────────────────────────────────────────
async function start() {
  if (!DB_CONFIG.user || !DB_CONFIG.database) {
    console.error("MariaDB 환경변수 필요: MARIADB_HOST, MARIADB_USER, MARIADB_DATABASE");
    process.exit(1);
  }
  getDb();
  await initDb(dbPool);
  await buildPlantSelect(q);
  app.listen(PORT, function () {
    console.log("DAEYANG monitoring: http://localhost:" + PORT);
    console.log("DB:", DB_CONFIG.database, "@", DB_CONFIG.host);
  });
}

start().catch(function (e) {
  console.error(e);
  process.exit(1);
});
