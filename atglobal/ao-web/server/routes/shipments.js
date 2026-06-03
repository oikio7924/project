'use strict';

const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');
const roleCheck = require('../middleware/roleCheck');

const router = express.Router();
router.use(requireAuth);

async function nextShipmentNumber() {
  const date = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  const { rows } = await pool.query(
    `SELECT COUNT(*)::int AS count FROM shipments WHERE shipment_number LIKE $1`,
    [`SHP-${date}-%`]
  );
  return `SHP-${date}-${String(rows[0].count + 1).padStart(3, '0')}`;
}

router.post('/', roleCheck('admin'), async (req, res) => {
  const orderResult = await pool.query('SELECT * FROM orders WHERE id = $1', [req.body.order_id]);
  const order = orderResult.rows[0];
  if (!order) return res.status(404).json({ message: '발주서를 찾을 수 없습니다.' });

  const { rows } = await pool.query(
    `INSERT INTO shipments (shipment_number, order_id, dealer_id, distributor_id, delivery_address, tracking_number, note)
     VALUES ($1, $2, $3, $4, $5, $6, $7)
     RETURNING *`,
    [
      await nextShipmentNumber(),
      order.id,
      order.dealer_id,
      order.distributor_id,
      req.body.delivery_address || order.delivery_address,
      req.body.tracking_number || null,
      req.body.note || null
    ]
  );
  await pool.query(
    `UPDATE orders SET status = 'SHIPPED', shipped_at = NOW(), updated_at = NOW() WHERE id = $1`,
    [order.id]
  );
  res.status(201).json({ shipment: rows[0] });
});

router.get('/', roleCheck('admin', 'distributor'), async (req, res) => {
  const params = [];
  let where = '';
  if (req.session.user.role === 'distributor') {
    params.push(req.session.user.id);
    where = 'WHERE s.distributor_id = $1';
  }
  const { rows } = await pool.query(
    `SELECT s.*, o.order_number, dealer.company_name AS dealer_company, distributor.company_name AS distributor_company
     FROM shipments s
     JOIN orders o ON o.id = s.order_id
     JOIN users dealer ON dealer.id = s.dealer_id
     JOIN users distributor ON distributor.id = s.distributor_id
     ${where}
     ORDER BY s.shipped_at DESC`,
    params
  );
  res.json({ shipments: rows });
});

router.patch('/:id', roleCheck('admin'), async (req, res) => {
  const { rows } = await pool.query(
    `UPDATE shipments
     SET tracking_number = COALESCE($2, tracking_number),
         note = COALESCE($3, note)
     WHERE id = $1 RETURNING *`,
    [req.params.id, req.body.tracking_number, req.body.note]
  );
  res.json({ shipment: rows[0] });
});

module.exports = router;
