'use strict';

const path = require('path');
const fs = require('fs');
const multer = require('multer');
const express = require('express');
const bcryptjs = require('bcryptjs');
const pool = require('../db');
const { publicUser, requireFields } = require('../utils');
const { checkStatus } = require('../lib/businessApi');

const router = express.Router();

// 가입 신청과 함께 회사 로고를 바로 등록할 수 있게(선택) — 승인 후 별도 설정 없이 즉시 적용됨
const LOGO_DIR = path.join(__dirname, '..', 'uploads', 'logos');
fs.mkdirSync(LOGO_DIR, { recursive: true });
const LOGO_MIME_EXT = { 'image/png': '.png', 'image/jpeg': '.jpg', 'image/webp': '.webp', 'image/svg+xml': '.svg' };
const registerLogoUpload = multer({
  storage: multer.diskStorage({
    destination: (_req, _file, cb) => cb(null, LOGO_DIR),
    filename: (_req, file, cb) => cb(null, `reg-${Date.now()}-${Math.round(Math.random() * 1e6)}${LOGO_MIME_EXT[file.mimetype]}`)
  }),
  limits: { fileSize: 2 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    if (!LOGO_MIME_EXT[file.mimetype]) return cb(new Error('PNG, JPG, WEBP, SVG 형식의 이미지만 업로드할 수 있습니다.'));
    cb(null, true);
  }
});
function removeLogoFile(logoUrl) {
  if (!logoUrl || !logoUrl.startsWith('/uploads/logos/')) return;
  fs.unlink(path.join(__dirname, '..', logoUrl), () => {});
}

router.get('/me', async (req, res) => {
  if (!req.session.user) return res.json({ user: null });
  const { rows } = await pool.query('SELECT * FROM users WHERE id = $1', [req.session.user.id]);
  const user = publicUser(rows[0]);
  req.session.user = user;
  res.json({ user });
});

router.post('/login', async (req, res) => {
  const missing = requireFields(req.body, ['username', 'password']);
  if (missing.length) return res.status(400).json({ message: '아이디와 비밀번호를 입력해주세요.' });

  const { rows } = await pool.query('SELECT * FROM users WHERE username = $1', [req.body.username]);
  const user = rows[0];
  const valid = user && await bcryptjs.compare(req.body.password, user.password);
  if (!valid) {
    return res.status(401).json({ message: '아이디 또는 비밀번호가 올바르지 않습니다.' });
  }
  if (user.status !== 'active') {
    return res.status(403).json({ message: '관리자 승인 후 로그인할 수 있습니다.' });
  }

  req.session.user = publicUser(user);
  res.json({ user: req.session.user });
});

router.post('/logout', (req, res) => {
  req.session.destroy(() => res.json({ ok: true }));
});

router.post('/register', (req, res) => {
  registerLogoUpload.single('logo')(req, res, async (uploadErr) => {
    if (uploadErr) return res.status(400).json({ message: uploadErr.message || '로고 업로드에 실패했습니다.' });

    const missing = requireFields(req.body, [
      'password', 'name', 'phone', 'company_name', 'company_phone',
      'business_number', 'business_type', 'business_item', 'address'
    ]);
    if (missing.length) {
      removeLogoFile(req.file && `/uploads/logos/${req.file.filename}`);
      return res.status(400).json({ message: '필수 항목을 입력해주세요.' });
    }

    const username = String(req.body.business_number).replace(/\D/g, '');
    if (username.length !== 10) {
      removeLogoFile(req.file && `/uploads/logos/${req.file.filename}`);
      return res.status(400).json({ message: '사업자등록번호 10자리를 정확히 입력해주세요.' });
    }

    try {
      const check = await checkStatus(req.body.business_number);
      if (!check.ok) throw Object.assign(new Error(check.message), { statusCode: 400 });
      if (!check.found) throw Object.assign(new Error(check.message || '국세청에 등록되지 않은 사업자등록번호입니다.'), { statusCode: 400 });
    } catch (error) {
      removeLogoFile(req.file && `/uploads/logos/${req.file.filename}`);
      if (error.statusCode) return res.status(error.statusCode).json({ message: error.message });
      return res.status(502).json({ message: '사업자등록정보 확인에 실패했습니다. 잠시 후 다시 시도해주세요.' });
    }

    const logoUrl = req.file ? `/uploads/logos/${req.file.filename}` : null;
    try {
      const hashedPw = await bcryptjs.hash(req.body.password, 10);
      const { rows } = await pool.query(
        `INSERT INTO users
           (username, password, name, phone, company_name, company_phone, fax, business_number,
            ceo_name, open_date, business_type, business_item, address, address_detail, logo_url, role, status,
            manager_name, manager_phone)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, 'dealer', 'pending', $3, $4)
         RETURNING id, username, name, phone, company_name, company_phone, fax, business_number,
           ceo_name, open_date, business_type, business_item, address, address_detail, logo_url, role, status, created_at,
           manager_name, manager_phone`,
        [
          username, hashedPw, req.body.name, req.body.phone,
          req.body.company_name, req.body.company_phone || null, req.body.fax || null, req.body.business_number,
          null, null, req.body.business_type || null, req.body.business_item || null,
          req.body.address || null, req.body.address_detail || null, logoUrl
        ]
      );
      res.status(201).json({ user: rows[0] });
    } catch (error) {
      removeLogoFile(logoUrl);
      if (error.code === '23505') return res.status(409).json({ message: '이미 등록된 사업자등록번호입니다.' });
      throw error;
    }
  });
});

// 소속(제조사/총판) 선택형 직원 가입: 사업자등록번호 진위확인 없이 간소화된 정보만 받음
router.post('/register-staff', async (req, res) => {
  const missing = requireFields(req.body, ['username', 'password', 'name', 'phone', 'affiliation_type']);
  if (missing.length) return res.status(400).json({ message: '필수 항목을 입력해주세요.' });

  const username = String(req.body.username).trim();
  if (username.length < 3) {
    return res.status(400).json({ message: '아이디는 3자 이상 입력해주세요.' });
  }

  const affiliationType = req.body.affiliation_type;
  if (!['admin', 'distributor'].includes(affiliationType)) {
    return res.status(400).json({ message: '소속을 선택해주세요.' });
  }

  let role = 'admin';
  let companyName = 'AT Global';
  let distributorId = null;

  if (affiliationType === 'distributor') {
    const distributor = await pool.query(
      `SELECT id, company_name FROM users
       WHERE id = $1 AND role = 'distributor' AND distributor_id IS NULL AND status = 'active'`,
      [req.body.affiliation_id]
    );
    if (!distributor.rows[0]) {
      return res.status(400).json({ message: '선택한 총판을 찾을 수 없습니다.' });
    }
    role = 'distributor';
    companyName = distributor.rows[0].company_name;
    distributorId = distributor.rows[0].id;
  }

  try {
    const hashedPw = await bcryptjs.hash(req.body.password, 10);
    const { rows } = await pool.query(
      `INSERT INTO users
         (username, password, name, phone, company_name, role, distributor_id, status,
          manager_name, manager_phone, manager_department, manager_position)
       VALUES ($1, $2, $3, $4, $5, $6, $7, 'pending', $3, $4, $8, $9)
       RETURNING id, username, name, phone, company_name, role, status, created_at,
         manager_department, manager_position`,
      [username, hashedPw, req.body.name, req.body.phone, companyName, role, distributorId,
       req.body.manager_department || null, req.body.manager_position || null]
    );
    res.status(201).json({ user: rows[0] });
  } catch (error) {
    if (error.code === '23505') return res.status(409).json({ message: '이미 사용 중인 아이디입니다.' });
    throw error;
  }
});

// 회원가입 폼에서 "소속" 드롭다운을 채우기 위한 공개 목록 (로그인 불필요)
router.get('/staff-companies', async (_req, res) => {
  const { rows } = await pool.query(
    `SELECT id, company_name FROM users
     WHERE role = 'distributor' AND distributor_id IS NULL AND status = 'active'
     ORDER BY company_name`
  );
  res.json({
    companies: [
      { type: 'admin', id: null, label: 'AT Global (제조사)' },
      ...rows.map((r) => ({ type: 'distributor', id: r.id, label: r.company_name }))
    ]
  });
});

module.exports = router;
