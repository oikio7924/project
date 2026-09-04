'use strict';

const path = require('path');
const fs = require('fs');
const multer = require('multer');
const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');
const roleCheck = require('../middleware/roleCheck');
const {
  publicUser, companyId, canManageTarget, anonymizeUser,
  getActiveDependentDealers, anonymizeDistributorStaff
} = require('../utils');

const router = express.Router();

const LOGO_DIR = path.join(__dirname, '..', 'uploads', 'logos');
fs.mkdirSync(LOGO_DIR, { recursive: true });
const LOGO_MIME_EXT = { 'image/png': '.png', 'image/jpeg': '.jpg', 'image/webp': '.webp', 'image/svg+xml': '.svg' };
const logoUpload = multer({
  storage: multer.diskStorage({
    destination: (_req, _file, cb) => cb(null, LOGO_DIR),
    filename: (req, file, cb) => cb(null, `${req.session.user.id}-${Date.now()}${LOGO_MIME_EXT[file.mimetype]}`)
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

// 대리점 전용: 소속 총판 연락처 조회
router.get('/my-distributor', requireAuth, roleCheck('dealer'), async (req, res) => {
  const distributorId = req.session.user.distributor_id;
  if (!distributorId) return res.json({ distributor: null });
  const { rows } = await pool.query(
    `SELECT id, name, company_name, phone, manager_name, manager_phone, manager_email
     FROM users WHERE id = $1`,
    [distributorId]
  );
  res.json({ distributor: rows[0] || null });
});

const DEALER_LIST_FIELDS = `id, username, name, company_name, business_number, ceo_name, address,
  company_phone, phone, fax, manager_name, manager_phone, manager_email, status, created_at`;

// 총판 전용(회원관리 권한 무관, 소속 직원 누구나): 자기 회사 소속 대리점 목록 조회(읽기 전용)
router.get('/my-dealers', requireAuth, roleCheck('distributor'), async (req, res) => {
  const { rows } = await pool.query(
    `SELECT ${DEALER_LIST_FIELDS} FROM users
     WHERE role = 'dealer' AND status = 'active' AND distributor_id = $1
     ORDER BY company_name`,
    [companyId(req.session.user)]
  );
  res.json({ dealers: rows });
});

// 제조사 전용(회원관리 권한 무관): 총판을 선택해 그 총판 소속 대리점만, 또는 전체 대리점 목록 조회(읽기 전용)
router.get('/dealers', requireAuth, roleCheck('admin'), async (req, res) => {
  const distributorId = req.query.distributor_id ? Number(req.query.distributor_id) : null;
  const params = [];
  let where = "WHERE u.role = 'dealer' AND u.status = 'active'";
  if (Number.isInteger(distributorId)) {
    params.push(distributorId);
    where += ` AND u.distributor_id = $1`;
  }
  const { rows } = await pool.query(
    `SELECT u.id, u.username, u.name, u.company_name, u.business_number, u.ceo_name, u.address,
            u.company_phone, u.phone, u.fax, u.manager_name, u.manager_phone, u.manager_email,
            u.status, u.created_at, d.company_name AS distributor_company
     FROM users u
     LEFT JOIN users d ON d.id = u.distributor_id
     ${where}
     ORDER BY u.company_name`,
    params
  );
  res.json({ dealers: rows });
});

// 대리점 소속 총판 배정/조회용 목록 — 제조사 전용(회원관리 권한 무관)
router.get('/distributors', requireAuth, roleCheck('admin'), async (_req, res) => {
  const { rows } = await pool.query(
    `SELECT id, username, name, company_name FROM users
     WHERE role = 'distributor' AND distributor_id IS NULL AND status = 'active'
     ORDER BY company_name, name`
  );
  res.json({ users: rows });
});

router.patch('/me', requireAuth, async (req, res) => {
  const allowed = [
    'name', 'phone', 'address', 'address_detail', 'company_name', 'company_phone', 'business_number', 'fax', 'ceo_name',
    'business_type', 'business_item',
    'manager_name', 'manager_department', 'manager_position',
    'manager_phone', 'manager_email', 'manager_memo'
  ];
  const fields = [];
  const values = [];
  for (const key of allowed) {
    if (req.body[key] !== undefined) {
      fields.push(`${key} = $${fields.length + 1}`);
      values.push(req.body[key]);
    }
  }
  if (req.body.password) {
    const bcryptjs = require('bcryptjs');
    fields.push(`password = $${fields.length + 1}`);
    values.push(await bcryptjs.hash(req.body.password, 10));
  }
  if (!fields.length) return res.status(400).json({ message: '변경할 항목이 없습니다.' });
  values.push(req.session.user.id);
  const { rows } = await pool.query(
    `UPDATE users SET ${fields.join(', ')}, updated_at = NOW() WHERE id = $${values.length} RETURNING *`,
    values
  );
  req.session.user = publicUser(rows[0]);
  res.json({ user: publicUser(rows[0]) });
});

// 총판/대리점이 헤더·발주서·거래명세서 등에 쓸 자사 로고를 직접 등록. 등록하지 않으면 해당 영역은 공란으로 표시된다.
router.post('/me/logo', requireAuth, roleCheck('distributor', 'dealer'), (req, res) => {
  logoUpload.single('logo')(req, res, async (err) => {
    if (err) return res.status(400).json({ message: err.message || '로고 업로드에 실패했습니다.' });
    if (!req.file) return res.status(400).json({ message: '업로드할 이미지를 선택해주세요.' });

    const prev = await pool.query('SELECT logo_url FROM users WHERE id = $1', [req.session.user.id]);
    removeLogoFile(prev.rows[0]?.logo_url);

    const logoUrl = `/uploads/logos/${req.file.filename}`;
    const { rows } = await pool.query(
      `UPDATE users SET logo_url = $1, updated_at = NOW() WHERE id = $2 RETURNING *`,
      [logoUrl, req.session.user.id]
    );
    req.session.user = publicUser(rows[0]);
    res.json({ user: publicUser(rows[0]) });
  });
});

router.delete('/me/logo', requireAuth, roleCheck('distributor', 'dealer'), async (req, res) => {
  const prev = await pool.query('SELECT logo_url FROM users WHERE id = $1', [req.session.user.id]);
  removeLogoFile(prev.rows[0]?.logo_url);
  const { rows } = await pool.query(
    `UPDATE users SET logo_url = NULL, updated_at = NOW() WHERE id = $1 RETURNING *`,
    [req.session.user.id]
  );
  req.session.user = publicUser(rows[0]);
  res.json({ user: publicUser(rows[0]) });
});

// 이 아래는 회원관리 전용: 제조사(전체 관리) 또는 총판(자기 회사 소속 직원만) 중,
// 관리자(is_owner) 또는 담당자(is_member_manager)로 지정된 계정만 접근 가능
router.use(requireAuth, roleCheck('admin', 'distributor'));
router.use((req, res, next) => {
  if (!req.session.user.is_owner && !req.session.user.is_member_manager) {
    return res.status(403).json({ message: '회원관리 권한이 없습니다.' });
  }
  next();
});

router.get('/pending', async (req, res) => {
  const params = [];
  let where = "WHERE status = 'pending'";
  if (req.session.user.role === 'distributor') {
    params.push(companyId(req.session.user));
    where += ` AND role = 'distributor' AND (id = $1 OR distributor_id = $1)`;
  }
  const { rows } = await pool.query(
    `SELECT id, username, name, phone, company_name, role, status, distributor_id, created_at
     FROM users ${where} ORDER BY created_at DESC, id DESC`,
    params
  );
  res.json({ users: rows });
});

router.get('/', async (req, res) => {
  const params = [];
  let where = '';
  if (req.session.user.role === 'distributor') {
    params.push(companyId(req.session.user));
    where = `WHERE u.role = 'distributor' AND (u.id = $1 OR u.distributor_id = $1)`;
  }
  const { rows } = await pool.query(
    `SELECT u.id, u.username, u.name, u.phone, u.company_name, u.role, u.status,
            u.distributor_id, u.address, u.is_owner, u.is_member_manager,
            u.manager_name, u.manager_department, u.manager_position,
            u.manager_phone, u.manager_email, u.manager_memo,
            d.company_name AS distributor_name, u.created_at
     FROM users u
     LEFT JOIN users d ON d.id = u.distributor_id
     ${where}
     ORDER BY u.created_at DESC, u.id DESC`,
    params
  );
  res.json({ users: rows });
});

router.post('/:id/approve', async (req, res) => {
  const target = await pool.query('SELECT id, role, distributor_id FROM users WHERE id = $1', [req.params.id]);
  if (!target.rows[0]) return res.status(404).json({ message: '회원을 찾을 수 없습니다.' });
  if (!canManageTarget(req.session.user, target.rows[0])) {
    return res.status(403).json({ message: '이 회원을 관리할 권한이 없습니다.' });
  }

  // 직원가입(제조사/총판)은 가입 시점에 이미 role·소속이 정해져 있어 별도 역할 선택 없이 바로 승인
  if (target.rows[0].role === 'admin' || (target.rows[0].role === 'distributor' && target.rows[0].distributor_id !== null)) {
    const { rows } = await pool.query(
      `UPDATE users SET status = 'active', updated_at = NOW() WHERE id = $1 RETURNING *`,
      [req.params.id]
    );
    return res.json({ user: publicUser(rows[0]) });
  }

  // 지점가입(사업자번호 인증) 승인: 총판/대리점 역할 선택 — 제조사만 도달 가능(canManageTarget이 이미 보장)
  const { distributor_id, role } = req.body;
  if (!role || !['distributor', 'dealer'].includes(role)) {
    return res.status(400).json({ message: '총판 또는 대리점 역할을 선택해주세요.' });
  }
  if (role === 'dealer' && !distributor_id) {
    return res.status(400).json({ message: '대리점은 소속 총판 지정이 필요합니다.' });
  }
  const { rows } = await pool.query(
    `UPDATE users
     SET status = 'active', role = $2, distributor_id = $3,
         is_owner = ($2::varchar = 'distributor'), updated_at = NOW()
     WHERE id = $1 RETURNING *`,
    [req.params.id, role, role === 'dealer' ? (distributor_id || null) : null]
  );
  res.json({ user: publicUser(rows[0]) });
});

router.post('/:id/reject', async (req, res) => {
  const target = await pool.query('SELECT id, role, distributor_id FROM users WHERE id = $1', [req.params.id]);
  if (!target.rows[0]) return res.status(404).json({ message: '회원을 찾을 수 없습니다.' });
  if (!canManageTarget(req.session.user, target.rows[0])) {
    return res.status(403).json({ message: '이 회원을 관리할 권한이 없습니다.' });
  }
  const { rows } = await pool.query(
    `UPDATE users SET status = 'rejected', updated_at = NOW() WHERE id = $1 RETURNING *`,
    [req.params.id]
  );
  res.json({ user: publicUser(rows[0]) });
});

router.post('/:id/unreject', async (req, res) => {
  const target = await pool.query('SELECT id, role, distributor_id FROM users WHERE id = $1', [req.params.id]);
  if (!target.rows[0]) return res.status(404).json({ message: '회원을 찾을 수 없습니다.' });
  if (!canManageTarget(req.session.user, target.rows[0])) {
    return res.status(403).json({ message: '이 회원을 관리할 권한이 없습니다.' });
  }
  const { rows } = await pool.query(
    `UPDATE users SET status = 'pending', updated_at = NOW() WHERE id = $1 AND status = 'rejected' RETURNING *`,
    [req.params.id]
  );
  if (!rows[0]) return res.status(404).json({ message: '거부된 회원을 찾을 수 없습니다.' });
  res.json({ user: publicUser(rows[0]) });
});

// 대리점 소속 총판 재배정 — 제조사 전용 기능
router.patch('/:id/distributor', roleCheck('admin'), async (req, res) => {
  const { rows } = await pool.query(
    `UPDATE users SET distributor_id = $2, updated_at = NOW()
     WHERE id = $1 AND role = 'dealer' RETURNING *`,
    [req.params.id, req.body.distributor_id]
  );
  if (!rows[0]) return res.status(404).json({ message: '대리점 회원을 찾을 수 없습니다.' });
  res.json({ user: publicUser(rows[0]) });
});

// 담당자 지정/해제 — 그 회사의 관리자만 가능(담당자가 다른 직원을 담당자로 지정할 수는 없음)
router.patch('/:id/member-manager', async (req, res) => {
  if (!req.session.user.is_owner) {
    return res.status(403).json({ message: '관리자만 담당자를 지정할 수 있습니다.' });
  }
  const target = await pool.query('SELECT id, role, distributor_id, is_owner FROM users WHERE id = $1', [req.params.id]);
  if (!target.rows[0]) return res.status(404).json({ message: '회원을 찾을 수 없습니다.' });
  if (target.rows[0].is_owner) {
    return res.status(400).json({ message: '관리자 계정은 담당자 지정 대상이 아닙니다.' });
  }
  // 담당자 지정은 같은 소속(제조사↔제조사, 총판↔자기 총판)끼리만 — 제조사가 총판 담당자를,
  // 총판이 제조사 담당자를 지정하는 교차 관리는 허용하지 않는다.
  if (target.rows[0].role !== req.session.user.role) {
    return res.status(403).json({ message: '같은 소속 직원만 담당자로 지정할 수 있습니다.' });
  }
  if (!canManageTarget(req.session.user, target.rows[0])) {
    return res.status(403).json({ message: '이 회원을 관리할 권한이 없습니다.' });
  }
  const isMemberManager = !!req.body.is_member_manager;
  const { rows } = await pool.query(
    `UPDATE users SET is_member_manager = $2, updated_at = NOW() WHERE id = $1 RETURNING *`,
    [req.params.id, isMemberManager]
  );
  res.json({ user: publicUser(rows[0]) });
});

router.patch('/:id', async (req, res) => {
  const target = await pool.query('SELECT role, distributor_id, is_owner FROM users WHERE id = $1', [req.params.id]);
  if (!target.rows[0]) return res.status(404).json({ message: '회원을 찾을 수 없습니다.' });
  if (!canManageTarget(req.session.user, target.rows[0])) {
    return res.status(403).json({ message: '이 회원을 관리할 권한이 없습니다.' });
  }

  const {
    name, phone, company_name, address, status, password, role, distributor_id,
    manager_name, manager_department, manager_position, manager_phone, manager_email, manager_memo
  } = req.body;

  const bcryptjs = require('bcryptjs');
  const hashedPw = password ? await bcryptjs.hash(password, 10) : null;

  if (target.rows[0].role === 'admin') {
    const { rows } = await pool.query(
      `UPDATE users
       SET name               = COALESCE($2, name),
           phone              = COALESCE($3, phone),
           address            = COALESCE($4, address),
           password           = CASE WHEN $5::text IS NOT NULL THEN $5 ELSE password END,
           manager_name       = COALESCE($6, manager_name),
           manager_department = COALESCE($7, manager_department),
           manager_position   = COALESCE($8, manager_position),
           manager_phone      = COALESCE($9, manager_phone),
           manager_email      = COALESCE($10, manager_email),
           manager_memo       = COALESCE($11, manager_memo),
           updated_at = NOW()
       WHERE id = $1 RETURNING *`,
      [
        req.params.id, name, phone, address, hashedPw,
        manager_name, manager_department, manager_position, manager_phone, manager_email, manager_memo
      ]
    );
    return res.json({ user: publicUser(rows[0]) });
  }

  // 총판(담당자 포함) 액터는 자기 회사 직원의 회사구조(역할·소속 총판)를 바꿀 수 없음 — 제조사만 가능
  if (req.session.user.role === 'distributor') {
    const { rows } = await pool.query(
      `UPDATE users
       SET name           = COALESCE($2, name),
           phone          = COALESCE($3, phone),
           address        = COALESCE($4, address),
           status         = COALESCE($5, status),
           password       = CASE WHEN $6::text IS NOT NULL THEN $6 ELSE password END,
           manager_name       = COALESCE($7, manager_name),
           manager_department = COALESCE($8, manager_department),
           manager_position   = COALESCE($9, manager_position),
           manager_phone      = COALESCE($10, manager_phone),
           manager_email      = COALESCE($11, manager_email),
           manager_memo       = COALESCE($12, manager_memo),
           updated_at     = NOW()
       WHERE id = $1 RETURNING *`,
      [
        req.params.id, name, phone, address, status, hashedPw,
        manager_name, manager_department, manager_position, manager_phone, manager_email, manager_memo
      ]
    );
    return res.json({ user: publicUser(rows[0]) });
  }

  const { rows } = await pool.query(
    `UPDATE users
     SET name           = COALESCE($2, name),
         phone          = COALESCE($3, phone),
         company_name   = COALESCE($4, company_name),
         address        = COALESCE($5, address),
         status         = COALESCE($6, status),
         password       = CASE WHEN $7::text IS NOT NULL THEN $7 ELSE password END,
         role           = COALESCE($8, role),
         distributor_id = $9,
         manager_name       = COALESCE($10, manager_name),
         manager_department = COALESCE($11, manager_department),
         manager_position   = COALESCE($12, manager_position),
         manager_phone      = COALESCE($13, manager_phone),
         manager_email      = COALESCE($14, manager_email),
         manager_memo       = COALESCE($15, manager_memo),
         updated_at     = NOW()
     WHERE id = $1 RETURNING *`,
    [
      req.params.id, name, phone, company_name, address, status, hashedPw, role, distributor_id || null,
      manager_name, manager_department, manager_position, manager_phone, manager_email, manager_memo
    ]
  );
  res.json({ user: publicUser(rows[0]) });
});

// [회원 삭제]: 발주/출고/판매 등 업무 이력은 전혀 건드리지 않고 보존한다. 개인정보보호법상
// 개인정보가 아닌 상호명(company_name)만 남기고 로그인 정보를 포함한 개인정보는 모두 지운다.
// 단, 총판 관리자(회사 자체)는 삭제되면 더 이상 대리점 발주를 전환해줄 수 없게 되므로
// [모든 데이터 삭제]와 동일하게 소속 대리점 재배정 게이트를 거치고, 통과하면 소속 직원도 함께 익명화한다.
router.delete('/:id', async (req, res) => {
  const target = await pool.query('SELECT id, role, distributor_id, is_owner FROM users WHERE id = $1', [req.params.id]);
  if (!target.rows[0]) return res.status(404).json({ message: '회원을 찾을 수 없습니다.' });
  const targetUser = target.rows[0];
  if (targetUser.is_owner && targetUser.role !== 'distributor') {
    return res.status(403).json({ message: '관리자 계정은 삭제할 수 없습니다.' });
  }
  if (!canManageTarget(req.session.user, targetUser)) {
    return res.status(403).json({ message: '이 회원을 관리할 권한이 없습니다.' });
  }

  const isDistributorRoot = targetUser.role === 'distributor' && targetUser.distributor_id === null;
  if (isDistributorRoot) {
    const dealers = await getActiveDependentDealers(pool, targetUser.id);
    if (dealers.length > 0) {
      return res.status(409).json({ needsReassignment: true, dealers });
    }
    await anonymizeDistributorStaff(pool, targetUser.id);
  }

  const user = await anonymizeUser(pool, targetUser.id);
  res.json({ user: publicUser(user) });
});

// [모든 데이터 삭제]
// - 대리점: 발주/출고/판매 이력까지 포함해 완전히 하드 삭제(다른 회원 이력 보존 의무가 없음)
// - 총판: 소속 대리점이 남아있으면 판매가·재고 정보를 잃어 발주가 막히므로 먼저 재배정을 요구(409).
//   총판은 대리점과 발주 이력을 공유하므로 이력 자체는 지우지 않고, 총판 전용 설정 데이터(재고뷰/판매가)만
//   정리한 뒤 [회원 삭제]와 동일하게 익명화한다. 총판 회사 소속 직원(비관리자) 개별 삭제는 회사 데이터에
//   영향이 없으므로 재배정 게이트 없이 바로 익명화한다.
router.post('/:id/purge', async (req, res) => {
  const target = await pool.query('SELECT id, role, distributor_id, is_owner FROM users WHERE id = $1', [req.params.id]);
  if (!target.rows[0]) return res.status(404).json({ message: '회원을 찾을 수 없습니다.' });
  const targetUser = target.rows[0];
  if (targetUser.is_owner && targetUser.role !== 'distributor') {
    return res.status(403).json({ message: '관리자 계정은 삭제할 수 없습니다.' });
  }
  if (!canManageTarget(req.session.user, targetUser)) {
    return res.status(403).json({ message: '이 회원을 관리할 권한이 없습니다.' });
  }

  if (targetUser.role === 'dealer') {
    const client = await pool.connect();
    try {
      await client.query('BEGIN');
      const id = targetUser.id;
      await client.query(`DELETE FROM sales WHERE dealer_id = $1`, [id]);
      await client.query(
        `DELETE FROM shipment_items WHERE shipment_id IN (SELECT id FROM shipments WHERE dealer_id = $1)`,
        [id]
      );
      await client.query(`UPDATE shipments SET received_by = NULL WHERE received_by = $1`, [id]);
      await client.query(`DELETE FROM shipments WHERE dealer_id = $1`, [id]);
      await client.query(
        `DELETE FROM order_items WHERE order_id IN (SELECT id FROM orders WHERE dealer_id = $1)`,
        [id]
      );
      await client.query(`DELETE FROM orders WHERE dealer_id = $1`, [id]);
      await client.query(`DELETE FROM users WHERE id = $1`, [id]);
      await client.query('COMMIT');
    } catch (err) {
      await client.query('ROLLBACK');
      throw err;
    } finally {
      client.release();
    }
    return res.json({ ok: true });
  }

  // role === 'distributor' — distributor_id가 NULL이면 회사 자체(루트/관리자) 계정, 아니면 소속 직원
  const isRootAccount = targetUser.distributor_id === null;
  if (isRootAccount) {
    const dealerRows = await getActiveDependentDealers(pool, targetUser.id);
    if (dealerRows.length > 0) {
      return res.status(409).json({ needsReassignment: true, dealers: dealerRows });
    }
    await anonymizeDistributorStaff(pool, targetUser.id);

    // 총판이 대리점 대신 직접 발주한 이력(POST /orders/self, dealer_id = 총판 자신의 id)은
    // 총판 본인 소유 데이터이므로 함께 삭제한다. 대리점이 넣고 총판이 전환(convert)만 해준 발주는
    // dealer_id가 실제 대리점 id라 이 조건에 걸리지 않아 그대로 보존된다.
    const client = await pool.connect();
    try {
      await client.query('BEGIN');
      const id = targetUser.id;
      await client.query(`DELETE FROM sales WHERE dealer_id = $1`, [id]);
      await client.query(
        `DELETE FROM shipment_items WHERE shipment_id IN (SELECT id FROM shipments WHERE dealer_id = $1)`,
        [id]
      );
      await client.query(`DELETE FROM shipments WHERE dealer_id = $1`, [id]);
      await client.query(
        `DELETE FROM order_items WHERE order_id IN (SELECT id FROM orders WHERE dealer_id = $1)`,
        [id]
      );
      await client.query(`DELETE FROM orders WHERE dealer_id = $1`, [id]);
      await client.query(`DELETE FROM distributor_inventory WHERE distributor_id = $1`, [id]);
      await client.query(`DELETE FROM distributor_product_prices WHERE distributor_id = $1`, [id]);
      await client.query(`UPDATE product_batches SET scanned_by = NULL WHERE scanned_by = $1`, [id]);
      await client.query('COMMIT');
    } catch (err) {
      await client.query('ROLLBACK');
      throw err;
    } finally {
      client.release();
    }
  }

  const user = await anonymizeUser(pool, targetUser.id);
  res.json({ user: publicUser(user) });
});

module.exports = router;
