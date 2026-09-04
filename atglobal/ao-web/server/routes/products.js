'use strict';

const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');
const roleCheck = require('../middleware/roleCheck');

const router = express.Router();
router.use(requireAuth);

router.get('/', async (req, res) => {
  if (req.session.user.role === 'dealer') {
    // dealer는 제조사 원가(base_price) 대신 소속 총판이 설정한 판매가를 base_price로 전달받는다.
    // 판매가를 아직 설정하지 않은 제품은 발주 대상에서 제외한다.
    const { rows } = await pool.query(
      `SELECT p.id, p.name, p.model_name, p.spec, p.barcode_prefix, p.is_active, dpp.price AS base_price
       FROM products p
       JOIN distributor_product_prices dpp
         ON dpp.product_id = p.id AND dpp.distributor_id = $1
       WHERE p.is_active = true
       ORDER BY p.id`,
      [req.session.user.distributor_id]
    );
    return res.json({ products: rows });
  }
  const { rows } = await pool.query('SELECT * FROM products WHERE is_active = true ORDER BY id');
  res.json({ products: rows });
});

router.post('/', roleCheck('admin'), async (req, res) => {
  const { name, model_name, spec, base_price } = req.body;
  const { rows } = await pool.query(
    `INSERT INTO products (name, model_name, spec, base_price)
     VALUES ($1, $2, $3, $4)
     RETURNING *`,
    [name, model_name, spec, base_price || 0]
  );
  await pool.query('INSERT INTO inventory (product_id) VALUES ($1) ON CONFLICT DO NOTHING', [rows[0].id]);
  res.status(201).json({ product: rows[0] });
});

router.patch('/:id', roleCheck('admin'), async (req, res) => {
  const { name, model_name, spec, base_price, is_active } = req.body;
  const { rows } = await pool.query(
    `UPDATE products
     SET name = COALESCE($2, name),
         model_name = COALESCE($3, model_name),
         spec = COALESCE($4, spec),
         base_price = COALESCE($5, base_price),
         is_active = COALESCE($6, is_active)
     WHERE id = $1 RETURNING *`,
    [req.params.id, name, model_name, spec, base_price, is_active]
  );
  if (!rows[0]) return res.status(404).json({ message: '제품을 찾을 수 없습니다.' });
  res.json({ product: rows[0] });
});

router.delete('/:id', roleCheck('admin'), async (req, res) => {
  await pool.query('UPDATE products SET is_active = false WHERE id = $1', [req.params.id]);
  res.json({ ok: true });
});

module.exports = router;
