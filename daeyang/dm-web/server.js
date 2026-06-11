/**
 * DAEYANG 태양광 모니터링 — Express + MariaDB
 * 인증: u_userinfo (Spring SHA-256^1024)  /  발전소: dy_power_plant  /  게시판: b_board_notice
 * 설정: dm_settings
 */
require("dotenv").config();
const express = require("express");
const session = require("express-session");
const path = require("path");
const mysql = require("mysql2/promise");
const crypto = require("crypto");
const https = require("https");
const multer = require("multer");
const { initDb } = require("./lib/initDb");
const { registerAdminRoutes } = require("./lib/adminRoutes");
const { getMapKeys } = require("./lib/mapSettings");
const { SQL, buildPlantSelect, getPlantSelect } = require("./db/queries");

// Spring StandardPasswordEncoder(SHA-256, 1024 iterations, secret)
// 저장 형식: hex(salt 8bytes) + hex(sha256^1024(salt + secret + password))
const SPRING_SECRET = Buffer.from("TRONIX$(%&@!CTCMS", "utf8");
const SPRING_ITERATIONS = 1024;

function verifySpringPassword(rawPassword, encodedPassword) {
  if (!encodedPassword) return false;
  // 평문 저장인 경우 직접 비교
  if (encodedPassword.length < 80) return encodedPassword === rawPassword;
  // Spring SHA-256^1024 해시 검증
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
app.use(express.json({ limit: '50mb' }));
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

// 첨부파일 정적 서빙
const uploadDir = path.join(__dirname, "uploads", "notices");
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir, { recursive: true });
app.use("/uploads/notices", express.static(uploadDir));

// 파일 업로드 설정
const noticeUpload = multer({
  storage: multer.diskStorage({
    destination: uploadDir,
    filename: function (req, file, cb) {
      const unique = Date.now() + "-" + Math.random().toString(36).slice(2, 8);
      cb(null, unique + path.extname(file.originalname));
    },
  }),
  limits: { fileSize: 20 * 1024 * 1024 }, // 20MB
});

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
    if (!verifySpringPassword(password, user.password)) {
      return res.status(401).json({ error: "아이디 또는 비밀번호가 올바르지 않습니다." });
    }
    await q(SQL.loginUpdateMeta, [user.id]);
    req.session.user = {
      id: user.id,
      username: user.username,
      displayName: user.display_name || user.username,
      role: user.role || "user",
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
      todayKwh: Number(agg.today_kwh),
      yesterdayKwh: Number(agg.yesterday_kwh),
      cumulativeKwh: Number(agg.cumulative_kwh),
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
    const wheres = ["p.del_yn = 'N'", "p.grid_status = 'Y'"];
    const params = [];
    if (region) { wheres.push("p.region LIKE ?"); params.push("%" + region + "%"); }
    if (search) { wheres.push("p.name LIKE ?"); params.push("%" + search + "%"); }
    // partner_admin은 배정된 발전소만
    const sessionUser = req.session.user;
    if (sessionUser && sessionUser.role === "partner_admin") {
      const [pRows] = await q("SELECT plant_id FROM dm_user_plants WHERE user_id = ?", [sessionUser.id]);
      const ids = pRows.map(function(r) { return r.plant_id; });
      if (ids.length === 0) return res.json({ sites: [] });
      wheres.push("p.id IN (" + ids.map(function() { return "?"; }).join(",") + ")");
      params.push(...ids);
    }
    const [rows] = await q(
      getPlantSelect() + "WHERE " + wheres.join(" AND ") + " ORDER BY p.id",
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
      getPlantSelect() + "WHERE p.id = ? AND p.del_yn = 'N' LIMIT 1",
      [id]
    );
    if (!plants.length) return res.status(404).json({ error: "현장을 찾을 수 없습니다." });
    const row = plants[0];

    const keynoStr = String(id);
    const [invRows] = await q(SQL.inverterLatest, [id, id, id]);
    const inverters = invRows.map(function (inv, idx) {
      const isError = inv.dsp_error && String(inv.dsp_error).replace(/0/g, "").length > 0;
      return {
        id: idx + 1,
        name: inv.inverter_name || "",
        acKw: Number(inv.active_power) || 0,
        model: inv.inv_model || "",
        status: isError ? "error" : inv.work_mode ? "normal" : "no_comm",
        workMode: inv.work_mode || "",
        dspError: inv.dsp_error || "",
        lastConn: inv.collected_at || "",
      };
    });

    const [[ghRow]] = await q(SQL.todayGenHours, [id]);
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
    const id = Number(req.params.id);
    const [rows] = await q(SQL.inverterDetail, [id]);
    res.json({
      inverters: rows.map(function (r) {
        return {
          name: r.inverter_name,
          activePower: Number(r.active_power) || 0,
          dailyGen: r.daily_gen,
          cumulativeGen: r.cumulative_gen,
          workMode: r.work_mode,
          dspError: r.dsp_error,
          dspAlarm: r.dsp_alarm,
          connDate: r.collected_at,
          voltA: r.volt_a,
          voltB: r.volt_b,
          voltC: r.volt_c,
          currA: r.curr_a,
          currB: r.curr_b,
          currC: r.curr_c,
          temp: r.temperature,
          freq: r.grid_frequency,
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
          siteName: a.site_name || "",
          inverterName: a.inverter_name || "",
          time: a.occurred_at ? new Date(a.occurred_at).toLocaleString("ko-KR") : "",
          inverterStatus: a.arm_alarm || a.arm_error || a.dsp_error || "",
          dspError: a.dsp_error || "",
          dspSlave: a.dsp_slave_error || "",
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
    const invFilter = invName ? " AND inverter_name = ?" : "";
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

// ── 인버터별 시간대 발전 데이터 ──────────────────────────────────────────────
app.get(
  "/api/sites/:id/hourly-by-inverter",
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

    const [rows] = await q(SQL.hourlyPerInverter(""), [keynoStr, statDate]);
    res.json({
      series: rows.map(function (r) {
        return {
          time: r.slot_time,
          inverter: r.inverter_name,
          kw: Math.round((Number(r.kw) || 0) * 100) / 100,
          kwh: Math.round((Number(r.kwh) || 0) * 100) / 100,
        };
      }),
      date: statDate,
    });
  })
);

// ── 인버터 raw 데이터 (통계분석 상세보기) ────────────────────────────────────
app.get(
  "/api/sites/:id/inverter-raw",
  needLogin,
  errHandler(async function (req, res) {
    const keynoStr = String(req.params.id);
    const date = String(req.query.date || new Date().toISOString().slice(0, 10));
    const slot = String(req.query.slot || "");
    const invName = req.query.inverter ? String(req.query.inverter) : "";
    const invFilter = invName ? " AND inverter_name = ?" : "";
    const params = invName ? [keynoStr, date, slot, invName] : [keynoStr, date, slot];
    const [rows] = await q(SQL.inverterRaw(invFilter), params);
    res.json({ rows });
  })
);

// ── 인버터 raw 전체 (날짜 전체 테이블 뷰) ────────────────────────────────────
app.get(
  "/api/sites/:id/inverter-raw-all",
  needLogin,
  errHandler(async function (req, res) {
    const keynoStr = String(req.params.id);
    let date = String(req.query.date || new Date().toISOString().slice(0, 10));

    // hourly와 동일하게 실제 데이터가 있는 최신 날짜로 보정
    const [[latest]] = await q(SQL.hourlyLatestDate, [keynoStr]);
    if (latest && latest.d) {
      const latestDate = latest.d instanceof Date
        ? latest.d.toISOString().slice(0, 10)
        : String(latest.d).slice(0, 10);
      if (latestDate < date) date = latestDate;
    }

    const invName = req.query.inverter ? String(req.query.inverter) : "";
    const invFilter = invName ? " AND inverter_name = ?" : "";
    const params = invName ? [keynoStr, date, date, invName] : [keynoStr, date, date];
    const [rows] = await q(SQL.inverterRawAll(invFilter), params);
    res.json({ rows, date });
  })
);

// ── 통계 (주/월/년) ──────────────────────────────────────────────────────────
app.get(
  "/api/sites/:id/stats",
  needLogin,
  errHandler(async function (req, res) {
    const keynoStr = String(req.params.id);
    const period = req.query.period || "week";
    const date = String(req.query.date || "");

    if (period === "week") {
      const endDate = date || new Date().toISOString().slice(0, 10);
      const start = new Date(endDate);
      start.setDate(start.getDate() - 6);
      const startDate = start.toISOString().slice(0, 10);
      const [rows] = await q(SQL.statsDaily, [keynoStr, startDate, endDate]);
      const series = rows.map(function (r) {
        return { label: String(r.stat_date).slice(0, 10), kwh: Math.round(Number(r.kwh) * 100) / 100 };
      });
      const total = Math.round(series.reduce(function (s, r) { return s + r.kwh; }, 0) * 100) / 100;
      return res.json({ series: series, total: total, period: period });

    } else if (period === "month") {
      const yearMonth = (date.slice(0, 7) || new Date().toISOString().slice(0, 7));
      const parts = yearMonth.split("-").map(Number);
      const y = parts[0], m = parts[1];
      const startDate = yearMonth + "-01";
      const lastDay = new Date(y, m, 0).getDate();
      const endDate = yearMonth + "-" + String(lastDay).padStart(2, "0");
      const [rows] = await q(SQL.statsDaily, [keynoStr, startDate, endDate]);
      const series = rows.map(function (r) {
        return { label: String(r.stat_date).slice(0, 10), kwh: Math.round(Number(r.kwh) * 100) / 100 };
      });
      const total = Math.round(series.reduce(function (s, r) { return s + r.kwh; }, 0) * 100) / 100;
      return res.json({ series: series, total: total, period: period });

    } else if (period === "year") {
      const year = (date.slice(0, 4) || String(new Date().getFullYear()));
      const [rows] = await q(SQL.statsMonthly, [keynoStr, Number(year)]);
      const series = rows.map(function (r) {
        return { label: String(r.stat_month), kwh: Math.round(Number(r.kwh) * 100) / 100 };
      });
      const total = Math.round(series.reduce(function (s, r) { return s + r.kwh; }, 0) * 100) / 100;
      return res.json({ series: series, total: total, period: period });

    } else {
      return res.status(400).json({ error: "지원하지 않는 기간입니다." });
    }
  })
);

// ── 공지사항 ─────────────────────────────────────────────────────────────────
function needAdmin(req, res, next) {
  const role = req.session && req.session.user && req.session.user.role;
  if (role === "admin" || role === "developer") return next();
  return res.status(403).json({ error: "관리자 권한이 필요합니다." });
}

function needDeveloper(req, res, next) {
  const role = req.session && req.session.user && req.session.user.role;
  if (role === "developer") return next();
  return res.status(403).json({ error: "개발자 권한이 필요합니다." });
}

app.get(
  "/api/notice",
  needLogin,
  errHandler(async function (req, res) {
    const category = String(req.query.category || "").trim();
    const wheres = ["del_yn = 'N'"];
    const params = [];
    if (category && category !== "all") {
      wheres.push("category = ?");
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
          tags: p.tags || "",
          siteName: p.site_name || "",
          title: p.title || "",
          author: p.author || "",
          views: Number(p.views) || 0,
          contents: p.contents || "",
          fileCount: Number(p.file_count) || 0,
          createdAt: p.created_at || "",
        };
      }),
    });
  })
);

app.post(
  "/api/notice",
  needLogin,
  needAdmin,
  errHandler(async function (req, res) {
    const b = req.body || {};
    const title = String(b.title || "").trim();
    if (!title) return res.status(400).json({ error: "제목을 입력하세요." });
    const author = req.session.user.displayName || req.session.user.username;
    const [r] = await q(SQL.boardInsert, [
      String(b.category || "").trim(),
      String(b.tags || "").trim(),
      String(b.siteName || "").trim(),
      title,
      author,
      String(b.contents || ""),
    ]);
    res.json({ ok: true, id: r.insertId });
  })
);

app.put(
  "/api/notice/:id",
  needLogin,
  needAdmin,
  errHandler(async function (req, res) {
    const id = Number(req.params.id);
    const b = req.body || {};
    const title = String(b.title || "").trim();
    if (!title) return res.status(400).json({ error: "제목을 입력하세요." });
    await q(SQL.boardUpdate, [
      String(b.category || "").trim(),
      String(b.tags || "").trim(),
      String(b.siteName || "").trim(),
      title,
      String(b.contents || ""),
      id,
    ]);
    res.json({ ok: true });
  })
);

app.delete(
  "/api/notice/:id",
  needLogin,
  needAdmin,
  errHandler(async function (req, res) {
    const id = Number(req.params.id);
    // 첨부파일도 함께 삭제
    const [files] = await q(SQL.noticeFiles, [id]);
    for (const f of files) {
      const fp = path.join(uploadDir, f.filename);
      if (fs.existsSync(fp)) fs.unlinkSync(fp);
    }
    await q("DELETE FROM dm_notice_files WHERE notice_id = ?", [id]);
    await q(SQL.boardDelete, [id]);
    res.json({ ok: true });
  })
);

// ── 공지사항 조회수 ───────────────────────────────────────────────────────────
app.post(
  "/api/notice/:id/view",
  needLogin,
  errHandler(async function (req, res) {
    await q(SQL.noticeViewInc, [Number(req.params.id)]);
    res.json({ ok: true });
  })
);

// ── 공지사항 첨부파일 ─────────────────────────────────────────────────────────
app.get(
  "/api/notice/:id/files",
  needLogin,
  errHandler(async function (req, res) {
    const [files] = await q(SQL.noticeFiles, [Number(req.params.id)]);
    res.json({ files: files.map(function (f) {
      return { id: f.id, name: f.original_name, size: f.size, mimetype: f.mimetype, url: "/uploads/notices/" + f.filename };
    })});
  })
);

app.post(
  "/api/notice/:id/files",
  needLogin,
  needAdmin,
  noticeUpload.single("file"),
  errHandler(async function (req, res) {
    if (!req.file) return res.status(400).json({ error: "파일이 없습니다." });
    const noticeId = Number(req.params.id);
    const originalName = Buffer.from(req.file.originalname, "latin1").toString("utf8");
    await q(SQL.noticeFileInsert, [
      noticeId,
      req.file.filename,
      originalName,
      req.file.size,
      req.file.mimetype,
    ]);
    res.json({ ok: true, file: { name: originalName, size: req.file.size, url: "/uploads/notices/" + req.file.filename } });
  })
);

app.get(
  "/api/notice/files/:fileId/download",
  needLogin,
  errHandler(async function (req, res) {
    const [[file]] = await q(SQL.noticeFileGet, [Number(req.params.fileId)]);
    if (!file) return res.status(404).json({ error: "파일을 찾을 수 없습니다." });
    const fp = path.join(uploadDir, file.filename);
    if (!fs.existsSync(fp)) return res.status(404).json({ error: "파일이 존재하지 않습니다." });
    res.download(fp, file.original_name);
  })
);

app.delete(
  "/api/notice/:id/files/:fileId",
  needLogin,
  needAdmin,
  errHandler(async function (req, res) {
    const [[file]] = await q(SQL.noticeFileGet, [Number(req.params.fileId)]);
    if (!file) return res.status(404).json({ error: "파일을 찾을 수 없습니다." });
    const fp = path.join(uploadDir, file.filename);
    if (fs.existsSync(fp)) fs.unlinkSync(fp);
    await q(SQL.noticeFileDelete, [Number(req.params.fileId), Number(req.params.id)]);
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
      username: u.username || "",
      mobile: u.phone || "",
      email: u.email || "",
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

// ── 주소 검색 (Kakao Local API 프록시) ──────────────────────────────────────
app.get(
  "/api/address-search",
  needLogin,
  errHandler(async function (req, res) {
    const searchQuery = String(req.query.q || "").trim();
    if (!searchQuery || searchQuery.length < 2) return res.json({ items: [] });
    const _keys = await getMapKeys(getDb());
    const kakaoKey = _keys.kakaoRest || _keys.kakao || process.env.KAKAO_REST_KEY || process.env.KAKAO_MAP_KEY;
    if (!kakaoKey) return res.json({ items: [] });
    const parsed = new URL(
      "https://dapi.kakao.com/v2/local/search/address.json?query=" +
      encodeURIComponent(searchQuery) + "&size=10"
    );
    const data = await new Promise(function (resolve, reject) {
      https.get(
        { hostname: parsed.hostname, path: parsed.pathname + parsed.search,
          headers: { Authorization: "KakaoAK " + kakaoKey } },
        function (r) {
          let raw = "";
          r.on("data", function (c) { raw += c; });
          r.on("end", function () {
            try { resolve(JSON.parse(raw)); } catch (e) { reject(e); }
          });
        }
      ).on("error", reject);
    });
    res.json({
      items: (data.documents || []).map(function (doc) {
        return { address: doc.address_name, lat: Number(doc.y), lng: Number(doc.x) };
      }),
    });
  })
);

// ── 주소 → 좌표 변환 (Kakao 주소 검색 API 프록시) ───────────────────────────
app.get(
  "/api/geocode",
  needLogin,
  errHandler(async function (req, res) {
    const address = String(req.query.address || "").trim();
    if (!address) return res.json({ lat: null, lng: null });

    const _keys = await getMapKeys(getDb());
    const kakaoKey = _keys.kakaoRest || _keys.kakao || process.env.KAKAO_REST_KEY || process.env.KAKAO_MAP_KEY;
    if (!kakaoKey) return res.status(400).json({ error: "Kakao API 키가 없습니다." });

    const parsed = new URL(
      "https://dapi.kakao.com/v2/local/search/address.json?query=" +
      encodeURIComponent(address)
    );

    const data = await new Promise(function (resolve, reject) {
      https.get(
        { hostname: parsed.hostname, path: parsed.pathname + parsed.search,
          headers: {
            Authorization: "KakaoAK " + kakaoKey,
            KA: "sdk/1.0.0 os/nodejs origin/localhost",
          } },
        function (r) {
          let raw = "";
          r.on("data", function (c) { raw += c; });
          r.on("end", function () {
            try { resolve(JSON.parse(raw)); } catch (e) { reject(e); }
          });
        }
      ).on("error", reject);
    });

    const doc = data.documents && data.documents[0];
    if (doc) {
      res.json({ lat: Number(doc.y), lng: Number(doc.x) });
    } else {
      res.json({ lat: null, lng: null, message: "주소를 찾을 수 없습니다." });
    }
  })
);

// ── 안전관리 ─────────────────────────────────────────────────────────────────
// 달력용: 월별 점검 기록
app.get("/api/safety", needLogin, errHandler(async function(req, res) {
  const year  = Number(req.query.year  || new Date().getFullYear());
  const month = Number(req.query.month || new Date().getMonth() + 1);
  const from = `${year}-${String(month).padStart(2,"0")}-01`;
  const to   = `${year}-${String(month).padStart(2,"0")}-${new Date(year,month,0).getDate()}`;
  const [rows] = await q(
    "SELECT s.id, s.plant_id, p.name AS plant_name, s.type, s.inspect_date, s.content, s.created_by" +
    " FROM dm_safety s LEFT JOIN dm_plant p ON p.id = s.plant_id" +
    " WHERE s.inspect_date BETWEEN ? AND ? ORDER BY s.inspect_date, p.name",
    [from, to]
  );
  res.json({ records: rows });
}));

// 발전소 전체 점검 기록 (관리 페이지용)
app.get("/api/safety/plant/:plantId", needLogin, errHandler(async function(req, res) {
  const plantId = Number(req.params.plantId);
  const year  = Number(req.query.year  || 0);
  const month = Number(req.query.month || 0);
  let sql = "SELECT id, plant_id, type, inspect_date, content, created_by, created_at FROM dm_safety WHERE plant_id=?";
  const params = [plantId];
  if (year && month) {
    const from = `${year}-${String(month).padStart(2,"0")}-01`;
    const to   = `${year}-${String(month).padStart(2,"0")}-${new Date(year,month,0).getDate()}`;
    sql += " AND inspect_date BETWEEN ? AND ?";
    params.push(from, to);
  }
  sql += " ORDER BY inspect_date ASC, id ASC";
  const [rows] = await q(sql, params);
  res.json({ records: rows });
}));

// 점검 추가
app.post("/api/safety/records", needLogin, errHandler(async function(req, res) {
  const b = req.body || {};
  if (!b.plantId || !b.inspectDate) return res.status(400).json({ error: "발전소와 점검일을 입력하세요." });
  const [r] = await q(
    "INSERT INTO dm_safety (plant_id, type, inspect_date, content, created_by) VALUES (?,?,?,?,?)",
    [Number(b.plantId), b.type||"안전관리", b.inspectDate, b.content||"",
     req.session.user.displayName || req.session.user.username]
  );
  res.json({ ok: true, id: r.insertId });
}));

// 점검 삭제 (날짜+발전소로 삭제 또는 ID로 삭제)
app.delete("/api/safety/records/:id", needLogin, errHandler(async function(req, res) {
  await q("DELETE FROM dm_safety WHERE id=?", [Number(req.params.id)]);
  res.json({ ok: true });
}));

// 점검 내용 수정
app.put("/api/safety/records/:id", needLogin, errHandler(async function(req, res) {
  const b = req.body || {};
  await q("UPDATE dm_safety SET type=?, content=? WHERE id=?",
    [b.type||"안전관리", b.content||"", Number(req.params.id)]);
  res.json({ ok: true });
}));

// ── RTU 장비관리 ─────────────────────────────────────────────────────────────

// 발전소별 RTU 현황 목록 (/api/sites 와 동일한 계정 필터 적용)
app.get("/api/equipment/rtu", needLogin, errHandler(async function(req, res) {
  const sessionUser = req.session.user;
  const wheres = ["p.del_yn = 'N'", "p.grid_status = 'Y'"];
  const params  = [];
  // partner_admin / safety_admin 은 배정된 발전소만
  if (sessionUser && (sessionUser.role === "partner_admin" || sessionUser.role === "safety_admin")) {
    const [pRows] = await q("SELECT plant_id FROM dm_user_plants WHERE user_id = ?", [sessionUser.id]);
    const ids = pRows.map(function(r) { return r.plant_id; });
    if (ids.length === 0) return res.json({ rtu: [] });
    wheres.push("p.id IN (" + ids.map(function() { return "?"; }).join(",") + ")");
    params.push(...ids);
  }
  const [rows] = await q(
    "SELECT p.id AS plant_id, p.name AS plant_name, p.region," +
    " r.id AS rtu_id, r.serial, r.hw_ver, r.sw_ver, r.line_type, r.ctn, r.note, r.updated_at, r.updated_by" +
    " FROM dm_plant p LEFT JOIN dm_rtu r ON r.plant_id = p.id" +
    " WHERE " + wheres.join(" AND ") +
    " ORDER BY p.region, p.name",
    params
  );
  res.json({ rtu: rows });
}));

// RTU 등록/수정 (upsert)
app.put("/api/equipment/rtu/:plantId", needLogin, errHandler(async function(req, res) {
  const plantId = Number(req.params.plantId);
  const b = req.body || {};
  const user = req.session.user.displayName || req.session.user.username;
  await q(
    "INSERT INTO dm_rtu (plant_id, serial, hw_ver, sw_ver, line_type, ctn, note, updated_by)" +
    " VALUES (?,?,?,?,?,?,?,?)" +
    " ON DUPLICATE KEY UPDATE serial=VALUES(serial), hw_ver=VALUES(hw_ver)," +
    " sw_ver=VALUES(sw_ver), line_type=VALUES(line_type), ctn=VALUES(ctn)," +
    " note=VALUES(note), updated_by=VALUES(updated_by), updated_at=NOW()",
    [plantId, b.serial||null, b.hwVer||null, b.swVer||null,
     b.lineType||'유선', b.ctn||null, b.note||null, user]
  );
  res.json({ ok: true });
}));

// HW 버전 목록
app.get("/api/equipment/hw-versions", needLogin, errHandler(async function(req, res) {
  const [rows] = await q("SELECT * FROM dm_hw_version ORDER BY release_date DESC, id DESC");
  res.json({ versions: rows });
}));

// HW 버전 추가
app.post("/api/equipment/hw-versions", needLogin, errHandler(async function(req, res) {
  const b = req.body || {};
  if (!b.version) return res.status(400).json({ error: "버전을 입력하세요." });
  const [r] = await q(
    "INSERT INTO dm_hw_version (version, release_date, description) VALUES (?,?,?)",
    [b.version, b.releaseDate || new Date().toISOString().slice(0,10), b.description||null]
  );
  res.json({ ok: true, id: r.insertId });
}));

// HW 버전 수정
app.put("/api/equipment/hw-versions/:id", needLogin, errHandler(async function(req, res) {
  const b = req.body || {};
  await q("UPDATE dm_hw_version SET version=?, release_date=?, description=? WHERE id=?",
    [b.version, b.releaseDate, b.description||null, Number(req.params.id)]);
  res.json({ ok: true });
}));

// HW 버전 삭제
app.delete("/api/equipment/hw-versions/:id", needLogin, errHandler(async function(req, res) {
  await q("DELETE FROM dm_hw_version WHERE id=?", [Number(req.params.id)]);
  res.json({ ok: true });
}));

// SW 버전 목록
app.get("/api/equipment/sw-versions", needLogin, errHandler(async function(req, res) {
  const [rows] = await q("SELECT * FROM dm_sw_version ORDER BY release_date DESC, id DESC");
  res.json({ versions: rows });
}));

// SW 버전 추가
app.post("/api/equipment/sw-versions", needLogin, errHandler(async function(req, res) {
  const b = req.body || {};
  if (!b.version) return res.status(400).json({ error: "버전을 입력하세요." });
  const [r] = await q(
    "INSERT INTO dm_sw_version (version, release_date, description) VALUES (?,?,?)",
    [b.version, b.releaseDate || new Date().toISOString().slice(0,10), b.description||null]
  );
  res.json({ ok: true, id: r.insertId });
}));

// SW 버전 수정
app.put("/api/equipment/sw-versions/:id", needLogin, errHandler(async function(req, res) {
  const b = req.body || {};
  await q("UPDATE dm_sw_version SET version=?, release_date=?, description=? WHERE id=?",
    [b.version, b.releaseDate, b.description||null, Number(req.params.id)]);
  res.json({ ok: true });
}));

// SW 버전 삭제
app.delete("/api/equipment/sw-versions/:id", needLogin, errHandler(async function(req, res) {
  await q("DELETE FROM dm_sw_version WHERE id=?", [Number(req.params.id)]);
  res.json({ ok: true });
}));

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
  buildPlantSelect();
  app.listen(PORT, function () {
    console.log("DAEYANG monitoring: http://localhost:" + PORT);
    console.log("DB:", DB_CONFIG.database, "@", DB_CONFIG.host);
  });
}

start().catch(function (e) {
  console.error(e);
  process.exit(1);
});
