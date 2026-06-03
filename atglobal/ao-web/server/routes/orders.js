'use strict';

const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');
const roleCheck = require('../middleware/roleCheck');
const { toNumber } = require('../utils');

const router = express.Router();
router.use(requireAuth);

async function nextOrderNumber(client) {
  const date = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  const { rows } = await client.query(
    `SELECT COUNT(*)::int AS count FROM orders WHERE order_number LIKE $1`,
    [`ORD-${date}-%`]
  );
  return `ORD-${date}-${String(rows[0].count + 1).padStart(3, '0')}`;
}

async function listOrders(whereSql, params) {
  const { rows } = await pool.query(
    `SELECT o.*,
            dealer.name AS dealer_name,
            dealer.company_name AS dealer_company,
            distributor.name AS distributor_name,
            distributor.company_name AS distributor_company,
            COALESCE(json_agg(json_build_object(
              'id', oi.id,
              'product_id', oi.product_id,
              'product_name', p.name,
              'model_name', p.model_name,
              'quantity', oi.quantity,
              'unit_price', oi.unit_price,
              'amount', oi.amount
            ) ORDER BY oi.id) FILTER (WHERE oi.id IS NOT NULL), '[]') AS items
     FROM orders o
     JOIN users dealer ON dealer.id = o.dealer_id
     JOIN users distributor ON distributor.id = o.distributor_id
     LEFT JOIN order_items oi ON oi.order_id = o.id
     LEFT JOIN products p ON p.id = oi.product_id
     ${whereSql}
     GROUP BY o.id, dealer.name, dealer.company_name, distributor.name, distributor.company_name
     ORDER BY o.created_at DESC`,
    params
  );
  return rows;
}

router.post('/', roleCheck('dealer'), async (req, res) => {
  const client = await pool.connect();
  try {
    const items = Array.isArray(req.body.items) ? req.body.items : [];
    if (!items.length) return res.status(400).json({ message: '발주 품목을 1개 이상 입력해주세요.' });
    if (!req.session.user.distributor_id) return res.status(400).json({ message: '소속 총판이 지정되지 않았습니다.' });

    await client.query('BEGIN');
    const orderNumber = await nextOrderNumber(client);
    const total = items.reduce((sum, item) => sum + toNumber(item.quantity) * toNumber(item.unit_price), 0);
    const order = await client.query(
      `INSERT INTO orders (order_number, dealer_id, distributor_id, delivery_address, note, total_amount)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING *`,
      [orderNumber, req.session.user.id, req.session.user.distributor_id, req.body.delivery_address, req.body.note, total]
    );

    for (const item of items) {
      await client.query(
        `INSERT INTO order_items (order_id, product_id, quantity, unit_price)
         VALUES ($1, $2, $3, $4)`,
        [order.rows[0].id, item.product_id, toNumber(item.quantity), toNumber(item.unit_price)]
      );
    }
    await client.query('COMMIT');
    res.status(201).json({ order: order.rows[0] });
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
});

router.get('/dealer', roleCheck('dealer'), async (req, res) => {
  res.json({ orders: await listOrders('WHERE o.dealer_id = $1', [req.session.user.id]) });
});

router.get('/distributor', roleCheck('distributor'), async (req, res) => {
  res.json({ orders: await listOrders('WHERE o.distributor_id = $1', [req.session.user.id]) });
});

router.get('/admin', roleCheck('admin'), async (req, res) => {
  const clauses = [];
  const params = [];
  for (const [field, column] of [['status', 'o.status'], ['distributor_id', 'o.distributor_id'], ['dealer_id', 'o.dealer_id']]) {
    if (req.query[field]) {
      params.push(req.query[field]);
      clauses.push(`${column} = $${params.length}`);
    }
  }
  const where = clauses.length ? `WHERE ${clauses.join(' AND ')}` : '';
  res.json({ orders: await listOrders(where, params) });
});

router.patch('/:id', roleCheck('distributor'), async (req, res) => {
  const client = await pool.connect();
  try {
    const items = Array.isArray(req.body.items) ? req.body.items : [];
    await client.query('BEGIN');
    const order = await client.query(
      `UPDATE orders
       SET delivery_address = COALESCE($3, delivery_address),
           note = COALESCE($4, note),
           status = CASE WHEN status = 'PENDING' THEN 'RECEIVED' ELSE status END,
           received_at = COALESCE(received_at, NOW()),
           updated_at = NOW()
       WHERE id = $1 AND distributor_id = $2 AND status IN ('PENDING', 'RECEIVED')
       RETURNING *`,
      [req.params.id, req.session.user.id, req.body.delivery_address, req.body.note]
    );
    if (!order.rows[0]) {
      await client.query('ROLLBACK');
      return res.status(404).json({ message: '수정 가능한 발주서를 찾을 수 없습니다.' });
    }

    if (items.length) {
      await client.query('DELETE FROM order_items WHERE order_id = $1', [req.params.id]);
      let total = 0;
      for (const item of items) {
        total += toNumber(item.quantity) * toNumber(item.unit_price);
        await client.query(
          `INSERT INTO order_items (order_id, product_id, quantity, unit_price)
           VALUES ($1, $2, $3, $4)`,
          [req.params.id, item.product_id, toNumber(item.quantity), toNumber(item.unit_price)]
        );
      }
      await client.query('UPDATE orders SET total_amount = $2 WHERE id = $1', [req.params.id, total]);
    }

    await client.query('COMMIT');
    res.json({ ok: true });
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
});

router.post('/:id/convert', roleCheck('distributor'), async (req, res) => {
  const { rows } = await pool.query(
    `UPDATE orders
     SET status = 'CONVERTED',
         received_at = COALESCE(received_at, NOW()),
         converted_at = NOW(),
         updated_at = NOW()
     WHERE id = $1 AND distributor_id = $2 AND status IN ('PENDING', 'RECEIVED')
     RETURNING *`,
    [req.params.id, req.session.user.id]
  );
  if (!rows[0]) return res.status(404).json({ message: '전환 가능한 발주서를 찾을 수 없습니다.' });
  res.json({ order: rows[0] });
});

router.patch('/:id/status', roleCheck('admin'), async (req, res) => {
  const status = req.body.status;
  const timestamps = {
    CONFIRMED: 'confirmed_at = NOW(),',
    SHIPPED: 'shipped_at = NOW(),',
    CANCELLED: ''
  };
  if (!['CONFIRMED', 'SHIPPED', 'CANCELLED'].includes(status)) {
    return res.status(400).json({ message: '허용되지 않은 상태입니다.' });
  }
  const { rows } = await pool.query(
    `UPDATE orders
     SET status = $2,
         ${timestamps[status]}
         updated_at = NOW()
     WHERE id = $1
     RETURNING *`,
    [req.params.id, status]
  );
  res.json({ order: rows[0] });
});

module.exports = router;
