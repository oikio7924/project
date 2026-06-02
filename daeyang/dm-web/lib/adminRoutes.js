const { roleLabel } = require("./migrateAdmin");
const { getMapKeys, saveMapKeys } = require("./mapSettings");

function registerAdminRoutes(app, deps) {
  const { q, errHandler, needLogin, encodeSpringPassword, getDb } = deps;

  function needAdmin(req, res, next) {
    needLogin(req, res, function () {
      const role = req.session.user && req.session.user.role;
      if (role === "admin" || role === "site_admin") return next();
      return res.status(403).json({ error: "관리자 권한이 필요합니다." });
    });
  }

  // dy_power_plant 행 → 관리자 발전소 객체
  function mapAdminPlant(row) {
    return {
      id: Number(row.id || row.DPP_KEYNO),
      name: String(row.name || row.DPP_NAME || ""),
      region: String(row.region || row.DPP_AREA || ""),
      address: String(row.address || row.DPP_LOCATION || ""),
      lat: row.lat != null ? Number(row.lat) : null,
      lng: row.lng != null ? Number(row.lng) : null,
      capacityKw: parseFloat(row.capacity_kw || row.DPP_VOLUM || 0) || 0,
      inverterCount: Number(row.inverter_count || row.DPP_INVER_COUNT || 0),
      gridStatus: (row.DPP_STATUS === "Y" || row.gridStatus === "계통") ? "계통" : "미계통",
      inverterSn: String(row.DPP_SN || ""),
      inverterCapacityNote: "",
      ownerUserId: row.DPP_USER || null,
      registeredAt: row.DPP_DATE || "",
      createdAt: row.DPP_DATE || "",
    };
  }

  // ── 회원 관리 (u_userinfo) ────────────────────────────
  app.get(
    "/api/admin/members",
    needAdmin,
    errHandler(async function (req, res) {
      const page = Math.max(1, Number(req.query.page) || 1);
      const limit = Math.min(100, Math.max(1, Number(req.query.limit) || 25));
      const offset = (page - 1) * limit;
      const qstr = String(req.query.q || "").trim();
      const withdrawn = req.query.withdrawn === "1";

      const wheres = ["UI_DELYN = ?"];
      const params = [withdrawn ? "Y" : "N"];
      if (qstr) {
        wheres.push("(UI_ID LIKE ? OR UI_NAME LIKE ? OR UI_EMAIL LIKE ?)");
        const like = "%" + qstr + "%";
        params.push(like, like, like);
      }
      const where = "WHERE " + wheres.join(" AND ");

      const [[{ total }]] = await q(
        "SELECT COUNT(*) AS total FROM u_userinfo " + where,
        params
      );
      const [rows] = await q(
        "SELECT UI_KEYNO, UI_ID, UI_NAME, UI_EMAIL, UI_PHONE, UI_REGDT, UI_LASTLOGIN, UI_DELYN" +
          " FROM u_userinfo " +
          where +
          " ORDER BY UI_REGDT DESC LIMIT " + offset + ", " + limit,
        params
      );
      res.json({
        page: page,
        limit: limit,
        total: Number(total),
        totalPages: Math.max(1, Math.ceil(Number(total) / limit)),
        members: rows.map(function (r) {
          return {
            id: r.UI_KEYNO,
            username: r.UI_ID,
            displayName: r.UI_NAME,
            role: "user",
            roleLabel: "일반유저",
            email: r.UI_EMAIL || "",
            mobile: r.UI_PHONE || "",
            createdAt: r.UI_REGDT || "",
            lastLoginAt: r.UI_LASTLOGIN || null,
            isVerified: true,
            kakaoNotify: false,
          };
        }),
      });
    })
  );

  app.post(
    "/api/admin/members",
    needAdmin,
    errHandler(async function (req, res) {
      const body = req.body || {};
      const username = String(body.username || "").trim();
      const password = String(body.password || "1111");
      const displayName = String(body.displayName || username);
      if (!username) return res.status(400).json({ error: "아이디가 필요합니다." });
      const encoded = encodeSpringPassword(password);
      const keyno = "UI_" + Math.random().toString(36).slice(2, 7).toUpperCase();
      await q(
        "INSERT INTO u_userinfo (UI_KEYNO, UI_ID, UI_PASSWORD, UI_NAME, UI_EMAIL, UI_PHONE, UI_DELYN, UI_REGDT)" +
          " VALUES (?,?,?,?,?,?,'N',NOW())",
        [keyno, username, encoded, displayName, body.email || "", body.mobile || ""]
      );
      res.json({ ok: true });
    })
  );

  app.put(
    "/api/admin/members/:id",
    needAdmin,
    errHandler(async function (req, res) {
      const id = String(req.params.id);
      const b = req.body || {};
      const displayName = String(b.displayName || "").trim();
      if (b.password) {
        const encoded = encodeSpringPassword(String(b.password));
        await q(
          "UPDATE u_userinfo SET UI_NAME=?, UI_EMAIL=?, UI_PHONE=?, UI_PASSWORD=?, UI_PASSWORD_CHDT=NOW() WHERE UI_KEYNO=?",
          [displayName, b.email || "", b.mobile || "", encoded, id]
        );
      } else {
        await q(
          "UPDATE u_userinfo SET UI_NAME=?, UI_EMAIL=?, UI_PHONE=? WHERE UI_KEYNO=?",
          [displayName, b.email || "", b.mobile || "", id]
        );
      }
      res.json({ ok: true });
    })
  );

  app.get(
    "/api/admin/member-options",
    needAdmin,
    errHandler(async function (req, res) {
      const [rows] = await q(
        "SELECT UI_KEYNO, UI_ID, UI_NAME FROM u_userinfo WHERE UI_DELYN = 'N' ORDER BY UI_ID"
      );
      res.json({
        options: rows.map(function (r) {
          return { id: r.UI_KEYNO, username: r.UI_ID, displayName: r.UI_NAME };
        }),
      });
    })
  );

  // ── 발전소 관리 (dy_power_plant) ──────────────────────
  const ADMIN_PLANT_SELECT =
    "SELECT DPP_KEYNO AS id, DPP_NAME AS name, DPP_AREA AS region," +
    " DPP_LOCATION AS address, DPP_X_LOCATION AS lat, DPP_Y_LOCATION AS lng," +
    " CAST(DPP_VOLUM AS DECIMAL(12,2)) AS capacity_kw," +
    " DPP_INVER_COUNT AS inverter_count, DPP_DATE AS registered_at," +
    " DPP_STATUS, DPP_SN, DPP_USER FROM dy_power_plant ";

  app.get(
    "/api/admin/plants",
    needAdmin,
    errHandler(async function (req, res) {
      const page = Math.max(1, Number(req.query.page) || 1);
      const limit = Math.min(100, Math.max(1, Number(req.query.limit) || 25));
      const offset = (page - 1) * limit;
      const region = String(req.query.region || "").trim();
      const name = String(req.query.name || "").trim();
      const wheres = ["DPP_DEL_YN = 'N'"];
      const params = [];
      if (region) { wheres.push("DPP_AREA LIKE ?"); params.push("%" + region + "%"); }
      if (name) { wheres.push("DPP_NAME LIKE ?"); params.push("%" + name + "%"); }
      const where = "WHERE " + wheres.join(" AND ");
      const [[{ total }]] = await q(
        "SELECT COUNT(*) AS total FROM dy_power_plant " + where,
        params
      );
      const [rows] = await q(
        ADMIN_PLANT_SELECT + where + " ORDER BY DPP_KEYNO DESC LIMIT " + offset + ", " + limit,
        params
      );
      res.json({
        page: page,
        total: Number(total),
        totalPages: Math.max(1, Math.ceil(Number(total) / limit)),
        plants: rows.map(mapAdminPlant),
      });
    })
  );

  app.get(
    "/api/admin/plants/:id",
    needAdmin,
    errHandler(async function (req, res) {
      const [rows] = await q(
        ADMIN_PLANT_SELECT + "WHERE DPP_KEYNO = ? AND DPP_DEL_YN = 'N' LIMIT 1",
        [Number(req.params.id)]
      );
      if (!rows.length) return res.status(404).json({ error: "발전소를 찾을 수 없습니다." });
      res.json(mapAdminPlant(rows[0]));
    })
  );

  app.post(
    "/api/admin/plants",
    needAdmin,
    errHandler(async function (req, res) {
      const b = req.body || {};
      const name = String(b.name || "").trim();
      if (!name) return res.status(400).json({ error: "발전소명이 필요합니다." });
      const status = b.gridStatus === "계통" ? "Y" : "N";
      const [r] = await q(
        "INSERT INTO dy_power_plant (DPP_NAME, DPP_AREA, DPP_LOCATION, DPP_X_LOCATION, DPP_Y_LOCATION," +
          " DPP_VOLUM, DPP_INVER_COUNT, DPP_SN, DPP_STATUS, DPP_DEL_YN, DPP_USER, DPP_DATE)" +
          " VALUES (?,?,?,?,?,?,?,?,?,'N',?,NOW())",
        [
          name,
          b.region || "",
          b.address || "",
          b.lat || null,
          b.lng || null,
          String(b.capacityKw || 0),
          Number(b.inverterCount) || 0,
          b.inverterSn || "",
          status,
          b.ownerUserId || null,
        ]
      );
      res.json({ ok: true, id: r.insertId });
    })
  );

  app.put(
    "/api/admin/plants/:id",
    needAdmin,
    errHandler(async function (req, res) {
      const id = Number(req.params.id);
      const b = req.body || {};
      const status = b.gridStatus === "계통" ? "Y" : "N";
      await q(
        "UPDATE dy_power_plant SET DPP_NAME=?, DPP_AREA=?, DPP_LOCATION=?," +
          " DPP_X_LOCATION=?, DPP_Y_LOCATION=?, DPP_VOLUM=?, DPP_INVER_COUNT=?," +
          " DPP_SN=?, DPP_STATUS=?, DPP_USER=? WHERE DPP_KEYNO=? AND DPP_DEL_YN='N'",
        [
          b.name || "",
          b.region || "",
          b.address || "",
          b.lat || null,
          b.lng || null,
          String(b.capacityKw || 0),
          Number(b.inverterCount) || 0,
          b.inverterSn || "",
          status,
          b.ownerUserId || null,
          id,
        ]
      );
      res.json({ ok: true });
    })
  );

  app.delete(
    "/api/admin/plants/:id",
    needAdmin,
    errHandler(async function (req, res) {
      await q(
        "UPDATE dy_power_plant SET DPP_DEL_YN='Y' WHERE DPP_KEYNO=?",
        [Number(req.params.id)]
      );
      res.json({ ok: true });
    })
  );

  // ── 지도 API 키 설정 ────────────────────────────────────
  app.get(
    "/api/admin/settings/maps",
    needAdmin,
    errHandler(async function (req, res) {
      res.json(await getMapKeys(getDb()));
    })
  );

  app.put(
    "/api/admin/settings/maps",
    needAdmin,
    errHandler(async function (req, res) {
      const b = req.body || {};
      await saveMapKeys(getDb(), {
        google: String(b.google || "").trim(),
        naver: String(b.naver || "").trim(),
        kakao: String(b.kakao || "").trim(),
      });
      res.json({ ok: true });
    })
  );
}

module.exports = { registerAdminRoutes };
