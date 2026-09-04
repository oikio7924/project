'use strict';

const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');
const roleCheck = require('../middleware/roleCheck');
const { companyId } = require('../utils');

const router = express.Router();
router.use(requireAuth);

const SALES_STATUSES = "('CONFIRMED', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED')";

async function kpis(where = '', params = []) {
  const { rows } = await pool.query(
    `SELECT
       COUNT(*) FILTER (WHERE status <> 'CANCELLED' AND date_trunc('month', ordered_at) = date_trunc('month', NOW()))::int AS monthly_orders,
       COALESCE(SUM(total_amount) FILTER (WHERE status IN ${SALES_STATUSES} AND date_trunc('month', ordered_at) = date_trunc('month', NOW())), 0) AS monthly_sales,
       COUNT(*) FILTER (WHERE status = 'SHIPPED' AND date_trunc('month', shipped_at) = date_trunc('month', NOW()))::int AS monthly_shipments
     FROM orders ${where}`,
    params
  );
  return rows[0];
}

router.get('/admin', roleCheck('admin'), async (req, res) => {
  const period = req.query.period || 'monthly';
  const dateStr = req.query.date || null;

  let periodFilter;
  let periodParam;
  if (period === 'all') {
    periodParam = null;
    periodFilter = 'true';
  } else if (period === 'daily') {
    periodParam = dateStr || new Date().toISOString().slice(0, 10);
    periodFilter = `date_trunc('day', o.ordered_at) = $1::date`;
  } else if (period === 'yearly') {
    periodParam = dateStr ? `${dateStr}-01-01` : `${new Date().getFullYear()}-01-01`;
    periodFilter = `date_trunc('year', o.ordered_at) = date_trunc('year', $1::date)`;
  } else {
    periodParam = dateStr ? `${dateStr}-01` : new Date().toISOString().slice(0, 7) + '-01';
    periodFilter = `date_trunc('month', o.ordered_at) = date_trunc('month', $1::date)`;
  }

  const periodQueryParams = period === 'all' ? [] : [periodParam];

  const summary = await kpis();
  const inventory = await pool.query('SELECT COALESCE(SUM(quantity), 0)::int AS current_inventory FROM inventory');
  const lineup = await pool.query(
    `SELECT p.id, p.name, p.model_name,
            COALESCE(SUM(oi.quantity) FILTER (WHERE o.status IN ${SALES_STATUSES} AND ${periodFilter}), 0)::int AS monthly_order_qty,
            COALESCE(i.quantity, 0)::int AS inventory_qty,
            COALESCE(SUM(oi.amount) FILTER (WHERE o.status IN ${SALES_STATUSES} AND ${periodFilter}), 0) AS sales_amount
     FROM products p
     LEFT JOIN inventory i ON i.product_id = p.id
     LEFT JOIN order_items oi ON oi.product_id = p.id
     LEFT JOIN orders o ON o.id = oi.order_id
     WHERE p.is_active = true
     GROUP BY p.id, i.quantity
     ORDER BY p.id`,
    periodQueryParams
  );
  const dealers = await pool.query(
    `SELECT dealer.company_name AS dealer_company,
            distributor.company_name AS distributor_company,
            MAX(o.ordered_at) AS last_ordered_at,
            COUNT(o.id) FILTER (WHERE o.status <> 'CANCELLED' AND ${periodFilter})::int AS order_count,
            COALESCE(SUM(o.total_amount) FILTER (WHERE o.status <> 'CANCELLED' AND ${periodFilter}), 0) AS total_amount
     FROM users dealer
     LEFT JOIN users distributor ON distributor.id = dealer.distributor_id
     LEFT JOIN orders o ON o.dealer_id = dealer.id
     WHERE dealer.role = 'dealer'
     GROUP BY dealer.id, dealer.company_name, distributor.company_name
     HAVING COUNT(o.id) FILTER (WHERE o.status <> 'CANCELLED' AND ${periodFilter}) > 0
     ORDER BY dealer.company_name`,
    periodQueryParams
  );
  res.json({
    summary: { ...summary, current_inventory: inventory.rows[0].current_inventory },
    lineup: lineup.rows,
    dealers: dealers.rows
  });
});

router.get('/distributor', roleCheck('distributor'), async (req, res) => {
  const distId = companyId(req.session.user);
  const period  = req.query.period || 'monthly';
  const dateStr = req.query.date   || null;

  let periodFilter, periodParam;
  if (period === 'all') {
    periodParam  = null;
    periodFilter = 'true';
  } else if (period === 'daily') {
    periodParam  = dateStr || new Date().toISOString().slice(0, 10);
    periodFilter = `date_trunc('day', o.ordered_at) = $2::date`;
  } else if (period === 'yearly') {
    periodParam  = dateStr ? `${dateStr}-01-01` : `${new Date().getFullYear()}-01-01`;
    periodFilter = `date_trunc('year', o.ordered_at) = date_trunc('year', $2::date)`;
  } else {
    periodParam  = dateStr ? `${dateStr}-01` : new Date().toISOString().slice(0, 7) + '-01';
    periodFilter = `date_trunc('month', o.ordered_at) = date_trunc('month', $2::date)`;
  }

  const summary = await kpis('WHERE distributor_id = $1', [distId]);
  // 총판은 자체 재고를 갖지 않고 제조사 재고를 그대로 조회하므로 관리자와 동일한 재고 합계를 사용
  const inventory = await pool.query(
    'SELECT COALESCE(SUM(quantity), 0)::int AS current_inventory FROM inventory'
  );
  const dealerParams = period === 'all' ? [distId] : [distId, periodParam];
  const dealers = await pool.query(
    `SELECT dealer.company_name AS dealer_company,
            MAX(o.ordered_at) AS last_ordered_at,
            COUNT(o.id) FILTER (WHERE o.status <> 'CANCELLED' AND ${periodFilter}) ::int AS order_count,
            COALESCE(SUM(o.total_amount) FILTER (WHERE o.status <> 'CANCELLED' AND ${periodFilter}), 0) AS total_amount
     FROM users dealer
     LEFT JOIN orders o ON o.dealer_id = dealer.id AND o.distributor_id = $1
     WHERE dealer.role = 'dealer' AND dealer.distributor_id = $1
     GROUP BY dealer.id, dealer.company_name
     HAVING COUNT(o.id) FILTER (WHERE o.status <> 'CANCELLED' AND ${periodFilter}) > 0
     ORDER BY dealer.company_name`,
    dealerParams
  );
  res.json({
    summary: { ...summary, current_inventory: inventory.rows[0].current_inventory },
    dealers: dealers.rows
  });
});

module.exports = router;
