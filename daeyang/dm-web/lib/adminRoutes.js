const { roleLabel } = require("./migrateAdmin");
const { getMapKeys, saveMapKeys } = require("./mapSettings");

function registerAdminRoutes(app, deps) {
  const { q, errHandler, needLogin, encodeSpringPassword, getDb } = deps;

  function needAdmin(req, res, next) {
    needLogin(req, res, function () {
      const role = req.session.user && req.session.user.role;
      if (role === "admin" || role === "developer") return next();
      return res.status(403).json({ error: "관리자 권한이 필요합니다." });
    });
  }

  function needDeveloper(req, res, next) {
    needLogin(req, res, function () {
      const role = req.session.user && req.session.user.role;
      if (role === "developer") return next();
      return res.status(403).json({ error: "개발자 권한이 필요합니다." });
    });
  }

  function mapAdminPlant(row) {
    return {
      id: Number(row.id),
      name: String(row.name || ""),
      region: String(row.region || ""),
      address: String(row.address || ""),
      lat: row.lat != null ? Number(row.lat) : null,
      lng: row.lng != null ? Number(row.lng) : null,
      capacityKw: parseFloat(row.capacity_kw) || 0,
      inverterCount: Number(row.inverter_count) || 0,
      gridStatus: row.grid_status === "Y" ? "계통" : "미계통",
      invBrand: String(row.inv_brand || ""),
      inverterSn: String(row.inverter_sn || ""),
      inverterCapacityNote: "",
      ownerUserId: row.owner_id || null,
      registeredAt: row.registered_at || "",
      createdAt: row.registered_at || "",
    };
  }

  // ── 회원 관리 (dm_user) ────────────────────────────────────
  app.get(
    "/api/admin/members",
    needAdmin,
    errHandler(async function (req, res) {
      const qstr = String(req.query.q || "").trim();
      const withdrawn = req.query.withdrawn === "1";

      const wheres = ["del_yn = ?"];
      const params = [withdrawn ? "Y" : "N"];
      if (qstr) {
        wheres.push("(username LIKE ? OR display_name LIKE ? OR email LIKE ?)");
        const like = "%" + qstr + "%";
        params.push(like, like, like);
      }
      const where = "WHERE " + wheres.join(" AND ");

      const [rows] = await q(
        "SELECT id, username, display_name, email, phone, role, registered_at, last_login_at, del_yn" +
          " FROM dm_user " + where + " ORDER BY registered_at DESC",
        params
      );
      // partner_admin의 배정 발전소 일괄 조회
      const partnerIds = rows.filter(r => r.role === "partner_admin").map(r => r.id);
      let plantMap = {};
      if (partnerIds.length > 0) {
        const [pRows] = await q(
          "SELECT user_id, plant_id FROM dm_user_plants WHERE user_id IN (" + partnerIds.map(() => "?").join(",") + ")",
          partnerIds
        );
        pRows.forEach(function(p) {
          if (!plantMap[p.user_id]) plantMap[p.user_id] = [];
          plantMap[p.user_id].push(p.plant_id);
        });
      }
      res.json({
        total: rows.length,
        members: rows.map(function (r) {
          return {
            id: r.id,
            username: r.username,
            name: r.display_name,
            role: r.role || "user",
            email: r.email || "",
            phone: r.phone || "",
            createdAt: r.registered_at || "",
            lastLogin: r.last_login_at || null,
            plants: plantMap[r.id] || [],
          };
        }),
      });
    })
  );

  async function savePlants(userId, plantIds) {
    await q("DELETE FROM dm_user_plants WHERE user_id = ?", [userId]);
    if (plantIds && plantIds.length > 0) {
      const placeholders = plantIds.map(() => "(?,?)").join(",");
      const params = plantIds.flatMap((pid) => [userId, pid]);
      await q("INSERT IGNORE INTO dm_user_plants (user_id, plant_id) VALUES " + placeholders, params);
    }
  }

  app.post(
    "/api/admin/members",
    needAdmin,
    errHandler(async function (req, res) {
      const body = req.body || {};
      const username = String(body.username || "").trim();
      const password = String(body.password || "1111");
      const displayName = String(body.name || body.displayName || username);
      const role = String(body.role || "user");
      if (!username) return res.status(400).json({ error: "아이디가 필요합니다." });
      const keyno = "UI_" + Math.random().toString(36).slice(2, 7).toUpperCase();
      await q(
        "INSERT INTO dm_user (id, username, password, display_name, email, phone, role, del_yn)" +
          " VALUES (?,?,?,?,?,?,?,'N')",
        [keyno, username, password, displayName, body.email || "", body.mobile || "", role]
      );
      if (role === "partner_admin") await savePlants(keyno, body.plants || []);
      res.json({ ok: true });
    })
  );

  app.put(
    "/api/admin/members/:id",
    needAdmin,
    errHandler(async function (req, res) {
      const id = String(req.params.id);
      const b = req.body || {};
      const displayName = String(b.name || b.displayName || "").trim();
      const role = String(b.role || "user");
      if (b.password) {
        await q(
          "UPDATE dm_user SET display_name=?, email=?, phone=?, role=?, password=?, password_changed_at=NOW() WHERE id=?",
          [displayName, b.email || "", b.mobile || "", role, String(b.password), id]
        );
      } else {
        await q(
          "UPDATE dm_user SET display_name=?, email=?, phone=?, role=? WHERE id=?",
          [displayName, b.email || "", b.mobile || "", role, id]
        );
      }
      if (role === "partner_admin") await savePlants(id, b.plants || []);
      else await q("DELETE FROM dm_user_plants WHERE user_id = ?", [id]);
      res.json({ ok: true });
    })
  );

  app.get(
    "/api/admin/member-options",
    needAdmin,
    errHandler(async function (req, res) {
      const [rows] = await q(
        "SELECT id, username, display_name FROM dm_user WHERE del_yn = 'N' ORDER BY username"
      );
      res.json({
        options: rows.map(function (r) {
          return { id: r.id, username: r.username, displayName: r.display_name };
        }),
      });
    })
  );

  // ── 발전소 관리 (dm_plant) ─────────────────────────────────
  const ADMIN_PLANT_SELECT =
    "SELECT id, name, region, address, lat, lng," +
    " capacity_kw, inverter_count, registered_at," +
    " grid_status, inverter_sn, inv_brand, owner_id FROM dm_plant ";

  app.get(
    "/api/admin/plants",
    needAdmin,
    errHandler(async function (req, res) {
      const region = String(req.query.region || "").trim();
      const name = String(req.query.name || "").trim();
      const qstr = String(req.query.q || "").trim();
      const wheres = ["del_yn = 'N'"];
      const params = [];
      if (region) { wheres.push("region LIKE ?"); params.push("%" + region + "%"); }
      if (name)   { wheres.push("name LIKE ?");   params.push("%" + name + "%"); }
      if (qstr)   { wheres.push("name LIKE ?");   params.push("%" + qstr + "%"); }
      const where = "WHERE " + wheres.join(" AND ");
      const [rows] = await q(
        ADMIN_PLANT_SELECT + where + " ORDER BY id DESC",
        params
      );
      res.json({
        total: rows.length,
        plants: rows.map(mapAdminPlant),
      });
    })
  );

  app.get(
    "/api/admin/plants/:id",
    needAdmin,
    errHandler(async function (req, res) {
      const [rows] = await q(
        ADMIN_PLANT_SELECT + "WHERE id = ? AND del_yn = 'N' LIMIT 1",
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
      const gridStatus = b.gridStatus === "계통" ? "Y" : "N";
      const [r] = await q(
        "INSERT INTO dm_plant (name, region, address, lat, lng," +
          " capacity_kw, inverter_count, inverter_sn, grid_status, del_yn, owner_id)" +
          " VALUES (?,?,?,?,?,?,?,?,?,'N',?)",
        [
          name,
          b.region || "",
          b.address || "",
          b.lat || null,
          b.lng || null,
          String(b.capacityKw || 0),
          Number(b.inverterCount) || 0,
          b.inverterSn || "",
          gridStatus,
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
      const gridStatus = b.gridStatus === "계통" ? "Y" : "N";
      await q(
        "UPDATE dm_plant SET name=?, region=?, address=?," +
          " lat=?, lng=?, capacity_kw=?, inverter_count=?," +
          " inverter_sn=?, grid_status=?, owner_id=? WHERE id=? AND del_yn='N'",
        [
          b.name || "",
          b.region || "",
          b.address || "",
          b.lat || null,
          b.lng || null,
          String(b.capacityKw || 0),
          Number(b.inverterCount) || 0,
          b.inverterSn || "",
          gridStatus,
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
        "UPDATE dm_plant SET del_yn='Y' WHERE id=?",
        [Number(req.params.id)]
      );
      res.json({ ok: true });
    })
  );

  // ── 인버터 정보 관리 (dm_inverter_info) ──────────────────
  app.get(
    "/api/admin/inverter-info/:siteId",
    needAdmin,
    errHandler(async function (req, res) {
      const siteId = Number(req.params.siteId);
      const [infoRows] = await q(
        "SELECT inverter_name, model, capacity_kw, memo FROM dm_inverter_info WHERE site_id = ? ORDER BY id",
        [siteId]
      );
      const [nameRows] = await q(
        "SELECT DISTINCT inverter_name FROM dm_inverter_data WHERE site_id = ? ORDER BY inverter_name",
        [siteId]
      );
      res.json({
        inverters: infoRows.map(function (r) {
          return { name: r.inverter_name, model: r.model, capacityKw: Number(r.capacity_kw) || 0, memo: r.memo };
        }),
        detectedNames: nameRows.map(function (r) { return r.inverter_name; }),
      });
    })
  );

  app.put(
    "/api/admin/inverter-info/:siteId",
    needAdmin,
    errHandler(async function (req, res) {
      const siteId = Number(req.params.siteId);
      const inverters = Array.isArray((req.body || {}).inverters) ? req.body.inverters : [];
      await q("DELETE FROM dm_inverter_info WHERE site_id = ?", [siteId]);
      const validInverters = inverters.filter((inv) => String(inv.name || "").trim());
      if (validInverters.length > 0) {
        const placeholders = validInverters.map(() => "(?,?,?,?,?)").join(",");
        const params = validInverters.flatMap((inv) => [
          siteId,
          String(inv.name).trim(),
          String(inv.model || ""),
          Number(inv.capacityKw) || 0,
          String(inv.memo || ""),
        ]);
        await q("INSERT INTO dm_inverter_info (site_id, inverter_name, model, capacity_kw, memo) VALUES " + placeholders, params);
      }
      res.json({ ok: true });
    })
  );

  // ── 지도 API 키 설정 (개발자 전용) ─────────────────────────
  app.get(
    "/api/admin/settings/maps",
    needDeveloper,
    errHandler(async function (req, res) {
      res.json(await getMapKeys(getDb()));
    })
  );

  app.put(
    "/api/admin/settings/maps",
    needDeveloper,
    errHandler(async function (req, res) {
      const b = req.body || {};
      await saveMapKeys(getDb(), {
        google:    String(b.google    || "").trim(),
        naver:     String(b.naver     || "").trim(),
        kakao:     String(b.kakao     || "").trim(),
        kakaoRest: String(b.kakaoRest || "").trim(),
      });
      res.json({ ok: true });
    })
  );
}

module.exports = { registerAdminRoutes };
