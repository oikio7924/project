'use strict';

const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');
const roleCheck = require('../middleware/roleCheck');
const { publicUser } = require('../utils');

const router = express.Router();
router.use(requireAuth, roleCheck('admin'));

router.get('/pending', async (_req, res) => {
  const { rows } = await pool.query(
    `SELECT id, username, name, phone, company_name, role, status, created_at
     FROM users WHERE status = 'pending' ORDER BY created_at DESC`
  );
  res.json({ users: rows });
});

router.get('/distributors', async (_req, res) => {
  const { rows } = await pool.query(
    `SELECT id, username, name, company_name FROM users
     WHERE role = 'distributor' AND status = 'active'
     ORDER BY company_name, name`
  );
  res.json({ users: rows });
});

router.get('/', async (_req, res) => {
  const { rows } = await pool.query(
    `SELECT u.id, u.username, u.name, u.phone, u.company_name, u.role, u.status,
            u.distributor_id, d.company_name AS distributor_name, u.created_at
     FROM users u
     LEFT JOIN users d ON d.id = u.distributor_id
     ORDER BY u.created_at DESC`
  );
  res.json({ users: rows });
});

router.post('/:id/approve', async (req, res) => {
  const { distributor_id } = req.body;
  const target = await pool.query('SELECT * FROM users WHERE id = $1', [req.params.id]);
  if (!target.rows[0]) return res.status(404).json({ message: '회원을 찾을 수 없습니다.' });
  if (target.rows[0].role === 'dealer' && !distributor_id) {
    return res.status(400).json({ message: '대리점은 소속 총판 지정이 필요합니다.' });
  }
  const { rows } = await pool.query(
    `UPDATE users SET status = 'active', distributor_id = $2, updated_at = NOW()
     WHERE id = $1 RETURNING *`,
    [req.params.id, target.rows[0].role === 'dealer' ? distributor_id : null]
  );
  res.json({ user: publicUser(rows[0]) });
});

router.post('/:id/reject', async (req, res) => {
  const { rows } = await pool.query(
    `UPDATE users SET status = 'rejected', updated_at = NOW() WHERE id = $1 RETURNING *`,
    [req.params.id]
  );
  if (!rows[0]) return res.status(404).json({ message: '회원을 찾을 수 없습니다.' });
  res.json({ user: publicUser(rows[0]) });
});

router.patch('/:id/distributor', async (req, res) => {
  const { rows } = await pool.query(
    `UPDATE users SET distributor_id = $2, updated_at = NOW()
     WHERE id = $1 AND role = 'dealer' RETURNING *`,
    [req.params.id, req.body.distributor_id]
  );
  if (!rows[0]) return res.status(404).json({ message: '대리점 회원을 찾을 수 없습니다.' });
  res.json({ user: publicUser(rows[0]) });
});

router.patch('/:id', async (req, res) => {
  const target = await pool.query('SELECT role FROM users WHERE id = $1', [req.params.id]);
  if (!target.rows[0]) return res.status(404).json({ message: '회원을 찾을 수 없습니다.' });

  const { name, phone, company_name, address, status, password, role, distributor_id } = req.body;

  if (target.rows[0].role === 'admin') {
    const { rows } = await pool.query(
      `UPDATE users
       SET name     = COALESCE($2, name),
           phone    = COALESCE($3, phone),
           address  = COALESCE($4, address),
           password = CASE WHEN $5::text IS NOT NULL THEN $5 ELSE password END,
           updated_at = NOW()
       WHERE id = $1 RETURNING *`,
      [req.params.id, name, phone, address, password || null]
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
         updated_at     = NOW()
     WHERE id = $1 RETURNING *`,
    [req.params.id, name, phone, company_name, address, status, password || null, role, distributor_id || null]
  );
  res.json({ user: publicUser(rows[0]) });
});

router.delete('/:id', async (req, res) => {
  const target = await pool.query('SELECT role FROM users WHERE id = $1', [req.params.id]);
  if (!target.rows[0]) return res.status(404).json({ message: '회원을 찾을 수 없습니다.' });
  if (target.rows[0].role === 'admin') return res.status(403).json({ message: '관리자 계정은 삭제할 수 없습니다.' });

  try {
    await pool.query('DELETE FROM users WHERE id = $1', [req.params.id]);
    res.json({ ok: true });
  } catch (err) {
    if (err.code === '23503') {
      await pool.query(`UPDATE users SET status = 'inactive', updated_at = NOW() WHERE id = $1`, [req.params.id]);
      res.json({ ok: true, softDeleted: true, message: '발주 이력이 있어 계정을 비활성화 처리했습니다.' });
    } else {
      throw err;
    }
  }
});

module.exports = router;
