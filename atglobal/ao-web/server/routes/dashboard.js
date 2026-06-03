'use strict';

const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');
const roleCheck = require('../middleware/roleCheck');

const router = express.Router();
router.use(requireAuth);

async function kpis(where = '', params = []) {
  const { rows } = await pool.query(
    `SELECT
       COUNT(*) FILTER (WHERE date_trunc('month', ordered_at) = date_trunc('month', NOW()))::int AS monthly_orders,
       COALESCE(SUM(total_amount) FILTER (WHERE date_trunc('month', ordered_at) = date_trunc('month', NOW())), 0) AS monthly_sales,
       COUNT(*) FILTER (WHERE status = 'SHIPPED' AND date_trunc('month', shipped_at) = date_trunc('month', NOW()))::int AS monthly_shipments
     FROM orders ${where}`,
    params
  );
  return rows[0];
}

router.get('/admin', roleCheck('admin'), async (_req, res) => {
  const summary = await kpis();
  const inventory = await pool.query('SELECT COALESCE(SUM(quantity), 0)::int AS current_inventory FROM inventory');
  const lineup = await pool.query(
    `SELECT p.id, p.name, p.model_name,
            COALESCE(SUM(oi.quantity) FILTER (WHERE date_trunc('month', o.ordered_at) = date_trunc('month', NOW())), 0)::int AS monthly_order_qty,
            COALESCE(i.quantity, 0)::int AS inventory_qty,
            COALESCE(SUM(oi.quantity) FILTER (WHERE o.status = 'SHIPPED'), 0)::int AS shipped_qty,
            COALESCE(SUM(oi.amount), 0) AS sales_amount
     FROM products p
     LEFT JOIN inventory i ON i.product_id = p.id
     LEFT JOIN order_items oi ON oi.product_id = p.id
     LEFT JOIN orders o ON o.id = oi.order_id
     WHERE p.is_active = true
     GROUP BY p.id, i.quantity
     ORDER BY p.id`
  );
  const dealers = await pool.query(
    `SELECT dealer.company_name AS dealer_company,
            distributor.company_name AS distributor_company,
            MAX(o.ordered_at) AS last_ordered_at,
            COUNT(o.id)::int AS order_count,
            COALESCE(SUM(o.total_amount), 0) AS total_amount
     FROM users dealer
     LEFT JOIN users distributor ON distributor.id = dealer.distributor_id
     LEFT JOIN orders o ON o.dealer_id = dealer.id
     WHERE dealer.role = 'dealer'
     GROUP BY dealer.id, dealer.company_name, distributor.company_name
     ORDER BY dealer.company_name`
  );
  res.json({
    summary: { ...summary, current_inventory: inventory.rows[0].current_inventory },
    lineup: lineup.rows,
    dealers: dealers.rows
  });
});

router.get('/distributor', roleCheck('distributor'), async (req, res) => {
  const summary = await kpis('WHERE distributor_id = $1', [req.session.user.id]);
  const inventory = await pool.query(
    'SELECT COALESCE(SUM(quantity), 0)::int AS current_inventory FROM distributor_inventory WHERE distributor_id = $1',
    [req.session.user.id]
  );
  const dealers = await pool.query(
    `SELECT dealer.company_name AS dealer_company,
            MAX(o.ordered_at) AS last_ordered_at,
            COUNT(o.id)::int AS order_count,
            COALESCE(SUM(o.total_amount), 0) AS total_amount
     FROM users dealer
     LEFT JOIN orders o ON o.dealer_id = dealer.id
     WHERE dealer.role = 'dealer' AND dealer.distributor_id = $1
     GROUP BY dealer.id, dealer.company_name
     ORDER BY dealer.company_name`,
    [req.session.user.id]
  );
  res.json({
    summary: { ...summary, current_inventory: inventory.rows[0].current_inventory },
    dealers: dealers.rows
  });
});

module.exports = router;
