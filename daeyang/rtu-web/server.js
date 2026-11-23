require('dotenv').config({ quiet: true });
const express = require('express');
const mysql = require('mysql2/promise');
const XLSX = require('xlsx');
const path = require('path');
const session = require('express-session');
const bcrypt = require('bcryptjs');
const rateLimit = require('express-rate-limit');
const { SHEETS, byKey, editableFields } = require('./lib/sheets');
const { DPP_FIELDS, RTU_READ_FIELDS, snToSnNum, fromInverters } = require('./lib/dpp');
const { buildIndex, matchName } = require('./lib/match');
const { parseSetupForm } = require('./lib/setupForm');

const app = express();
const PORT = Number(process.env.PORT || 3003);
const BASE_PATH = (process.env.BASE_PATH || '').replace(/\/$/, '');

const DB_CONFIG = {
  host: process.env.MARIADB_HOST || 'localhost',
  port: Number(process.env.MARIADB_PORT || 3306),
  user: process.env.MARIADB_USER || '',
  password: process.env.MARIADB_PASSWORD || '',
  database: process.env.MARIADB_DATABASE || '',
  waitForConnections: true,
  connectionLimit: 5,
  dateStrings: true,
  timezone: '+09:00',
  charset: 'utf8mb4',
};

let dbPool = null;
function getDb() {
  if (!dbPool) dbPool = mysql.createPool(DB_CONFIG);
  return dbPool;
}

function errHandler(fn) {
  return async (req, res) => {
    try {
      await fn(req, res);
    } catch (e) {
      console.error(e);
      res.status(e.status || 500).json({ error: e.status ? e.message : '서버 오류: ' + e.message });
    }
  };
}

function badRequest(msg) {
  const e = new Error(msg);
  e.status = 400;
  return e;
}

// 트랜잭션: 중간에 실패하면 전부 되돌린다
async function withTx(fn) {
  const conn = await getDb().getConnection();
  try {
    await conn.beginTransaction();
    const out = await fn(conn);
    await conn.commit();
    return out;
  } catch (e) {
    await conn.rollback();
    throw e;
  } finally {
    conn.release();
  }
}

// 다음 ID (P0001, S0001 ...) — 트랜잭션 안에서 잠그고 계산
async function nextId(conn, table, idField, prefix) {
  const [[row]] = await conn.query(
    `SELECT MAX(CAST(SUBSTRING(${idField}, 2) AS UNSIGNED)) AS n FROM ${table} WHERE ${idField} LIKE ? FOR UPDATE`,
    [prefix + '%']
  );
  return prefix + String((Number(row.n) || 0) + 1).padStart(4, '0');
}

async function logChange(conn, req, table, rowKey, action, before, after) {
  await conn.query(
    'INSERT INTO rtm_change_log (table_name, row_key, action, before_json, after_json, user_id, username) VALUES (?, ?, ?, ?, ?, ?, ?)',
    [table, String(rowKey), action,
      before ? JSON.stringify(before) : null, after ? JSON.stringify(after) : null,
      req.session.userId || null, req.session.username || null]
  );
}

const DATE_RE = /^\d{4}-\d{2}-\d{2}$/;

// 입력값 정리: 시트에 정의된 저장 칸만, 빈 값은 NULL, 날짜·숫자 검사
function cleanRow(sheet, body, { partial = false } = {}) {
  const out = {};
  for (const f of editableFields(sheet)) {
    if (partial && !(f in body)) continue;
    const col = sheet.columns.find(c => c.f === f);
    let v = body[f];
    if (v === undefined || v === null || String(v).trim() === '') {
      if (col.required) throw badRequest(`${col.label}을(를) 입력하세요.`);
      out[f] = null;
      continue;
    }
    v = String(v).trim();
    if (col.type === 'date' && !DATE_RE.test(v)) throw badRequest(`${col.label}: 날짜는 YYYY-MM-DD 형식으로 입력하세요.`);
    if (col.type === 'number' && !Number.isFinite(Number(v))) throw badRequest(`${col.label}: 숫자를 입력하세요.`);
    out[f] = v;
  }
  return out;
}

// 발전소 선택값: 'P0001' 이면 그대로, 'K209' 이면 keyno 209 의 rtm_plant 를 찾거나 만든다
async function resolvePlantId(conn, req, value) {
  if (value == null) return null;
  const v = String(value);
  if (/^P\d+$/.test(v)) {
    const [r] = await conn.query('SELECT plant_id FROM rtm_plant WHERE plant_id = ?', [v]);
    if (!r.length) throw badRequest(`발전소 ID ${v}를 찾을 수 없습니다.`);
    return v;
  }
  const m = /^K(\d+)$/.exec(v);
  if (!m) throw badRequest('발전소 선택값이 올바르지 않습니다.');
  return ensurePlant(conn, req, Number(m[1]));
}

async function ensurePlant(conn, req, keyno) {
  const [d] = await conn.query('SELECT DPP_KEYNO FROM dy_power_plant WHERE DPP_KEYNO = ?', [keyno]);
  if (!d.length) throw badRequest(`발전소 번호 ${keyno} 발전소가 모니터링에 없습니다.`);
  const [r] = await conn.query('SELECT plant_id FROM rtm_plant WHERE dpp_keyno = ? FOR UPDATE', [keyno]);
  if (r.length) return r[0].plant_id;
  const plantId = await nextId(conn, 'rtm_plant', 'plant_id', 'P');
  await conn.query('INSERT INTO rtm_plant (plant_id, dpp_keyno) VALUES (?, ?)', [plantId, keyno]);
  await logChange(conn, req, 'rtm_plant', plantId, 'insert', null, { plant_id: plantId, dpp_keyno: keyno });
  return plantId;
}

// ─── RTU S/N ─────────────────────────────────────────────────────────────
// 형식: DR-연도-하드웨어 변경 차수-그 버전의 몇 번째 장비 (예: DR-26-010-0054)
const PREFIX_RE = /^DR-\d{2}-\d{3}$/;
const SERIAL_RE = /^(DR-\d{2}-\d{3})-(\d{4})$/;
const serialOf = (prefix, n) => `${prefix}-${String(n).padStart(4, '0')}`;

// S/N 만 미리 적어 둔 빈 행인지 (제조일·설치일·상태·SW·CTN·비고·연결 발전소가 모두 없음)
async function blankDevice(conn, serial, lock) {
  const [r] = await conn.query(
    `SELECT d.device_id, d.made_date, d.install_date, d.status, d.sw_version, d.ctn, d.note,
            (SELECT COUNT(*) FROM rtm_device_plant x WHERE x.device_id = d.device_id) AS links
       FROM rtm_device d WHERE d.serial_no = ?${lock ? ' FOR UPDATE' : ''}`, [serial]);
  if (!r.length) return { exists: false };
  if (r.length > 1) return { exists: true, used: true };
  const d = r[0];
  const used = d.made_date || d.install_date || d.status || d.sw_version || d.ctn || d.note || d.links > 0;
  return { exists: true, used: !!used, device_id: d.device_id };
}

// 다음 S/N 기본값: 버전의 마지막 사용 번호(last_seq) + 1. 이미 쓰인 번호면 건너뛴다 (화면 기본값용, 쓰지 않음)
async function nextSerial(conn, prefix) {
  const [v] = await conn.query('SELECT last_seq FROM rtm_hw_version WHERE prefix = ?', [prefix]);
  if (!v.length) throw badRequest(`하드웨어 버전 ${prefix}이(가) 없습니다.`);
  let n = Number(v[0].last_seq) + 1;
  for (;;) {
    const b = await blankDevice(conn, serialOf(prefix, n), false);
    if (!b.exists || !b.used) return serialOf(prefix, n);
    n++;
  }
}

// 사용자가 정한 S/N 을 쓴다 (트랜잭션 안에서만): 형식·버전 확인, 이미 쓰는 번호면 거절,
// 미리 적어 둔 빈 행이면 그 행을 돌려준다. 마지막 사용 번호보다 크면 last_seq 를 올린다.
async function claimSerial(conn, serial) {
  const m = SERIAL_RE.exec(String(serial || '').trim());
  if (!m) throw badRequest('S/N은 DR-26-010-0038 형식으로 입력하세요 (연도 2자리, 버전 3자리, 번호 4자리).');
  const [prefix, n] = [m[1], Number(m[2])];
  const [v] = await conn.query('SELECT last_seq FROM rtm_hw_version WHERE prefix = ? FOR UPDATE', [prefix]);
  if (!v.length) throw badRequest(`하드웨어 버전 ${prefix}이(가) 없습니다. "하드웨어 버전" 메뉴에서 먼저 추가하세요.`);
  if (n < 1) throw badRequest('번호는 0001부터입니다.');
  const b = await blankDevice(conn, m[0], true);
  if (b.exists && b.used) throw badRequest(`S/N ${m[0]}은(는) 이미 쓰고 있는 장비입니다.`);
  if (n > Number(v[0].last_seq)) await conn.query('UPDATE rtm_hw_version SET last_seq = ? WHERE prefix = ?', [n, prefix]);
  return { serial_no: m[0], blank_device_id: b.exists ? b.device_id : null };
}

async function hwVersions(db) {
  const [vers] = await db.query('SELECT * FROM rtm_hw_version ORDER BY prefix');
  const out = [];
  for (const v of vers) {
    const [[c]] = await db.query(
      `SELECT COUNT(*) AS n FROM rtm_device WHERE serial_no LIKE ? AND (made_date IS NOT NULL OR install_date IS NOT NULL
         OR status IS NOT NULL OR sw_version IS NOT NULL OR ctn IS NOT NULL OR note IS NOT NULL)`, [v.prefix + '-%']);
    out.push({ ...v, device_count: c.n, next_serial: await nextSerial(db, v.prefix) });
  }
  return out;
}

async function checkSerialFree(conn, serial, exceptDeviceId) {
  if (!serial) return;
  const [r] = await conn.query('SELECT device_id FROM rtm_device WHERE serial_no = ? AND device_id <> ?', [serial, exceptDeviceId || '']);
  if (r.length) throw badRequest(`S/N ${serial}은(는) 이미 ${r[0].device_id}에 쓰이고 있습니다.`);
}

// 새 RTU 장비: 정한 S/N 으로. 미리 적어 둔 빈 행이 있으면 그 행을 쓰고 없으면 만든다.
// 발전소가 있으면 연결한다.
async function createNewDevice(conn, req, serial, plantId, extra) {
  const t = await claimSerial(conn, serial);
  let deviceId = t.blank_device_id;
  if (deviceId) {
    if (extra && Object.keys(extra).length) {
      const [[before]] = await conn.query('SELECT * FROM rtm_device WHERE device_id = ?', [deviceId]);
      await conn.query('UPDATE rtm_device SET ? WHERE device_id = ?', [extra, deviceId]);
      const [[after]] = await conn.query('SELECT * FROM rtm_device WHERE device_id = ?', [deviceId]);
      await logChange(conn, req, 'rtm_device', deviceId, 'update', before, after);
    }
  } else {
    deviceId = await nextId(conn, 'rtm_device', 'device_id', 'D');
    const row = { device_type: 'RTU', ...(extra || {}), device_id: deviceId, serial_no: t.serial_no };
    await conn.query('INSERT INTO rtm_device SET ?', [row]);
    await logChange(conn, req, 'rtm_device', deviceId, 'insert', null, row);
  }
  const row = { serial_no: t.serial_no };
  if (plantId) {
    await conn.query('INSERT INTO rtm_device_plant (device_id, plant_id, linked_at) VALUES (?, ?, CURDATE())', [deviceId, plantId]);
    await logChange(conn, req, 'rtm_device_plant', deviceId, 'update', { plants: [] }, { plants: [plantId] });
  }
  return { device_id: deviceId, serial_no: row.serial_no };
}

const NEW_DEVICE_RE = /^__new:(.*)$/;

// ─── 미들웨어 ─────────────────────────────────────────────────────────────
app.set('trust proxy', 1);
app.use(express.json({ limit: '5mb' })); // 세팅 요청서 엑셀(base64) 포함
app.use(session({
  secret: process.env.SESSION_SECRET || 'rtu-web-dev-secret-change-me',
  resave: false,
  saveUninitialized: false,
  cookie: {
    maxAge: 12 * 60 * 60 * 1000,
    httpOnly: true,
    sameSite: 'strict',
    path: BASE_PATH || '/',
  },
}));

// 잘못된 JSON 등 요청 오류: 서버 내부 정보(경로·스택) 없이 짧게 돌려준다
app.use((err, req, res, next) => {
  if (err && err.type === 'entity.parse.failed') return res.status(400).json({ error: '요청 형식이 올바르지 않습니다.' });
  if (err && err.type === 'entity.too.large') return res.status(413).json({ error: '파일이 너무 큽니다.' });
  next(err);
});

const router = express.Router();
app.use(BASE_PATH, express.static(path.join(__dirname, 'public')));
app.use(BASE_PATH, router);

function needLogin(req, res, next) {
  if (!req.session.userId) return res.status(401).json({ error: '로그인이 필요합니다.' });
  next();
}

// ─── 로그인 ──────────────────────────────────────────────────────────────
const loginLimiter = rateLimit({ windowMs: 15 * 60 * 1000, limit: 30, standardHeaders: true, legacyHeaders: false,
  message: { error: '로그인 시도가 너무 많습니다. 잠시 후 다시 시도하세요.' } });

router.post('/api/login', loginLimiter, errHandler(async (req, res) => {
  const username = String((req.body || {}).username || '');
  const password = String((req.body || {}).password || '');
  const db = getDb();
  const [rows] = await db.execute(
    'SELECT user_id, username, name, password, login_fail_count, is_locked, is_active, is_admin FROM rtm_user WHERE username = ? LIMIT 1',
    [username]
  );
  if (!rows.length) return res.status(400).json({ error: '아이디 또는 비밀번호가 올바르지 않습니다.' });
  const u = rows[0];
  if (!u.is_active) return res.status(403).json({ error: '사용이 중지된 계정입니다.' });
  if (u.is_locked) return res.status(403).json({ error: '계정이 잠겨있습니다. 관리자에게 문의하세요.' });
  if (!(await bcrypt.compare(password, String(u.password)))) {
    const fail = (Number(u.login_fail_count) || 0) + 1;
    if (fail >= 5) {
      await db.execute('UPDATE rtm_user SET login_fail_count = ?, is_locked = 1 WHERE user_id = ?', [fail, u.user_id]);
      return res.status(403).json({ error: '비밀번호를 5회 틀려 계정이 잠겼습니다. 관리자에게 문의하세요.' });
    }
    await db.execute('UPDATE rtm_user SET login_fail_count = ? WHERE user_id = ?', [fail, u.user_id]);
    return res.status(400).json({ error: `아이디 또는 비밀번호가 올바르지 않습니다. (${fail}/5회 실패)` });
  }
  await db.execute('UPDATE rtm_user SET login_fail_count = 0, last_login = NOW() WHERE user_id = ?', [u.user_id]);
  req.session.regenerate(err => {
    if (err) return res.status(500).json({ error: '세션 오류' });
    req.session.userId = Number(u.user_id);
    req.session.username = u.username;
    req.session.name = u.name;
    req.session.isAdmin = !!u.is_admin;
    res.json({ ok: true });
  });
}));

router.post('/api/logout', (req, res) => {
  req.session.destroy(() => res.json({ ok: true }));
});

router.get('/api/me', needLogin, (req, res) => {
  res.json({
    username: req.session.username, name: req.session.name, isAdmin: req.session.isAdmin,
    kakaoKey: process.env.KAKAO_JS_KEY || '',
  });
});

router.post('/api/me/password', needLogin, errHandler(async (req, res) => {
  const { current, next } = req.body || {};
  if (!next || String(next).length < 7) throw badRequest('새 비밀번호는 7자 이상으로 입력하세요.');
  const db = getDb();
  const [[u]] = await db.execute('SELECT password FROM rtm_user WHERE user_id = ?', [req.session.userId]);
  if (!(await bcrypt.compare(String(current || ''), String(u.password)))) throw badRequest('현재 비밀번호가 올바르지 않습니다.');
  await db.execute('UPDATE rtm_user SET password = ? WHERE user_id = ?', [await bcrypt.hash(String(next), 10), req.session.userId]);
  res.json({ ok: true });
}));

// ─── 시트 정의·선택 목록 ────────────────────────────────────────────────────
router.get('/api/meta', needLogin, (req, res) => {
  res.json({ sheets: SHEETS.map(({ key, name, table, idField, note, columns, hideNav }) => ({ key, name, table, idField, note, columns, hideNav: !!hideNav })) });
});

// 왼쪽 메뉴 옆 숫자: 시트별 행 수 (발전소장비는 모니터링 발전소 수)
router.get('/api/counts', needLogin, errHandler(async (req, res) => {
  const db = getDb();
  const out = {};
  for (const s of SHEETS) {
    const sql = s.key === 'plant'
      ? "SELECT COUNT(*) AS n FROM dy_power_plant WHERE DPP_DEL_YN = 'N'"
      : `SELECT COUNT(*) AS n FROM ${s.table}`;
    out[s.key] = (await db.query(sql))[0][0].n;
  }
  res.json(out);
}));

router.get('/api/lookups', needLogin, errHandler(async (req, res) => {
  const db = getDb();
  const [plants] = await db.query(`
    SELECT d.DPP_KEYNO AS keyno, d.DPP_NAME AS name, d.DPP_STATUS AS status, r.plant_id
    FROM dy_power_plant d LEFT JOIN rtm_plant r ON r.dpp_keyno = d.DPP_KEYNO
    WHERE d.DPP_DEL_YN = 'N' ORDER BY d.DPP_KEYNO`);
  const [devices] = await db.query(`
    SELECT d.device_id, d.serial_no, d.status,
      (d.made_date IS NOT NULL OR d.install_date IS NOT NULL OR d.status IS NOT NULL OR d.sw_version IS NOT NULL
        OR d.ctn IS NOT NULL OR d.note IS NOT NULL
        OR EXISTS (SELECT 1 FROM rtm_device_plant x WHERE x.device_id = d.device_id)) AS used
    FROM rtm_device d ORDER BY d.device_id`);
  const [routers] = await db.query('SELECT router_id, ctn, status FROM rtm_router ORDER BY router_id');
  const [members] = await db.query(`SELECT UI_KEYNO AS keyno, UI_ID AS id, UI_NAME AS name FROM u_userinfo WHERE UI_DELYN = 'N' ORDER BY UI_ID`);
  res.json({
    plants: plants.map(p => ({ value: p.plant_id || 'K' + p.keyno, plant_id: p.plant_id, keyno: p.keyno, name: p.name, status: p.status })),
    devices, routers, members, hwVersions: await hwVersions(db),
  });
}));

// ─── 시트 조회 ────────────────────────────────────────────────────────────
// 연결 "구분": 같은 keyno 안에서 이 장비·라우터가 어느 발전소 몫인지 (예: keyno 145 민정·영자·재두).
// 연결 표의 note 칸을 쓴다. 엑셀 이관 때 넣은 표시 '원본 장부 이관'은 구분이 아니므로 빈 값으로 본다 (2026-11-13).
const IMPORT_MARK = '원본 장부 이관';
const linkLabel = a => `NULLIF(NULLIF(TRIM(${a}.note), ''), '${IMPORT_MARK}')`;

// 장비·라우터 목록에 붙일 연결 구분 { 장비ID: { plant_id: 구분 } }
async function linkLabels(db, kind) {
  const { table, col } = LINKS[kind];
  const [rows] = await db.query(
    `SELECT ${col} AS id, plant_id, ${linkLabel('t')} AS label FROM ${table} t WHERE t.unlinked_at IS NULL AND ${linkLabel('t')} IS NOT NULL`);
  const out = {};
  for (const r of rows) (out[r.id] = out[r.id] || {})[r.plant_id] = r.label;
  return out;
}

const PLANT_JOIN = `
  LEFT JOIN rtm_plant rp ON rp.plant_id = t.plant_id
  LEFT JOIN dy_power_plant dp ON dp.DPP_KEYNO = rp.dpp_keyno`;

async function listSheet(db, key) {
  if (key === 'plant') {
    const [rows] = await db.query(`
      SELECT d.DPP_KEYNO AS keyno, d.DPP_NAME, d.DPP_STATUS, d.DPP_VOLUM, d.DPP_INVER, d.DPP_INVER_COUNT,
             u.UI_ID AS owner_id, r.*,
             (SELECT GROUP_CONCAT(CONCAT_WS(' ', g.maker, g.model,
                       CONCAT(IF(g.unit_kw IS NULL, '', CONCAT(TRIM(TRAILING '.' FROM TRIM(TRAILING '0' FROM g.unit_kw)), 'kW')), '×', g.cnt))
                     ORDER BY g.first_id SEPARATOR ', ')
                FROM (SELECT i.plant_id, i.maker, i.model, i.unit_kw, SUM(IFNULL(i.qty, 1)) AS cnt, MIN(i.inv_id) AS first_id
                        FROM rtm_inverter i GROUP BY i.plant_id, i.maker, i.model, i.unit_kw) g
               WHERE g.plant_id = r.plant_id) AS inv_summary,
             (SELECT GROUP_CONCAT(CONCAT(IFNULL(rt.ctn, rt.router_id), IFNULL(CONCAT(' (', ${linkLabel('y')}, ')'), ''))
                       ORDER BY ${linkLabel('y')} IS NULL, ${linkLabel('y')}, rt.router_id SEPARATOR ', ')
                FROM rtm_router_plant y JOIN rtm_router rt ON rt.router_id = y.router_id
               WHERE y.plant_id = r.plant_id AND y.unlinked_at IS NULL) AS router_ctn,
             (SELECT GROUP_CONCAT(CONCAT(IFNULL(dv.serial_no, 'S/N 없음'), IFNULL(CONCAT(' (', ${linkLabel('x')}, ')'), ''))
                       ORDER BY ${linkLabel('x')} IS NULL, ${linkLabel('x')}, dv.device_id SEPARATOR ', ')
                FROM rtm_device_plant x JOIN rtm_device dv ON dv.device_id = x.device_id
               WHERE x.plant_id = r.plant_id AND x.unlinked_at IS NULL) AS device_sns
      FROM dy_power_plant d
      LEFT JOIN rtm_plant r ON r.dpp_keyno = d.DPP_KEYNO
      LEFT JOIN u_userinfo u ON u.UI_KEYNO = d.DPP_USER
      WHERE d.DPP_DEL_YN = 'N'
      ORDER BY d.DPP_KEYNO`);
    return rows.map(r => ({ ...r, keyno: r.keyno, dpp_keyno: r.keyno, use_yn: r.use_yn || '' }));
  }
  const sheet = byKey[key];
  if (key === 'hwver') return hwVersions(db);
  if (key === 'router') {
    // 공용 라우터는 그 라우터를 쓰는 발전소를 모두 DB 이름으로 보여준다
    const [rows] = await db.query(`
      SELECT t.*,
        (SELECT GROUP_CONCAT(d.DPP_NAME ORDER BY d.DPP_KEYNO SEPARATOR ', ')
           FROM rtm_router_plant y JOIN rtm_plant p ON p.plant_id = y.plant_id JOIN dy_power_plant d ON d.DPP_KEYNO = p.dpp_keyno
          WHERE y.router_id = t.router_id AND y.unlinked_at IS NULL) AS plant_name,
        (SELECT GROUP_CONCAT(y.plant_id ORDER BY y.plant_id) FROM rtm_router_plant y
          WHERE y.router_id = t.router_id AND y.unlinked_at IS NULL) AS linked_plants
      FROM rtm_router t ORDER BY t.router_id`);
    const labels = await linkLabels(db, 'router');
    return rows.map(r => ({ ...r, linked_plants: r.linked_plants ? r.linked_plants.split(',') : [], link_labels: labels[r.router_id] || {} }));
  }
  if (key === 'swver') return (await db.query('SELECT * FROM rtm_sw_version ORDER BY CAST(SUBSTRING(code, 5) AS UNSIGNED)'))[0];
  if (key === 'device') {
    const [rows] = await db.query(`
      SELECT t.*,
        (SELECT GROUP_CONCAT(x.plant_id ORDER BY x.plant_id) FROM rtm_device_plant x
          WHERE x.device_id = t.device_id AND x.unlinked_at IS NULL) AS linked_plants
      FROM rtm_device t
      ORDER BY (t.serial_no IS NULL OR t.serial_no = ''),
        (CONCAT_WS('', t.board_type, t.sw_version, t.made_date, t.install_date, t.status, t.ctn, t.note) = ''
          AND NOT EXISTS (SELECT 1 FROM rtm_device_plant z WHERE z.device_id = t.device_id AND z.unlinked_at IS NULL)),
        t.serial_no DESC, t.device_id DESC`);
    // 정렬 (2026-11-18): S/N(DR-연도-버전-순번 = 만든 순서) 큰 번호부터. 번호만 미리 잡아 둔 빈 행(보드·SW·날짜·상태·CTN·비고·연결 모두 없음)은
    // 그 아래, S/N 없는 장비는 맨 아래
    const labels = await linkLabels(db, 'device');
    return rows.map(r => ({ ...r, linked_plants: r.linked_plants ? r.linked_plants.split(',') : [], link_labels: labels[r.device_id] || {} }));
  }
  const [rows] = await db.query(`
    SELECT t.*, dp.DPP_NAME AS plant_name, rp.dpp_keyno AS keyno
    FROM ${sheet.table} t ${PLANT_JOIN}
    ORDER BY ${SHEET_ORDER[key] || `t.${sheet.idField}`}`);
  return rows;
}

// 이력·작업 목록은 최근 것이 맨 위 (2026-11-11 사용자 요청)
//   세팅출고: 등록 순서 역순 (기한·출고일이 빈 행이 많아 등록 순서가 가장 확실)
//   작업장애: 발생일 최신순, 같은 날은 나중에 등록한 것이 위
//   장비이력(위 device 쿼리): 설치일(없으면 제조일) 최신순, 날짜 없는 행(S/N만 미리 적은 빈 행 포함)은 아래
const SHEET_ORDER = {
  setup: 't.setup_id DESC',
  issue: 't.occurred_at IS NULL, t.occurred_at DESC, t.issue_id DESC',
};

router.get('/api/sheets/:key', needLogin, errHandler(async (req, res) => {
  if (!byKey[req.params.key]) throw badRequest('없는 시트입니다.');
  res.json({ rows: await listSheet(getDb(), req.params.key) });
}));

// ─── 발전소 RTU 관리 정보 (rtm_plant) ───────────────────────────────────────
router.put('/api/plants/:keyno', needLogin, errHandler(async (req, res) => {
  const keyno = Number(req.params.keyno);
  const data = cleanRow(byKey.plant, req.body || {}, { partial: true });
  if ('use_yn' in data && !data.use_yn) data.use_yn = '사용';
  const out = await withTx(async conn => {
    const plantId = await ensurePlant(conn, req, keyno);
    const [[before]] = await conn.query('SELECT * FROM rtm_plant WHERE plant_id = ?', [plantId]);
    if (Object.keys(data).length) {
      await conn.query('UPDATE rtm_plant SET ? WHERE plant_id = ?', [data, plantId]);
      const [[after]] = await conn.query('SELECT * FROM rtm_plant WHERE plant_id = ?', [plantId]);
      await logChange(conn, req, 'rtm_plant', plantId, 'update', before, after);
    }
    return { plant_id: plantId };
  });
  res.json({ ok: true, ...out });
}));

// ─── 모니터링 발전소 (dy_power_plant) ───────────────────────────────────────
router.get('/api/power/:keyno', needLogin, errHandler(async (req, res) => {
  const [rows] = await getDb().query('SELECT * FROM dy_power_plant WHERE DPP_KEYNO = ?', [Number(req.params.keyno)]);
  if (!rows.length) throw badRequest('발전소가 없습니다.');
  res.json({ row: rows[0], rtuReadFields: RTU_READ_FIELDS });
}));

function cleanPower(body, { requireAll }) {
  const out = {};
  for (const f of DPP_FIELDS) {
    if (!(f in body)) continue;
    const v = body[f];
    out[f] = v === undefined || v === null || String(v).trim() === '' ? null : String(v).trim();
  }
  if (requireAll) {
    if (!out.DPP_NAME) throw badRequest('발전소명을 입력하세요.');
    if (!out.DPP_STATUS) throw badRequest('개통 상태를 선택하세요.');
    if (!out.DPP_USER) throw badRequest('회원을 선택하세요.');
  }
  if (out.DPP_STATUS && !['Y', 'N', 'E'].includes(out.DPP_STATUS)) throw badRequest('개통 상태 값이 올바르지 않습니다.');
  if (out.DPP_NAME && out.DPP_NAME.length > 30) throw badRequest('발전소명은 30자 이내로 입력하세요.');
  if (out.DPP_AREA && out.DPP_AREA.length > 30) throw badRequest('지역은 30자 이내로 입력하세요.');
  if ('DPP_INVER_COUNT' in out) {
    const n = Number(out.DPP_INVER_COUNT);
    if (!Number.isInteger(n) || n < 0) throw badRequest('인버터 대수는 0 이상의 정수로 입력하세요.');
    out.DPP_INVER_COUNT = n;
  }
  return out;
}

router.put('/api/power/:keyno', needLogin, errHandler(async (req, res) => {
  const keyno = Number(req.params.keyno);
  const data = cleanPower(req.body || {}, { requireAll: false });
  if (!Object.keys(data).length) throw badRequest('바꿀 값이 없습니다.');
  const out = await withTx(async conn => {
    const [rows] = await conn.query('SELECT * FROM dy_power_plant WHERE DPP_KEYNO = ? FOR UPDATE', [keyno]);
    if (!rows.length) throw badRequest('발전소가 없습니다.');
    const before = rows[0];
    if ('DPP_SN' in data) data.DPP_SN_NUM = snToSnNum(data.DPP_SN);
    await conn.query('UPDATE dy_power_plant SET ? WHERE DPP_KEYNO = ?', [data, keyno]);
    const [[after]] = await conn.query('SELECT * FROM dy_power_plant WHERE DPP_KEYNO = ?', [keyno]);
    const changed = Object.keys(data).filter(f => String(before[f] ?? '') !== String(after[f] ?? ''));
    if (changed.length) {
      const pick = o => Object.fromEntries(changed.map(f => [f, o[f]]));
      await logChange(conn, req, 'dy_power_plant', keyno, 'update', pick(before), pick(after));
    }
    return { changed, rtuFieldsChanged: changed.filter(f => RTU_READ_FIELDS.includes(f)) };
  });
  res.json({ ok: true, ...out });
}));

// ─── 발전소 묶음 등록: 모니터링 발전소 + RTU 관리 + 세팅 + 인버터 ─────────────
// 인버터 구성 입력 정리: 모델별 한 줄 (제조사·모델·대당 용량·수량)
function cleanInverters(list, { required = true } = {}) {
  const items = (Array.isArray(list) ? list : [])
    .map(it => ({
      maker: String(it.maker || '').trim(), model: String(it.model || '').trim(),
      unit_kw: String(it.unit_kw ?? '').trim(), qty: String(it.qty ?? '').trim(),
    }))
    .filter(it => it.maker || it.model || it.unit_kw || it.qty);
  if (required && !items.length) throw badRequest('인버터 구성을 한 줄 이상 입력하세요.');
  for (const it of items) {
    if (!it.maker) throw badRequest('인버터 제조사를 입력하세요.');
    if (!Number.isInteger(Number(it.qty)) || Number(it.qty) < 1) throw badRequest('인버터 수량은 1 이상의 정수로 입력하세요.');
    if (it.unit_kw && !Number.isFinite(Number(it.unit_kw))) throw badRequest('대당 용량은 숫자로 입력하세요.');
  }
  return items;
}

// 세팅 작업(선택) + 인버터 구성을 한 발전소에 추가
async function addSetup(conn, req, plantId, setup, items, deviceId) {
  let setupId = null;
  if (setup) {
    setupId = await nextId(conn, 'rtm_setup', 'setup_id', 'S');
    const row = { ...setup, setup_id: setupId, plant_id: plantId, device_id: deviceId || null };
    await conn.query('INSERT INTO rtm_setup SET ?', [row]);
    await logChange(conn, req, 'rtm_setup', setupId, 'insert', null, row);
  }
  const invIds = [];
  // 인버터 구성은 인버터 한 대가 한 줄 (요청서의 "수량 8"은 8줄로 나눠 저장 — slave·S/N을 대마다 적을 수 있게)
  for (const it of items) {
    for (let n = 0; n < Number(it.qty); n++) {
      const invId = await nextId(conn, 'rtm_inverter', 'inv_id', 'I');
      const row = {
        inv_id: invId, setup_id: setupId, plant_id: plantId,
        maker: it.maker.toLowerCase(), model: it.model || null, unit_kw: it.unit_kw || null, qty: 1,
        device_id: deviceId || null,
      };
      await conn.query('INSERT INTO rtm_inverter SET ?', [row]);
      await logChange(conn, req, 'rtm_inverter', invId, 'insert', null, row);
      invIds.push(invId);
    }
  }
  return { setupId, invIds };
}

// 발전소 묶음 등록: 모니터링 발전소 + RTU 관리 정보 + (새 RTU) + (세팅 작업) + 인버터 구성
// setupExtra: 화면에서 고칠 수 없는 세팅 칸 (예: 요청서 원문 이름)
async function createBundle(conn, req, body, setupExtra = {}) {
  const items = cleanInverters(body.inverters);
  const snList = String(body.sn || '').split(/[,\n]/).map(x => x.trim()).filter(Boolean);
  const power = cleanPower({ ...(body.power || {}), ...fromInverters(items, snList) }, { requireAll: true });
  const rtm = cleanRow(byKey.plant, body.rtm || {}, { partial: true });
  if (!rtm.use_yn) rtm.use_yn = '사용';
  const setup = body.makeSetup ? { ...cleanRow(byKey.setup, { ...(body.setup || {}), plant_id: 'X' }), ...setupExtra } : null;

  const [m] = await conn.query('SELECT UI_KEYNO FROM u_userinfo WHERE UI_KEYNO = ?', [power.DPP_USER]);
  if (!m.length) throw badRequest('선택한 회원을 찾을 수 없습니다.');
  const routerId = body.routerId ? String(body.routerId) : null;
  if (routerId) {
    const [r] = await conn.query('SELECT router_id FROM rtm_router WHERE router_id = ?', [routerId]);
    if (!r.length) throw badRequest(`라우터 ID ${routerId}를 찾을 수 없습니다.`);
  }

  // 1) 모니터링 발전소 (홈페이지 Pw_insert 와 같은 칸)
  const [ins] = await conn.query('INSERT INTO dy_power_plant SET ?', [power]);
  const keyno = ins.insertId;
  // 2) S/N 변환값 (홈페이지 ChangeSN — 홈페이지는 신규 등록 때 keyno 가 없어 빠지는 값)
  const snNum = snToSnNum(power.DPP_SN);
  await conn.query('UPDATE dy_power_plant SET DPP_SN_NUM = ? WHERE DPP_KEYNO = ?', [snNum, keyno]);
  const [[dpp]] = await conn.query('SELECT * FROM dy_power_plant WHERE DPP_KEYNO = ?', [keyno]);
  await logChange(conn, req, 'dy_power_plant', keyno, 'insert', null, dpp);

  // 3) RTU 관리 정보
  const plantId = await nextId(conn, 'rtm_plant', 'plant_id', 'P');
  const plantRow = { ...rtm, plant_id: plantId, dpp_keyno: keyno };
  await conn.query('INSERT INTO rtm_plant SET ?', [plantRow]);
  await logChange(conn, req, 'rtm_plant', plantId, 'insert', null, plantRow);
  if (routerId) await syncLinks(conn, req, 'router', routerId, [plantId], { addOnly: true });

  // 4) 새 RTU (선택): 화면에서 정한 S/N
  let newDev = null;
  if (body.newDeviceSerial) newDev = await createNewDevice(conn, req, String(body.newDeviceSerial), plantId);

  // 5) 세팅 작업 (선택) + 6) 인버터 구성
  const { setupId, invIds } = await addSetup(conn, req, plantId, setup, items, newDev && newDev.device_id);
  return { keyno, plant_id: plantId, setup_id: setupId, inv_ids: invIds, sn_num_ok: snNum !== null,
    device_id: newDev ? newDev.device_id : null, serial_no: newDev ? newDev.serial_no : null };
}

router.post('/api/bundle', needLogin, errHandler(async (req, res) => {
  const out = await withTx(conn => createBundle(conn, req, req.body || {}));
  res.json({ ok: true, ...out });
}));

// ─── 세팅 요청서 올리기 ─────────────────────────────────────────────────────
// 1) 읽기: 엑셀(base64)을 시트별로 읽고, 발전소 이름으로 DB 발전소를 찾아 둔다 (저장하지 않음)
router.post('/api/setup-form/parse', needLogin, errHandler(async (req, res) => {
  const { fileName, data } = req.body || {};
  if (!data) throw badRequest('파일이 없습니다.');
  let parsed;
  try {
    parsed = parseSetupForm(Buffer.from(String(data), 'base64'), String(fileName || ''));
  } catch (e) {
    throw badRequest('엑셀 파일을 읽지 못했습니다. 세팅 양식 파일인지 확인하세요.');
  }
  if (!parsed.sheets.length) throw badRequest('읽을 내용이 없습니다. 빈 양식인지 확인하세요.');
  const db = getDb();
  const [dpp] = await db.query("SELECT DPP_KEYNO, DPP_NAME, DPP_STATUS FROM dy_power_plant WHERE DPP_DEL_YN = 'N'");
  const idx = buildIndex(dpp);
  const names = Object.fromEntries(dpp.map(p => [p.DPP_KEYNO, p.DPP_NAME]));
  for (const sh of parsed.sheets) {
    const m = matchName(idx, sh.name);
    sh.match = { verdict: m.verdict, keynos: m.keynos, names: m.keynos.map(k => names[k]), why: m.why || '' };
    const [dup] = await db.query('SELECT setup_id FROM rtm_setup WHERE src_file = ? AND src_sheet = ?', [sh.src_file, sh.src_sheet]);
    sh.existing_setup = dup.length ? dup.map(d => d.setup_id).join(', ') : '';
  }
  res.json(parsed);
}));

// 2) 등록: 시트마다 기존 발전소에 세팅 추가(mode=existing) 또는 모니터링에 새 발전소로 등록(mode=new). 한 트랜잭션.
router.post('/api/setup-form/save', needLogin, errHandler(async (req, res) => {
  const list = Array.isArray((req.body || {}).items) ? req.body.items : [];
  if (!list.length) throw badRequest('등록할 요청서가 없습니다.');
  const results = await withTx(async conn => {
    const out = [];
    for (const it of list) {
      const f = it.form || {};
      const label = `${f.src_file || ''} / ${f.src_sheet || ''}`;
      const [dup] = await conn.query('SELECT setup_id FROM rtm_setup WHERE src_file = ? AND src_sheet = ?', [f.src_file || '', f.src_sheet || '']);
      if (dup.length && !it.allowDuplicate) throw badRequest(`${label}: 이미 ${dup[0].setup_id}로 등록한 요청서입니다.`);
      const setupFields = { kind: f.kind, due_date: f.due_date, due_time: f.due_time, owner: f.owner, req_capacity: f.capacity,
        req_address: f.address, req_comm: f.comm };
      // 화면에 없는 칸(요청서 원문 이름, 원본 파일·시트)은 따로 넣는다 — 원본 파일·시트는 중복 등록 확인용
      const cut = (v, n) => (v ? String(v).slice(0, n) : null);
      const extra = { req_name: cut(f.name, 100), src_file: cut(f.src_file, 200), src_sheet: cut(f.src_sheet, 100) };
      try {
        if (it.mode === 'new') {
          const r = await createBundle(conn, req, { power: it.power, inverters: it.inverters, rtm: it.rtm || {}, makeSetup: true,
            setup: setupFields, newDeviceSerial: it.newDeviceSerial, routerId: it.routerId }, extra);
          out.push({ label, mode: 'new', ...r });
        } else {
          const keyno = Number(it.keyno);
          if (!Number.isInteger(keyno)) throw badRequest('발전소를 고르세요.');
          const plantId = await ensurePlant(conn, req, keyno);
          const items = cleanInverters(it.inverters, { required: false });
          const setup = { ...cleanRow(byKey.setup, { ...setupFields, plant_id: 'X' }), ...extra };
          const newDev = it.newDeviceSerial ? await createNewDevice(conn, req, String(it.newDeviceSerial), plantId) : null;
          const r = await addSetup(conn, req, plantId, setup, items, newDev && newDev.device_id);
          out.push({ label, mode: 'existing', keyno, plant_id: plantId, setup_id: r.setupId, inv_ids: r.invIds,
            serial_no: newDev ? newDev.serial_no : null });
        }
      } catch (e) {
        if (e.status) e.message = `${label}: ${e.message}`;
        throw e;
      }
    }
    return out;
  });
  res.json({ ok: true, results });
}));

// ─── 일반 시트 추가·수정·삭제 (세팅출고·인버터·장비·장애·라우터) ───────────────
const GENERIC = ['setup', 'inverter', 'device', 'issue', 'router', 'hwver', 'swver'];

// 장비·라우터 ↔ 발전소 연결 맞추기. 빠진 연결은 지우지 않고 해제일(unlinked_at)을 남긴다.
const LINKS = {
  device: { table: 'rtm_device_plant', col: 'device_id' },
  router: { table: 'rtm_router_plant', col: 'router_id' },
};
// labels: { 화면에서 고른 발전소 값: 구분 } — 넘기면 연결마다 구분(note)을 그 값으로 맞춘다 (빈 값이면 지움)
async function syncLinks(conn, req, kind, id, plantValues, { addOnly = false, labels = null } = {}) {
  const { table, col } = LINKS[kind];
  const want = [];
  const wantLabel = {};
  for (const val of plantValues || []) {
    const p = await resolvePlantId(conn, req, val);
    want.push(p);
    if (labels && typeof labels === 'object') {
      const l = String(labels[val] ?? labels[p] ?? '').trim().slice(0, 100);
      wantLabel[p] = l || null;
    }
  }
  const [cur] = await conn.query(`SELECT plant_id, unlinked_at, ${linkLabel(table)} AS label FROM ${table} WHERE ${col} = ?`, [id]);
  const active = cur.filter(c => !c.unlinked_at).map(c => c.plant_id);
  const curLabel = Object.fromEntries(cur.filter(c => !c.unlinked_at).map(c => [c.plant_id, c.label || null]));
  for (const p of want) {
    if (active.includes(p)) continue;
    await conn.query(
      `INSERT INTO ${table} (${col}, plant_id, linked_at) VALUES (?, ?, CURDATE()) ON DUPLICATE KEY UPDATE linked_at = CURDATE(), unlinked_at = NULL`,
      [id, p]);
    curLabel[p] = null;
  }
  const removed = addOnly ? [] : active.filter(p => !want.includes(p));
  for (const p of removed) await conn.query(`UPDATE ${table} SET unlinked_at = CURDATE() WHERE ${col} = ? AND plant_id = ?`, [id, p]);
  const after = [...new Set([...active.filter(p => !removed.includes(p)), ...want])];
  // 구분 바뀐 연결만 고친다
  const labelChanged = {};
  for (const [p, l] of Object.entries(wantLabel)) {
    if ((curLabel[p] || null) === l) continue;
    await conn.query(`UPDATE ${table} SET note = ? WHERE ${col} = ? AND plant_id = ?`, [l, id, p]);
    labelChanged[p] = { before: curLabel[p] || null, after: l };
  }
  const changedKeys = Object.keys(labelChanged);
  if (after.length !== active.length || removed.length || changedKeys.length) {
    const b = { plants: active };
    const a = { plants: after };
    if (changedKeys.length) {
      b.labels = Object.fromEntries(changedKeys.map(p => [p, labelChanged[p].before]));
      a.labels = Object.fromEntries(changedKeys.map(p => [p, labelChanged[p].after]));
    }
    await logChange(conn, req, table, id, 'update', b, a);
  }
}
const syncDeviceLinks = (conn, req, id, plants, labels) => syncLinks(conn, req, 'device', id, plants, { labels });

// 세팅출고 RTU 칸에서 "새 RTU 만들기"를 고른 경우
async function resolveNewDevice(conn, req, data, plantId) {
  const m = data.device_id && NEW_DEVICE_RE.exec(data.device_id);
  if (!m) return null;
  const dev = await createNewDevice(conn, req, m[1], plantId);
  data.device_id = dev.device_id;
  return dev;
}

async function setCurrentVersion(conn, prefix) {
  await conn.query('UPDATE rtm_hw_version SET is_current = (prefix = ?)', [prefix]);
}

async function checkRefs(conn, data) {
  if (data.device_id) {
    const [r] = await conn.query('SELECT device_id FROM rtm_device WHERE device_id = ?', [data.device_id]);
    if (!r.length) throw badRequest(`장비 ID ${data.device_id}를 찾을 수 없습니다.`);
  }
  if (data.setup_id) {
    const [r] = await conn.query('SELECT setup_id FROM rtm_setup WHERE setup_id = ?', [data.setup_id]);
    if (!r.length) throw badRequest(`작업 ID ${data.setup_id}를 찾을 수 없습니다.`);
  }
}

router.post('/api/sheets/:key', needLogin, errHandler(async (req, res) => {
  const key = req.params.key;
  if (!GENERIC.includes(key)) throw badRequest('이 시트는 여기서 추가할 수 없습니다.');
  const sheet = byKey[key];
  const body = req.body || {};
  const data = cleanRow(sheet, body);
  if (key === 'inverter') data.qty = 1; // 인버터 구성은 한 줄에 한 대
  const out = await withTx(async conn => {
    if ('plant_id' in data && data.plant_id) data.plant_id = await resolvePlantId(conn, req, data.plant_id);
    const newDev = key === 'setup' ? await resolveNewDevice(conn, req, data, data.plant_id) : null;
    await checkRefs(conn, data);
    let id;
    if (sheet.manualId) {
      id = data[sheet.idField];
      if (key === 'hwver' && !PREFIX_RE.test(id)) throw badRequest('S/N 앞부분은 DR-26-012 형식으로 입력하세요.');
      if (key === 'swver' && !/^sw_v\d+$/.test(id)) throw badRequest('SW 버전 코드는 sw_v13 형식으로 입력하세요.');
      const [dup] = await conn.query(`SELECT 1 FROM ${sheet.table} WHERE ${sheet.idField} = ?`, [id]);
      if (dup.length) throw badRequest(`${id}은(는) 이미 있습니다.`);
    } else {
      id = await nextId(conn, sheet.table, sheet.idField, sheet.prefix);
    }
    if (key === 'device' && data.serial_no && /^DR-/.test(data.serial_no)) {
      // DR- 형식 S/N: 버전 확인·중복 확인, 미리 적어 둔 빈 행이 있으면 그 행에 입력값을 채운다
      const extra = { ...data };
      delete extra.serial_no;
      delete extra.device_id;
      for (const k of Object.keys(extra)) if (extra[k] === null) delete extra[k];
      const dev = await createNewDevice(conn, req, data.serial_no, null, extra);
      await syncDeviceLinks(conn, req, dev.device_id, body.linked_plants, body.link_labels);
      return { id: dev.device_id, serial_no: dev.serial_no };
    }
    if (key === 'device') await checkSerialFree(conn, data.serial_no, null);
    const row = { ...data, [sheet.idField]: id };
    if (key === 'device' && !row.device_type) row.device_type = 'RTU';
    await conn.query(`INSERT INTO ${sheet.table} SET ?`, [row]);
    await logChange(conn, req, sheet.table, id, 'insert', null, row);
    if (key === 'device') await syncDeviceLinks(conn, req, id, body.linked_plants, body.link_labels);
    if (key === 'router') await syncLinks(conn, req, 'router', id, body.linked_plants, { labels: body.link_labels });
    if (key === 'hwver' && String(row.is_current) === '1') await setCurrentVersion(conn, id);
    return { id, serial_no: row.serial_no || (newDev && newDev.serial_no) || undefined };
  });
  res.json({ ok: true, ...out });
}));

router.put('/api/sheets/:key/:id', needLogin, errHandler(async (req, res) => {
  const key = req.params.key;
  if (!GENERIC.includes(key)) throw badRequest('이 시트는 여기서 수정할 수 없습니다.');
  const sheet = byKey[key];
  const body = req.body || {};
  const data = cleanRow(sheet, body, { partial: true });
  await withTx(async conn => {
    const [rows] = await conn.query(`SELECT * FROM ${sheet.table} WHERE ${sheet.idField} = ? FOR UPDATE`, [req.params.id]);
    if (!rows.length) throw badRequest('수정할 행이 없습니다.');
    if (data.plant_id) data.plant_id = await resolvePlantId(conn, req, data.plant_id);
    for (const c of sheet.columns) if (c.createOnly) delete data[c.f];
    if (key === 'setup') await resolveNewDevice(conn, req, data, data.plant_id || rows[0].plant_id);
    await checkRefs(conn, data);
    if (key === 'device' && 'serial_no' in data) await checkSerialFree(conn, data.serial_no, req.params.id);
    if (key === 'hwver' && String(data.is_current) === '1') await setCurrentVersion(conn, req.params.id);
    if (Object.keys(data).length) {
      await conn.query(`UPDATE ${sheet.table} SET ? WHERE ${sheet.idField} = ?`, [data, req.params.id]);
      const [[after]] = await conn.query(`SELECT * FROM ${sheet.table} WHERE ${sheet.idField} = ?`, [req.params.id]);
      await logChange(conn, req, sheet.table, req.params.id, 'update', rows[0], after);
    }
    if (key === 'device' && Array.isArray(body.linked_plants)) await syncDeviceLinks(conn, req, req.params.id, body.linked_plants, body.link_labels);
    if (key === 'router' && Array.isArray(body.linked_plants)) await syncLinks(conn, req, 'router', req.params.id, body.linked_plants, { labels: body.link_labels });
  });
  res.json({ ok: true });
}));

router.delete('/api/sheets/:key/:id', needLogin, errHandler(async (req, res) => {
  const key = req.params.key;
  if (!GENERIC.includes(key)) throw badRequest('이 시트는 여기서 삭제할 수 없습니다.');
  const sheet = byKey[key];
  await withTx(async conn => {
    const [rows] = await conn.query(`SELECT * FROM ${sheet.table} WHERE ${sheet.idField} = ? FOR UPDATE`, [req.params.id]);
    if (!rows.length) throw badRequest('삭제할 행이 없습니다.');
    if (key === 'hwver') {
      const [[c]] = await conn.query('SELECT COUNT(*) AS n FROM rtm_device WHERE serial_no LIKE ?', [req.params.id + '-%']);
      if (c.n) throw badRequest(`이 버전으로 만든 장비가 ${c.n}대 있어 삭제할 수 없습니다.`);
    }
    if (key === 'device') await conn.query('DELETE FROM rtm_device_plant WHERE device_id = ?', [req.params.id]);
    if (key === 'router') await conn.query('DELETE FROM rtm_router_plant WHERE router_id = ?', [req.params.id]);
    await conn.query(`DELETE FROM ${sheet.table} WHERE ${sheet.idField} = ?`, [req.params.id]);
    await logChange(conn, req, sheet.table, req.params.id, 'delete', rows[0], null);
  });
  res.json({ ok: true });
}));

router.get('/api/next-serial', needLogin, errHandler(async (req, res) => {
  res.json({ versions: await hwVersions(getDb()) });
}));

// ─── 변경 이력 ────────────────────────────────────────────────────────────
router.get('/api/logs', needLogin, errHandler(async (req, res) => {
  const where = [];
  const args = [];
  if (req.query.table) { where.push('table_name = ?'); args.push(String(req.query.table)); }
  if (req.query.key) { where.push('row_key = ?'); args.push(String(req.query.key)); }
  // 발전소 하나에 관련된 이력 모두: 발전소 자체 + 그 발전소 ID가 들어간 세팅·인버터·장애·장비/라우터 연결
  if (req.query.plant || req.query.keyno) {
    const plant = /^P\d+$/.test(String(req.query.plant || '')) ? String(req.query.plant) : null;
    const keyno = /^\d+$/.test(String(req.query.keyno || '')) ? String(req.query.keyno) : null;
    const or = [];
    if (keyno) { or.push("(table_name = 'dy_power_plant' AND row_key = ?)"); args.push(keyno); }
    if (plant) {
      or.push("(table_name = 'rtm_plant' AND row_key = ?)", 'after_json LIKE ?', 'before_json LIKE ?');
      args.push(plant, `%"${plant}"%`, `%"${plant}"%`);
    }
    if (!or.length) throw badRequest('발전소 값이 올바르지 않습니다.');
    where.push('(' + or.join(' OR ') + ')');
  }
  // 한 달 단위 (month=YYYY-MM): 그 달 이력은 모두, 달을 정하지 않으면 최근 300건
  let limit = 300;
  if (req.query.month) {
    const m = /^(\d{4})-(\d{2})$/.exec(String(req.query.month));
    if (!m || Number(m[2]) < 1 || Number(m[2]) > 12) throw badRequest('달은 YYYY-MM 형식으로 고르세요.');
    const next = Number(m[2]) === 12 ? `${Number(m[1]) + 1}-01` : `${m[1]}-${String(Number(m[2]) + 1).padStart(2, '0')}`;
    where.push('created_at >= ? AND created_at < ?');
    args.push(`${m[1]}-${m[2]}-01`, `${next}-01`);
    limit = 20000;
  }
  const db = getDb();
  const [rows] = await db.query(
    `SELECT log_id, table_name, row_key, action, before_json, after_json, username, created_at
       FROM rtm_change_log ${where.length ? 'WHERE ' + where.join(' AND ') : ''}
      ORDER BY log_id DESC LIMIT ${limit}`, args);
  await addPlantNames(db, rows);
  res.json({ rows });
}));

// 이력이 있는 달과 건수 (변경 이력 화면의 달 선택용)
router.get('/api/logs/months', needLogin, errHandler(async (req, res) => {
  const [rows] = await getDb().query(
    "SELECT DATE_FORMAT(created_at, '%Y-%m') AS month, COUNT(*) AS n FROM rtm_change_log GROUP BY month ORDER BY month DESC");
  res.json({ months: rows });
}));

// 이력마다 관련 발전소 이름(DB 이름)을 붙인다: plant_names
async function addPlantNames(db, rows) {
  const parse = j => { try { return j ? JSON.parse(j) : null; } catch { return null; } };
  const [plants] = await db.query(`
    SELECT p.plant_id, p.dpp_keyno, d.DPP_NAME FROM rtm_plant p LEFT JOIN dy_power_plant d ON d.DPP_KEYNO = p.dpp_keyno`);
  const byPlant = new Map(plants.map(p => [p.plant_id, p]));
  const [dpp] = await db.query('SELECT DPP_KEYNO, DPP_NAME FROM dy_power_plant');
  const byKeyno = new Map(dpp.map(d => [String(d.DPP_KEYNO), d.DPP_NAME]));
  // 장비·라우터 자체 수정은 지금 연결된 발전소로
  const [devLinks] = await db.query('SELECT device_id AS id, plant_id FROM rtm_device_plant WHERE unlinked_at IS NULL');
  const [rtLinks] = await db.query('SELECT router_id AS id, plant_id FROM rtm_router_plant WHERE unlinked_at IS NULL');
  const linksOf = list => list.reduce((m, l) => m.set(l.id, [...(m.get(l.id) || []), l.plant_id]), new Map());
  const devMap = linksOf(devLinks);
  const rtMap = linksOf(rtLinks);

  for (const r of rows) {
    const b = parse(r.before_json) || {};
    const a = parse(r.after_json) || {};
    const keynos = new Set();
    const pids = new Set();
    if (r.table_name === 'dy_power_plant') keynos.add(String(r.row_key));
    else if (r.table_name === 'rtm_plant') pids.add(r.row_key);
    else if (r.table_name === 'rtm_device_plant' || r.table_name === 'rtm_router_plant') {
      [...(b.plants || []), ...(a.plants || [])].forEach(p => pids.add(p));
    } else if (r.table_name === 'rtm_device') (devMap.get(r.row_key) || []).forEach(p => pids.add(p));
    else if (r.table_name === 'rtm_router') (rtMap.get(r.row_key) || []).forEach(p => pids.add(p));
    for (const o of [a, b]) if (o.plant_id) pids.add(o.plant_id);
    for (const pid of pids) { const p = byPlant.get(pid); if (p) keynos.add(String(p.dpp_keyno)); }
    r.plant_names = [...keynos].map(k => byKeyno.get(k) || `발전소 번호 ${k}`).join(', ');
  }
}

// ─── 엑셀 내려받기 (전체 시트) ───────────────────────────────────────────────
router.get('/api/export.xlsx', needLogin, errHandler(async (req, res) => {
  const db = getDb();
  const wb = XLSX.utils.book_new();
  for (const sheet of SHEETS) {
    const rows = await listSheet(db, sheet.key);
    const cols = sheet.columns;
    const aoa = [cols.map(c => c.label)];
    for (const r of rows) {
      aoa.push(cols.map(c => {
        let v = r[c.f];
        if (Array.isArray(v)) v = v.join(', ');
        if (c.map && v in c.map) v = c.map[v];
        return v == null ? '' : v;
      }));
    }
    const ws = XLSX.utils.aoa_to_sheet(aoa);
    ws['!cols'] = cols.map(c => ({ wch: Math.max(8, c.label.length * 2) }));
    XLSX.utils.book_append_sheet(wb, ws, sheet.name);
  }
  const buf = XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' });
  const stamp = new Date(Date.now() + 9 * 3600 * 1000).toISOString().slice(2, 10).replace(/-/g, '');
  res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  res.setHeader('Content-Disposition', `attachment; filename*=UTF-8''${encodeURIComponent(`RTU통합관리_${stamp}.xlsx`)}`);
  res.send(buf);
}));

app.use((err, req, res, next) => { // eslint-disable-line no-unused-vars
  console.error(err);
  res.status(500).json({ error: '서버 오류가 났습니다.' });
});

// ─── 시작 ────────────────────────────────────────────────────────────────
async function checkSchema() {
  const need = ['dy_power_plant', 'u_userinfo', 'rtm_plant', 'rtm_device', 'rtm_device_plant', 'rtm_setup',
    'rtm_inverter', 'rtm_issue', 'rtm_router', 'rtm_router_plant', 'rtm_user', 'rtm_change_log', 'rtm_hw_version', 'rtm_sw_version'];
  const [rows] = await getDb().query(
    'SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE()');
  const have = rows.map(r => r.TABLE_NAME);
  const missing = need.filter(t => !have.includes(t));
  if (missing.length) {
    // 테이블은 자동으로 만들지 않는다 (운영 DB). db/schema.sql 을 확인 후 직접 실행.
    console.error(`[rtu-web] 없는 테이블: ${missing.join(', ')} — db/schema.sql 을 먼저 실행하세요.`);
    process.exit(1);
  }
}

if (require.main === module) {
  checkSchema()
    .then(() => app.listen(PORT, '127.0.0.1', () => console.log(`[rtu-web] 실행 중: http://127.0.0.1:${PORT}${BASE_PATH}/`)))
    .catch(e => { console.error('[rtu-web] DB 연결 실패:', e.message); process.exit(1); });
}

module.exports = { app, snToSnNum };
