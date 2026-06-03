'use strict';

const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');
const roleCheck = require('../middleware/roleCheck');

const router = express.Router();
router.use(requireAuth, roleCheck('admin', 'distributor'));

router.get('/', async (req, res) => {
  const params = [];
  const clauses = ["o.status IN ('CONVERTED', 'CONFIRMED', 'SHIPPED')"];
  if (req.session.user.role === 'distributor') {
    params.push(req.session.user.id);
    clauses.push(`o.distributor_id = $${params.length}`);
  }
  if (req.query.product_id) {
    params.push(req.query.product_id);
    clauses.push(`p.id = $${params.length}`);
  }
  if (req.query.dealer_id) {
    params.push(req.query.dealer_id);
    clauses.push(`o.dealer_id = $${params.length}`);
  }

  const { rows } = await pool.query(
    `SELECT o.ordered_at::date AS date,
            dealer.company_name AS dealer_company,
            distributor.company_name AS distributor_company,
            p.name AS product_name,
            p.model_name,
            oi.quantity,
            oi.unit_price,
            oi.amount
     FROM order_items oi
     JOIN orders o ON o.id = oi.order_id
     JOIN products p ON p.id = oi.product_id
     JOIN users dealer ON dealer.id = o.dealer_id
     JOIN users distributor ON distributor.id = o.distributor_id
     WHERE ${clauses.join(' AND ')}
     ORDER BY o.ordered_at DESC`,
    params
  );

  const monthly = await pool.query(
    `SELECT to_char(date_trunc('month', o.ordered_at), 'YYYY-MM') AS month,
            COALESCE(SUM(oi.amount), 0) AS amount,
            COALESCE(SUM(oi.quantity), 0)::int AS quantity
     FROM order_items oi
     JOIN orders o ON o.id = oi.order_id
     JOIN products p ON p.id = oi.product_id
     WHERE ${clauses.join(' AND ')}
     GROUP BY date_trunc('month', o.ordered_at)
     ORDER BY month`,
    params
  );

  res.json({ sales: rows, monthly: monthly.rows });
});

module.exports = router;
