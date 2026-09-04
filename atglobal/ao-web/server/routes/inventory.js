'use strict';

const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');
const roleCheck = require('../middleware/roleCheck');

const router = express.Router();
router.use(requireAuth);

router.get('/', roleCheck('admin'), async (_req, res) => {
  const { rows } = await pool.query(
    `SELECT i.*, p.name, p.model_name, p.spec, p.base_price
     FROM inventory i JOIN products p ON p.id = i.product_id
     ORDER BY p.id`
  );
  res.json({ inventory: rows });
});

router.post('/', roleCheck('admin'), async (req, res) => {
  const { rows } = await pool.query(
    `INSERT INTO inventory (product_id, quantity, min_quantity, note)
     VALUES ($1, $2, $3, $4)
     ON CONFLICT (product_id) DO UPDATE
     SET quantity = EXCLUDED.quantity, min_quantity = EXCLUDED.min_quantity, note = EXCLUDED.note, updated_at = NOW()
     RETURNING *`,
    [req.body.product_id, req.body.quantity || 0, req.body.min_quantity || 0, req.body.note || null]
  );
  res.status(201).json({ item: rows[0] });
});

router.patch('/:id', roleCheck('admin'), async (req, res) => {
  const { quantity, min_quantity, note } = req.body;
  const { rows } = await pool.query(
    `UPDATE inventory
     SET quantity = COALESCE($2, quantity),
         min_quantity = COALESCE($3, min_quantity),
         note = COALESCE($4, note),
         updated_at = NOW()
     WHERE id = $1 RETURNING *`,
    [req.params.id, quantity, min_quantity, note]
  );
  res.json({ item: rows[0] });
});

// 입고 등록 일괄 저장: 여러 품목의 추가재고를 한 번에 현재재고에 더함
router.post('/receive-batch', roleCheck('admin'), async (req, res) => {
  const items = (Array.isArray(req.body.items) ? req.body.items : [])
    .map((i) => ({ product_id: Number(i.product_id), quantity: Number(i.quantity) }))
    .filter((i) => Number.isInteger(i.product_id) && Number.isInteger(i.quantity) && i.quantity > 0);
  if (!items.length) return res.status(400).json({ message: '추가할 재고 수량을 입력해주세요.' });

  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    for (const item of items) {
      await client.query(
        `INSERT INTO inventory (product_id, quantity, min_quantity)
         VALUES ($1, $2, 0)
         ON CONFLICT (product_id) DO UPDATE SET quantity = inventory.quantity + $2, updated_at = NOW()`,
        [item.product_id, item.quantity]
      );
    }
    await client.query('COMMIT');
    res.json({ ok: true });
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
});

// 총판은 자체 재고를 갖지 않고 제조사(본사) 재고를 그대로 조회만 함 — 관리자용 조회와 동일한 데이터
router.get('/distributor', roleCheck('distributor'), async (_req, res) => {
  const { rows } = await pool.query(
    `SELECT i.*, p.name, p.model_name, p.spec, p.base_price
     FROM inventory i JOIN products p ON p.id = i.product_id
     ORDER BY p.id`
  );
  res.json({ inventory: rows });
});

module.exports = router;
