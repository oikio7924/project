require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');
const XLSX = require('xlsx');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const session = require('express-session');
const bcrypt = require('bcryptjs');

const app = express();
const PORT = Number(process.env.PORT || 3001);
const BASE_PATH = (process.env.BASE_PATH || '').replace(/\/$/, '');

const BIZ_CERT_DIR = path.join(__dirname, 'uploads', 'biz-certs');
fs.mkdirSync(BIZ_CERT_DIR, { recursive: true });

const PLANT_DOCS_DIR = path.join(__dirname, 'uploads', 'plant-docs');
fs.mkdirSync(PLANT_DOCS_DIR, { recursive: true });
const PLANT_DOCS_MAX_PER_PLANT = 30;

const DB_CONFIG = {
  host: process.env.MARIADB_HOST || 'localhost',
  port: Number(process.env.MARIADB_PORT || 3306),
  user: process.env.MARIADB_USER || '',
  password: process.env.MARIADB_PASSWORD || '',
  database: process.env.MARIADB_DATABASE || '',
  waitForConnections: true,
  connectionLimit: 10,
  dateStrings: true,
  timezone: '+09:00',
};

let dbPool = null;
function getDb() {
  if (!dbPool) dbPool = mysql.createPool(DB_CONFIG);
  return dbPool;
}

const PLANT_FIELDS = [
  'plant_name', 'owner_name', 'contact', 'address', 'capacity', 'install_type', 'memo',
  'power_biz_permit_scheduled', 'power_biz_permit_date', 'power_biz_permit_expire',
  'dev_permit_date', 'dev_permit_expire', 'dev_permit_status',
  'ppa_receive_date', 'ppa_receive_capacity',
  'dev_completion_date', 'commercial_operation_date',
];

const EVENT_FIELDS = [
  { field: 'power_biz_permit_scheduled', label: '발전사업허가예정일', type: 'power-scheduled' },
  { field: 'power_biz_permit_date',      label: '발전사업허가일',    type: 'power-permit'    },
  { field: 'power_biz_permit_expire',    label: '발전사업만료일',    type: 'power-expire'    },
  { field: 'dev_permit_date',            label: '개발행위허가일',    type: 'dev-permit'      },
  { field: 'dev_permit_expire',          label: '개발행위만료일',    type: 'dev-expire'      },
  { field: 'ppa_receive_date',           label: 'PPA 접수일',        type: 'ppa'             },
  { field: 'dev_completion_date',        label: '개발행위준공일',    type: 'completion'      },
  { field: 'commercial_operation_date',  label: '상업운전개시일',    type: 'operation'       },
];

// 엑셀 열 정의 (스크린샷 양식과 동일한 순서)
const EXCEL_COLUMNS = [
  { header: '번호',               field: null,                         wch: 5  },
  { header: '발전소 명',          field: 'plant_name',                 wch: 22 },
  { header: '주소',               field: 'address',                    wch: 38 },
  { header: '사업주',             field: 'owner_name',                 wch: 14 },
  { header: '연락처',             field: 'contact',                    wch: 15 },
  { header: '용량',               field: 'capacity',                   wch: 10 },
  { header: '설치형태',           field: 'install_type',               wch: 10 },
  { header: '발전사업허가예정일', field: 'power_biz_permit_scheduled', wch: 17 },
  { header: '발전사업허가일',     field: 'power_biz_permit_date',      wch: 14 },
  { header: '발전사업만료일',     field: 'power_biz_permit_expire',    wch: 14 },
  { header: '개발행위허가일',     field: 'dev_permit_date',            wch: 14 },
  { header: '개발행위만료일',     field: 'dev_permit_expire',          wch: 14 },
  { header: 'PPA 접수일',         field: 'ppa_receive_date',           wch: 12 },
  { header: 'PPA 접수용량',       field: 'ppa_receive_capacity',       wch: 12 },
  { header: '개발행위준공일',     field: 'dev_completion_date',        wch: 14 },
  { header: '상업운전개시일',     field: 'commercial_operation_date',  wch: 14 },
  { header: '메모',               field: 'memo',                       wch: 30 },
];

// 엑셀 가져오기 헤더 매핑 (구버전/신버전 모두 수용)
const EXCEL_HEADER_MAP = {
  '발전소 명': 'plant_name',  '발전소명': 'plant_name',
  '주소': 'address',          '소재지': 'address',
  '사업주': 'owner_name',     '사업자명': 'owner_name', '사업자 명': 'owner_name',
  '연락처': 'contact',
  '용량': 'capacity',
  '설치형태': 'install_type',
  '메모': 'memo',
  '발전사업허가예정일': 'power_biz_permit_scheduled',
  '발전사업허가일':     'power_biz_permit_date',
  '발전사업만료일':     'power_biz_permit_expire',
  '개발행위허가일':     'dev_permit_date',
  '개발행위만료일':     'dev_permit_expire',
  '개발행위구분':       'dev_permit_status',
  '개발행위 구분':      'dev_permit_status',
  'PPA 접수일': 'ppa_receive_date',  'PPA접수일': 'ppa_receive_date',
  'PPA 접수용량': 'ppa_receive_capacity', 'PPA접수용량': 'ppa_receive_capacity',
  '개발행위준공일':   'dev_completion_date',
  '상업운전개시일':   'commercial_operation_date',
};

const DATE_FIELD_SET = new Set([
  'power_biz_permit_scheduled', 'power_biz_permit_date', 'power_biz_permit_expire',
  'dev_permit_date', 'dev_permit_expire', 'ppa_receive_date',
  'dev_completion_date', 'commercial_operation_date',
]);

async function initDb() {
  const db = getDb();
  await db.execute(`
    CREATE TABLE IF NOT EXISTS bdm_plants (
      id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
      plant_name VARCHAR(255) NOT NULL,
      owner_name VARCHAR(255) NOT NULL DEFAULT '',
      contact VARCHAR(100) NOT NULL DEFAULT '',
      address VARCHAR(500) NOT NULL DEFAULT '',
      capacity VARCHAR(100) NOT NULL DEFAULT '',
      install_type VARCHAR(100) NOT NULL DEFAULT '',
      memo TEXT NULL,
      power_biz_permit_scheduled DATE NULL,
      power_biz_permit_date DATE NULL,
      power_biz_permit_expire DATE NULL,
      dev_permit_date DATE NULL,
      dev_permit_expire DATE NULL,
      ppa_receive_date DATE NULL,
      ppa_receive_capacity VARCHAR(100) NOT NULL DEFAULT '',
      dev_completion_date DATE NULL,
      commercial_operation_date DATE NULL,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      INDEX idx_bdm_power_expire (power_biz_permit_expire),
      INDEX idx_bdm_dev_expire (dev_permit_expire),
      INDEX idx_bdm_plant_name (plant_name)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `);
  // 컬럼 추가 (IF NOT EXISTS 미지원 MySQL 호환)
  const alterCols = [
    `ALTER TABLE bdm_plants ADD COLUMN dev_permit_status VARCHAR(50) NOT NULL DEFAULT ''`,
    `ALTER TABLE bdm_plants ADD COLUMN biz_cert_filename VARCHAR(500) NULL DEFAULT NULL`,
  ];
  for (const sql of alterCols) {
    try { await db.execute(sql); } catch (e) {
      if (!e.message.includes('Duplicate column name')) throw e;
    }
  }

  await db.execute(`
    CREATE TABLE IF NOT EXISTS bdm_plant_files (
      id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
      plant_id INT UNSIGNED NOT NULL,
      original_filename VARCHAR(500) NOT NULL,
      file_size INT UNSIGNED NOT NULL DEFAULT 0,
      uploaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      INDEX idx_bdm_plant_files_plant (plant_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `);

  // 예전 "사업자등록증" 단일 첨부(biz_cert_filename)를 새 다중 첨부파일 시스템으로 1회 이관
  // (이미 이관된 건 원본파일명 기준으로 건너뜀 — 여러 번 재기동해도 안전)
  try {
    const [bizCertPlants] = await db.execute(
      "SELECT id, biz_cert_filename FROM bdm_plants WHERE biz_cert_filename IS NOT NULL AND biz_cert_filename != ''"
    );
    for (const p of bizCertPlants) {
      const ext = path.extname(p.biz_cert_filename).toLowerCase();
      const oldPath = path.join(BIZ_CERT_DIR, `${p.id}${ext}`);
      if (!fs.existsSync(oldPath)) continue;

      const [already] = await db.execute(
        'SELECT id FROM bdm_plant_files WHERE plant_id = ? AND original_filename = ?',
        [p.id, p.biz_cert_filename]
      );
      if (already.length) continue;

      const stat = fs.statSync(oldPath);
      const [result] = await db.execute(
        'INSERT INTO bdm_plant_files (plant_id, original_filename, file_size) VALUES (?, ?, ?)',
        [p.id, p.biz_cert_filename, stat.size]
      );
      const newFileId = result.insertId;
      const newDir = plantDocDir(p.id);
      fs.mkdirSync(newDir, { recursive: true });
      fs.copyFileSync(oldPath, path.join(newDir, `${newFileId}${ext}`));
      console.log(`[bd-web] 사업자등록증 이관: 발전소 ${p.id} -> 첨부파일 ${newFileId}`);
    }
  } catch (e) {
    console.error('[bd-web] 사업자등록증 이관 중 오류:', e.message);
  }

  await db.execute(`
    CREATE TABLE IF NOT EXISTS bdm_users (
      id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
      username VARCHAR(100) NOT NULL UNIQUE,
      password VARCHAR(255) NOT NULL,
      login_fail_count INT NOT NULL DEFAULT 0,
      is_locked TINYINT(1) NOT NULL DEFAULT 0,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `);

  // .env의 ADMIN_USERNAME/ADMIN_PASSWORD로 최초 1회 계정 생성 (이미 있으면 건드리지 않음)
  const adminUser = process.env.ADMIN_USERNAME;
  const adminPass = process.env.ADMIN_PASSWORD;
  if (adminUser && adminPass) {
    const [existing] = await db.execute('SELECT id FROM bdm_users WHERE username = ? LIMIT 1', [adminUser]);
    if (!existing.length) {
      const hashed = await bcrypt.hash(adminPass, BCRYPT_ROUNDS);
      await db.execute('INSERT INTO bdm_users (username, password) VALUES (?, ?)', [adminUser, hashed]);
      console.log(`[bd-web] .env 계정 생성됨: ${adminUser}`);
    }
  }
}

function cleanBody(body) {
  const out = {};
  for (const f of PLANT_FIELDS) {
    const v = body[f];
    const empty = (v === '' || v === undefined || v === null);
    if (f === 'dev_permit_status') {
      out[f] = empty ? '' : String(v);
    } else {
      out[f] = empty ? null : String(v);
    }
  }
  return out;
}

function errHandler(fn) {
  return async (req, res) => {
    try {
      await fn(req, res);
    } catch (e) {
      console.error(e);
      res.status(500).json({ error: e.message });
    }
  };
}

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(session({
  secret: process.env.SESSION_SECRET || 'bd-web-dev-secret-change-me',
  resave: false,
  saveUninitialized: false,
  cookie: {
    maxAge: 7 * 24 * 60 * 60 * 1000,
    httpOnly: true,
    sameSite: 'strict',
    path: BASE_PATH || '/',
  },
}));

const router = express.Router();
app.use(BASE_PATH, express.static(path.join(__dirname, 'public')));
app.use(BASE_PATH, router);

const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: 10 * 1024 * 1024 } });

// ─── 로그인 ──────────────────────────────────────────────────────────────
const BCRYPT_ROUNDS = 10;

function needLogin(req, res, next) {
  if (!req.session.userId) {
    return res.status(401).json({ error: '로그인이 필요합니다.' });
  }
  next();
}

router.post('/api/login', errHandler(async (req, res) => {
  const username = String((req.body || {}).username || '');
  const password = String((req.body || {}).password || '');
  const db = getDb();
  const [rows] = await db.execute(
    'SELECT id, password, login_fail_count, is_locked FROM bdm_users WHERE username = ? LIMIT 1',
    [username]
  );
  if (!rows.length) {
    return res.status(400).json({ error: '아이디 또는 비밀번호가 올바르지 않습니다.' });
  }
  const u = rows[0];
  if (u.is_locked) {
    return res.status(403).json({ error: '계정이 잠겨있습니다. 관리자에게 문의하세요.' });
  }
  const match = await bcrypt.compare(password, String(u.password));
  if (!match) {
    const fail = (Number(u.login_fail_count) || 0) + 1;
    if (fail >= 5) {
      await db.execute('UPDATE bdm_users SET login_fail_count = ?, is_locked = 1 WHERE id = ?', [fail, u.id]);
      return res.status(403).json({ error: '비밀번호를 5회 틀려 계정이 잠겼습니다. 관리자에게 문의하세요.' });
    }
    await db.execute('UPDATE bdm_users SET login_fail_count = ? WHERE id = ?', [fail, u.id]);
    return res.status(400).json({ error: `아이디 또는 비밀번호가 올바르지 않습니다. (${fail}/5회 실패)` });
  }
  await db.execute('UPDATE bdm_users SET login_fail_count = 0 WHERE id = ?', [u.id]);
  req.session.userId = Number(u.id);
  res.json({ ok: true });
}));

router.post('/api/logout', (req, res) => {
  req.session.destroy(() => res.json({ ok: true }));
});

router.get('/api/me', errHandler(async (req, res) => {
  if (!req.session.userId) return res.status(401).json({ error: '로그인이 필요합니다.' });
  const db = getDb();
  const [rows] = await db.execute('SELECT id, username FROM bdm_users WHERE id = ? LIMIT 1', [req.session.userId]);
  if (!rows.length) return res.status(401).json({ error: '로그인이 필요합니다.' });
  res.json({ user: rows[0] });
}));

router.use(needLogin);

// ─── 발전소 목록 (간략, 드롭다운용) ─────────────────────────────────────────
router.get('/api/plants-list', errHandler(async (req, res) => {
  const db = getDb();
  const [rows] = await db.execute('SELECT id, plant_name FROM bdm_plants ORDER BY plant_name');
  res.json(rows);
}));

// ─── 발전소 목록 (전체, 페이지네이션) ───────────────────────────────────────
router.get('/api/plants', errHandler(async (req, res) => {
  const db = getDb();
  const { q = '', from = '', to = '', page = '1', limit = '25' } = req.query;
  const pageNum  = Math.max(1, parseInt(page)  || 1);
  const limitNum = Math.min(9999, Math.max(1, parseInt(limit) || 25));
  const offset   = (pageNum - 1) * limitNum;

  const wheres = [];
  const params = [];

  if (q) {
    wheres.push('(plant_name LIKE ? OR owner_name LIKE ? OR address LIKE ?)');
    params.push(`%${q}%`, `%${q}%`, `%${q}%`);
  }
  if (from) {
    wheres.push('(power_biz_permit_expire >= ? OR dev_permit_expire >= ?)');
    params.push(from, from);
  }
  if (to) {
    wheres.push('(power_biz_permit_expire <= ? OR dev_permit_expire <= ?)');
    params.push(to, to);
  }

  const where = wheres.length ? 'WHERE ' + wheres.join(' AND ') : '';
  const [[{ total }]] = await db.execute(`SELECT COUNT(*) AS total FROM bdm_plants ${where}`, params);
  const [rows] = await db.execute(
    `SELECT id, plant_name, owner_name, address, capacity, install_type,
            power_biz_permit_expire, dev_permit_expire, dev_permit_status, created_at
     FROM bdm_plants ${where} ORDER BY plant_name LIMIT ${limitNum} OFFSET ${offset}`,
    params
  );
  res.json({ total: Number(total), page: pageNum, limit: limitNum, plants: rows });
}));

// ─── 엑셀 내보내기 ───────────────────────────────────────────────────────────
router.get('/api/plants/export', errHandler(async (req, res) => {
  const db = getDb();
  const [rows] = await db.execute('SELECT * FROM bdm_plants ORDER BY plant_name');

  const total    = rows.length;
  const colCount = EXCEL_COLUMNS.length;
  const empty    = Array(colCount).fill('');
  const titleRow = ['사업개발부 발전소별 인허가 정보 리스트', ...Array(colCount - 1).fill('')];
  const countRow = [`발전소 정보 : ${total}건`, ...Array(colCount - 1).fill('')];
  const headers  = EXCEL_COLUMNS.map(c => c.header);
  const dataRows = rows.map((r, i) =>
    EXCEL_COLUMNS.map(c => {
      if (c.field === null) return i + 1;
      if (c.field === 'dev_permit_expire') return r.dev_permit_status || (r.dev_permit_expire != null ? r.dev_permit_expire : '');
      return r[c.field] != null ? r[c.field] : '';
    })
  );

  const aoa = [titleRow, empty, countRow, headers, ...dataRows];
  const ws  = XLSX.utils.aoa_to_sheet(aoa);

  ws['!merges'] = [
    { s: { r: 0, c: 0 }, e: { r: 0, c: colCount - 1 } },
    { s: { r: 2, c: 0 }, e: { r: 2, c: colCount - 1 } },
  ];
  ws['!cols'] = EXCEL_COLUMNS.map(c => ({ wch: c.wch }));

  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, '발전소현황');
  const buf = XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' });

  const filename = encodeURIComponent('발전소인허가현황.xlsx');
  res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  res.setHeader('Content-Disposition', `attachment; filename*=UTF-8''${filename}`);
  res.send(buf);
}));

// ─── 발전소 단건 조회 ────────────────────────────────────────────────────────
router.get('/api/plants/:id', errHandler(async (req, res) => {
  const db = getDb();
  const [rows] = await db.execute('SELECT * FROM bdm_plants WHERE id = ?', [req.params.id]);
  if (!rows.length) return res.status(404).json({ error: '발전소를 찾을 수 없습니다.' });
  res.json(rows[0]);
}));

// ─── 발전소 등록 ─────────────────────────────────────────────────────────────
router.post('/api/plants', errHandler(async (req, res) => {
  const db = getDb();
  const data = cleanBody(req.body);
  if (!data.plant_name) return res.status(400).json({ error: '발전소 명은 필수입니다.' });

  const fields = Object.keys(data);
  const vals   = Object.values(data);
  const [result] = await db.execute(
    `INSERT INTO bdm_plants (${fields.join(',')}) VALUES (${fields.map(() => '?').join(',')})`,
    vals
  );
  res.json({ id: result.insertId, ok: true });
}));

// ─── 발전소 수정 ─────────────────────────────────────────────────────────────
router.put('/api/plants/:id', errHandler(async (req, res) => {
  const db = getDb();
  const data = cleanBody(req.body);
  if (!data.plant_name) return res.status(400).json({ error: '발전소 명은 필수입니다.' });

  const sets = PLANT_FIELDS.map(f => `${f} = ?`).join(', ');
  const vals = [...PLANT_FIELDS.map(f => data[f] !== undefined ? data[f] : null), req.params.id];
  await db.execute(`UPDATE bdm_plants SET ${sets}, updated_at = NOW() WHERE id = ?`, vals);
  res.json({ ok: true });
}));

// ─── 발전소 삭제 (단건) ──────────────────────────────────────────────────────
router.delete('/api/plants/:id', errHandler(async (req, res) => {
  const db = getDb();
  const [rows] = await db.execute('SELECT biz_cert_filename FROM bdm_plants WHERE id = ?', [req.params.id]);
  if (rows.length && rows[0].biz_cert_filename) {
    deleteBizCertFile(req.params.id, rows[0].biz_cert_filename);
  }
  deletePlantDocsDir(req.params.id);
  await db.execute('DELETE FROM bdm_plant_files WHERE plant_id = ?', [req.params.id]);
  await db.execute('DELETE FROM bdm_plants WHERE id = ?', [req.params.id]);
  res.json({ ok: true });
}));

// ─── 발전소 일괄 삭제 ────────────────────────────────────────────────────────
router.post('/api/plants/bulk-delete', errHandler(async (req, res) => {
  const { ids } = req.body;
  if (!Array.isArray(ids) || !ids.length) return res.status(400).json({ error: 'ids 필요' });
  const db = getDb();
  const [rows] = await db.execute(
    `SELECT id, biz_cert_filename FROM bdm_plants WHERE id IN (${ids.map(() => '?').join(',')})`, ids
  );
  for (const r of rows) {
    if (r.biz_cert_filename) deleteBizCertFile(r.id, r.biz_cert_filename);
    deletePlantDocsDir(r.id);
  }
  await db.execute(`DELETE FROM bdm_plant_files WHERE plant_id IN (${ids.map(() => '?').join(',')})`, ids);
  await db.execute(`DELETE FROM bdm_plants WHERE id IN (${ids.map(() => '?').join(',')})`, ids);
  res.json({ ok: true, deleted: ids.length });
}));

// ─── 사업자등록증 헬퍼 (구 시스템 잔여 파일 정리용으로만 유지) ──────────────────
function deleteBizCertFile(id, filename) {
  const ext = path.extname(filename).toLowerCase();
  const filePath = path.join(BIZ_CERT_DIR, `${id}${ext}`);
  fs.unlink(filePath, () => {});
}

// ─── 발전소 첨부파일 (다중) ──────────────────────────────────────────────────
const PLANT_DOC_MIME = {
  '.pdf':  'application/pdf',
  '.jpg':  'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.png':  'image/png',
  '.gif':  'image/gif',
  '.webp': 'image/webp',
  '.hwp':  'application/x-hwp',
  '.hwpx': 'application/haansofthwpx',
  '.doc':  'application/msword',
  '.docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  '.xls':  'application/vnd.ms-excel',
  '.xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
};

function plantDocDir(plantId) { return path.join(PLANT_DOCS_DIR, String(plantId)); }
function deletePlantDocsDir(plantId) {
  fs.rm(plantDocDir(plantId), { recursive: true, force: true }, () => {});
}

// 목록
router.get('/api/plants/:id/files', errHandler(async (req, res) => {
  const db = getDb();
  const [rows] = await db.execute(
    'SELECT id, original_filename, file_size, uploaded_at FROM bdm_plant_files WHERE plant_id = ? ORDER BY uploaded_at DESC',
    [req.params.id]
  );
  res.json(rows);
}));

// 업로드 (여러 개 동시 가능)
router.post('/api/plants/:id/files', upload.array('files', PLANT_DOCS_MAX_PER_PLANT), errHandler(async (req, res) => {
  const id = parseInt(req.params.id);
  const db = getDb();
  const [plantRows] = await db.execute('SELECT id FROM bdm_plants WHERE id = ?', [id]);
  if (!plantRows.length) return res.status(404).json({ error: '발전소를 찾을 수 없습니다.' });
  if (!req.files || !req.files.length) return res.status(400).json({ error: '파일이 없습니다.' });

  const [[{ cnt }]] = await db.execute('SELECT COUNT(*) cnt FROM bdm_plant_files WHERE plant_id = ?', [id]);
  if (cnt + req.files.length > PLANT_DOCS_MAX_PER_PLANT) {
    return res.status(400).json({ error: `발전소당 최대 ${PLANT_DOCS_MAX_PER_PLANT}개까지 첨부 가능합니다. (현재 ${cnt}개)` });
  }

  const dir = plantDocDir(id);
  fs.mkdirSync(dir, { recursive: true });

  const uploaded = [];
  const rejected = [];
  for (const file of req.files) {
    const origName = Buffer.from(file.originalname, 'latin1').toString('utf8');
    const ext = path.extname(origName).toLowerCase();
    if (!PLANT_DOC_MIME[ext]) { rejected.push(origName); continue; }

    const [result] = await db.execute(
      'INSERT INTO bdm_plant_files (plant_id, original_filename, file_size) VALUES (?, ?, ?)',
      [id, origName, file.size]
    );
    const fileId = result.insertId;
    fs.writeFileSync(path.join(dir, `${fileId}${ext}`), file.buffer);
    uploaded.push({ id: fileId, original_filename: origName, file_size: file.size });
  }

  if (!uploaded.length) return res.status(400).json({ error: '허용되지 않는 파일 형식입니다.' });
  res.json({ ok: true, uploaded, rejected });
}));

// 다운로드 / 미리보기
router.get('/api/plants/:id/files/:fileId', errHandler(async (req, res) => {
  const id = parseInt(req.params.id);
  const fileId = parseInt(req.params.fileId);
  const db = getDb();
  const [rows] = await db.execute(
    'SELECT original_filename FROM bdm_plant_files WHERE id = ? AND plant_id = ?',
    [fileId, id]
  );
  if (!rows.length) return res.status(404).json({ error: '파일을 찾을 수 없습니다.' });

  const origName = rows[0].original_filename;
  const ext = path.extname(origName).toLowerCase();
  const filePath = path.join(plantDocDir(id), `${fileId}${ext}`);
  if (!fs.existsSync(filePath)) return res.status(404).json({ error: '파일을 찾을 수 없습니다.' });

  const contentType = PLANT_DOC_MIME[ext] || 'application/octet-stream';
  const forceDownload = req.query.download === '1';
  const disposition = (!forceDownload && (contentType === 'application/pdf' || contentType.startsWith('image/')))
    ? 'inline' : 'attachment';
  res.setHeader('Content-Type', contentType);
  res.setHeader('Content-Disposition', `${disposition}; filename*=UTF-8''${encodeURIComponent(origName)}`);
  res.sendFile(filePath);
}));

// 삭제
router.delete('/api/plants/:id/files/:fileId', errHandler(async (req, res) => {
  const id = parseInt(req.params.id);
  const fileId = parseInt(req.params.fileId);
  const db = getDb();
  const [rows] = await db.execute(
    'SELECT original_filename FROM bdm_plant_files WHERE id = ? AND plant_id = ?',
    [fileId, id]
  );
  if (!rows.length) return res.status(404).json({ error: '파일을 찾을 수 없습니다.' });

  const ext = path.extname(rows[0].original_filename).toLowerCase();
  fs.unlink(path.join(plantDocDir(id), `${fileId}${ext}`), () => {});
  await db.execute('DELETE FROM bdm_plant_files WHERE id = ?', [fileId]);
  res.json({ ok: true });
}));

// 일괄 삭제 (선택 삭제 / 전체 삭제 공용)
router.post('/api/plants/:id/files/bulk-delete', errHandler(async (req, res) => {
  const id = parseInt(req.params.id);
  const { ids } = req.body;
  if (!Array.isArray(ids) || !ids.length) return res.status(400).json({ error: 'ids 필요' });
  const db = getDb();
  const [rows] = await db.execute(
    `SELECT id, original_filename FROM bdm_plant_files WHERE plant_id = ? AND id IN (${ids.map(() => '?').join(',')})`,
    [id, ...ids]
  );
  for (const r of rows) {
    const ext = path.extname(r.original_filename).toLowerCase();
    fs.unlink(path.join(plantDocDir(id), `${r.id}${ext}`), () => {});
  }
  await db.execute(
    `DELETE FROM bdm_plant_files WHERE plant_id = ? AND id IN (${ids.map(() => '?').join(',')})`,
    [id, ...ids]
  );
  res.json({ ok: true, deleted: rows.length });
}));

// ─── 캘린더 이벤트 (만료일만 표시) ──────────────────────────────────────────
router.get('/api/events', errHandler(async (req, res) => {
  const year  = Number(req.query.year)  || new Date().getFullYear();
  const month = req.query.month ? Number(req.query.month) : null;

  // 캘린더에는 만료일(expire) 타입만 표시
  const calFields = EVENT_FIELDS.filter(e => e.type.endsWith('-expire'));

  const db = getDb();
  const selectCols = ['id', 'plant_name', ...calFields.map(e => e.field)].join(', ');
  const [plants] = await db.execute(`SELECT ${selectCols} FROM bdm_plants`);

  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const events = [];

  for (const plant of plants) {
    for (const ef of calFields) {
      const val = plant[ef.field];
      if (!val) continue;
      const dateStr = String(val).slice(0, 10);
      const d = new Date(dateStr + 'T00:00:00');
      if (month !== null) {
        if (d.getFullYear() !== year || d.getMonth() + 1 !== month) continue;
      } else {
        if (d.getFullYear() !== year) continue;
      }
      events.push({
        plantId:   plant.id,
        plantName: plant.plant_name,
        date:      dateStr,
        field:     ef.field,
        label:     ef.label,
        type:      ef.type,
        isPast:    d < today,
      });
    }
  }

  events.sort((a, b) => a.date.localeCompare(b.date));
  res.json(events);
}));

// ─── 알림 (만료 초과 + 곧 만료) ─────────────────────────────────────────────
// 준공일 또는 상업운전개시일이 하나라도 등록된 발전소는 제외
router.get('/api/alerts', errHandler(async (req, res) => {
  const db = getDb();
  const expireFields = EVENT_FIELDS.filter(e => e.type.endsWith('-expire'));
  const cols = [
    'id', 'plant_name',
    ...expireFields.map(e => e.field),
    'dev_completion_date', 'commercial_operation_date',
  ].join(', ');
  const [plants] = await db.execute(`SELECT ${cols} FROM bdm_plants`);

  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const SOON_DAYS = 60;
  const overdue  = [];
  const upcoming = [];

  for (const plant of plants) {
    // 준공일 또는 운전개시일이 있으면 알림 제외
    if (plant.dev_completion_date || plant.commercial_operation_date) continue;

    for (const ef of expireFields) {
      const val = plant[ef.field];
      if (!val) continue;
      const dateStr = String(val).slice(0, 10);
      if (parseInt(dateStr) < 1900) continue;   // 0000-xx-xx 등 무효 날짜 제외
      const d    = new Date(dateStr + 'T00:00:00');
      const diff = Math.floor((d - today) / 86400000);

      const item = {
        plantId:   plant.id,
        plantName: plant.plant_name,
        label:     ef.label,
        type:      ef.type,
        date:      dateStr,
      };

      if (diff < 0) {
        overdue.push({ ...item, daysAgo: Math.abs(diff) });
      } else if (diff <= SOON_DAYS) {
        upcoming.push({ ...item, daysLeft: diff });
      }
    }
  }

  overdue.sort((a, b)  => a.daysAgo  - b.daysAgo);
  upcoming.sort((a, b) => a.daysLeft - b.daysLeft);
  res.json({ overdue, upcoming });
}));

// ─── 엑셀 가져오기 ───────────────────────────────────────────────────────────
router.post('/api/plants/import', upload.single('file'), errHandler(async (req, res) => {
  if (!req.file) return res.status(400).json({ error: '파일이 없습니다.' });

  const wb = XLSX.read(req.file.buffer, { type: 'buffer', cellDates: true });

  // 모든 시트를 순회하며 "발전소 명" 헤더가 있는 시트+행을 찾음
  let rows = [];
  let headerRowIdx = -1;

  for (const sheetName of wb.SheetNames) {
    const ws = wb.Sheets[sheetName];
    const sheetRows = XLSX.utils.sheet_to_json(ws, { header: 1, defval: '' });
    for (let i = 0; i < Math.min(8, sheetRows.length); i++) {
      const cells = sheetRows[i].map(h => String(h).trim());
      if (cells.includes('발전소 명') || cells.includes('발전소명')) {
        rows = sheetRows;
        headerRowIdx = i;
        break;
      }
    }
    if (headerRowIdx !== -1) break;
  }

  if (headerRowIdx === -1) return res.json({ inserted: 0, skipped: 0, error: '헤더를 찾을 수 없습니다.' });

  const headerRow = rows[headerRowIdx].map(h => String(h).trim());
  const db = getDb();
  let inserted = 0, updated = 0, skipped = 0;

  // 기존 발전소 목록 조회 (plant_name + owner_name 기준 upsert)
  const [existingRows] = await db.execute('SELECT id, plant_name, owner_name FROM bdm_plants');
  const existingMap = new Map();
  for (const r of existingRows) {
    const key = `${(r.plant_name || '').trim()}__${(r.owner_name || '').trim()}`;
    existingMap.set(key, r.id);
  }

  for (let i = headerRowIdx + 1; i < rows.length; i++) {
    const row = rows[i];
    const obj = {};
    headerRow.forEach((h, idx) => {
      if (h === '번호') return;
      const field = EXCEL_HEADER_MAP[h];
      if (!field) return;
      let val = row[idx];
      if (field === 'dev_permit_expire') {
        const raw = (val instanceof Date) ? val.toISOString().slice(0, 10) : String(val || '').trim();
        if (raw === '미대상' || raw === '면제대상') {
          obj.dev_permit_status = raw;
          obj.dev_permit_expire = null;
        } else {
          obj.dev_permit_expire = (raw.length > 0 && /^\d/.test(raw)) ? raw.slice(0, 10) : null;
        }
      } else if (field === 'dev_permit_status') {
        const raw = String(val || '').trim();
        if (raw === '미대상' || raw === '면제대상') obj.dev_permit_status = raw;
      } else if (DATE_FIELD_SET.has(field) || field === 'memo') {
        if (val instanceof Date) {
          val = val.toISOString().slice(0, 10);
        } else {
          const s = String(val || '').trim();
          val = (s.length > 0 && /^\d/.test(s)) ? s.slice(0, 10) : null;
        }
        obj[field] = val;
      } else {
        obj[field] = (val instanceof Date) ? val.toISOString().slice(0, 10) : String(val ?? '').trim();
      }
    });

    if (!obj.plant_name) { skipped++; continue; }

    const key = `${obj.plant_name.trim()}__${(obj.owner_name || '').trim()}`;
    const existingId = existingMap.get(key);

    try {
      if (existingId) {
        // 발전소명 + 사업주명 일치 → UPDATE
        const fields = Object.keys(obj).filter(f => f !== 'plant_name');
        if (fields.length) {
          await db.execute(
            `UPDATE bdm_plants SET ${fields.map(f => `${f}=?`).join(',')} WHERE id=?`,
            [...fields.map(f => obj[f]), existingId]
          );
        }
        updated++;
      } else {
        // 신규 → INSERT
        const fields = Object.keys(obj);
        await db.execute(
          `INSERT INTO bdm_plants (${fields.join(',')}) VALUES (${fields.map(() => '?').join(',')})`,
          fields.map(f => obj[f])
        );
        const key2 = `${obj.plant_name}__${obj.owner_name || ''}`;
        existingMap.set(key2, -1); // 같은 파일 내 중복 방지
        inserted++;
      }
    } catch { skipped++; }
  }

  res.json({ inserted, updated, skipped });
}));

(async () => {
  try {
    await initDb();
    app.listen(PORT, () => console.log(`일정관리 서버 실행 중: http://localhost:${PORT}`));
  } catch (e) {
    console.error('서버 시작 실패:', e);
    process.exit(1);
  }
})();
