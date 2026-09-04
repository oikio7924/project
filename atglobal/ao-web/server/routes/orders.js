'use strict';

const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');
const roleCheck = require('../middleware/roleCheck');
const { toNumber, companyId } = require('../utils');

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
            CASE WHEN dealer.status = 'deleted' THEN '삭제된 회원입니다' ELSE dealer.name END AS dealer_name,
            dealer.company_name    AS dealer_company,
            dealer.phone           AS dealer_phone,
            (dealer.address || COALESCE(' ' || NULLIF(dealer.address_detail, ''), '')) AS dealer_address,
            CASE WHEN distributor.status = 'deleted' THEN '삭제된 회원입니다' ELSE distributor.name END AS distributor_name,
            distributor.company_name    AS distributor_company,
            distributor.phone           AS distributor_phone,
            (distributor.address || COALESCE(' ' || NULLIF(distributor.address_detail, ''), '')) AS distributor_address,
            distributor.manager_name    AS distributor_manager_name,
            distributor.manager_phone   AS distributor_manager_phone,
            distributor.business_number AS distributor_business_number,
            distributor.ceo_name        AS distributor_ceo_name,
            distributor.fax             AS distributor_fax,
            mfr.company_name    AS manufacturer_company_name,
            mfr.business_number AS manufacturer_business_number,
            mfr.ceo_name        AS manufacturer_ceo_name,
            (mfr.address || COALESCE(' ' || NULLIF(mfr.address_detail, ''), '')) AS manufacturer_address,
            mfr.company_phone   AS manufacturer_phone,
            mfr.fax             AS manufacturer_fax,
            shp.received_at,
            CASE WHEN receiver.status = 'deleted' THEN '삭제된 회원입니다' ELSE receiver.name END AS received_by_name,
            receiver.role          AS received_by_role,
            receiver.company_name  AS received_by_company,
            COALESCE(json_agg(json_build_object(
              'id', oi.id,
              'product_id', oi.product_id,
              'product_name', p.name,
              'model_name', p.model_name,
              'quantity', oi.quantity,
              'unit_price', oi.unit_price,
              'manufacturer_unit_price', oi.manufacturer_unit_price,
              'amount', oi.amount,
              'shipped_quantity', COALESCE((
                SELECT SUM(si.quantity) FROM shipment_items si WHERE si.order_item_id = oi.id
              ), 0)
            ) ORDER BY oi.id) FILTER (WHERE oi.id IS NOT NULL), '[]') AS items
     FROM orders o
     JOIN users dealer ON dealer.id = o.dealer_id
     JOIN users distributor ON distributor.id = o.distributor_id
     LEFT JOIN order_items oi ON oi.order_id = o.id
     LEFT JOIN products p ON p.id = oi.product_id
     LEFT JOIN LATERAL (
       SELECT received_at, received_by FROM shipments
       WHERE order_id = o.id
       ORDER BY received_at DESC NULLS LAST, shipped_at DESC
       LIMIT 1
     ) shp ON true
     LEFT JOIN users receiver ON receiver.id = shp.received_by
     LEFT JOIN LATERAL (
       SELECT company_name, business_number, ceo_name, address, address_detail, company_phone, fax
       FROM users WHERE role = 'admin'
       ORDER BY id LIMIT 1
     ) mfr ON true
     ${whereSql}
     GROUP BY o.id,
              dealer.name, dealer.company_name, dealer.phone, dealer.address, dealer.address_detail, dealer.status,
              distributor.name, distributor.company_name, distributor.phone,
              distributor.address, distributor.address_detail, distributor.manager_name, distributor.manager_phone, distributor.status,
              distributor.business_number, distributor.ceo_name, distributor.fax,
              mfr.company_name, mfr.business_number, mfr.ceo_name, mfr.address, mfr.address_detail, mfr.company_phone, mfr.fax,
              shp.received_at, receiver.name, receiver.role, receiver.company_name, receiver.status
     ORDER BY o.ordered_at DESC`,
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
    const productIds = [...new Set(items.map((item) => Number(item.product_id)).filter(Number.isInteger))];
    const products = await client.query(
      `SELECT p.id, dpp.price
       FROM products p
       JOIN distributor_product_prices dpp
         ON dpp.product_id = p.id AND dpp.distributor_id = $2
       WHERE p.id = ANY($1::int[]) AND p.is_active = true`,
      [productIds, req.session.user.distributor_id]
    );
    const productPrices = new Map(products.rows.map((product) => [product.id, toNumber(product.price)]));
    if (productPrices.size !== productIds.length || productIds.length !== items.length) {
      await client.query('ROLLBACK');
      return res.status(400).json({ message: '발주 품목에 유효하지 않거나, 총판이 판매가를 설정하지 않은 제품이 있습니다.' });
    }

    const pricedItems = items.map((item) => ({
      product_id: Number(item.product_id),
      quantity: toNumber(item.quantity),
      unit_price: productPrices.get(Number(item.product_id))
    }));
    if (pricedItems.some((item) => !Number.isInteger(item.quantity) || item.quantity < 1)) {
      await client.query('ROLLBACK');
      return res.status(400).json({ message: '발주 수량은 1개 이상의 정수여야 합니다.' });
    }

    const orderNumber = await nextOrderNumber(client);
    const total = pricedItems.reduce((sum, item) => sum + item.quantity * item.unit_price, 0);
    const order = await client.query(
      `INSERT INTO orders (order_number, dealer_id, distributor_id, delivery_address, payment_terms, note, total_amount)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [orderNumber, req.session.user.id, req.session.user.distributor_id, req.body.delivery_address, req.body.payment_terms, req.body.note, total]
    );

    for (const item of pricedItems) {
      await client.query(
        `INSERT INTO order_items (order_id, product_id, quantity, unit_price)
         VALUES ($1, $2, $3, $4)`,
        [order.rows[0].id, item.product_id, item.quantity, item.unit_price]
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
  res.json({ orders: await listOrders('WHERE o.distributor_id = $1', [companyId(req.session.user)]) });
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

router.post('/self', roleCheck('distributor'), async (req, res) => {
  const client = await pool.connect();
  try {
    const items = Array.isArray(req.body.items) ? req.body.items : [];
    if (!items.length) return res.status(400).json({ message: '발주 품목을 1개 이상 입력해주세요.' });

    await client.query('BEGIN');
    const productIds = [...new Set(items.map((i) => Number(i.product_id)).filter(Number.isInteger))];
    const products = await client.query(
      'SELECT id, base_price FROM products WHERE id = ANY($1::int[]) AND is_active = true',
      [productIds]
    );
    const productPrices = new Map(products.rows.map((p) => [p.id, toNumber(p.base_price)]));
    if (productPrices.size !== productIds.length || productIds.length !== items.length) {
      await client.query('ROLLBACK');
      return res.status(400).json({ message: '발주 품목에 유효하지 않거나 중복된 제품이 있습니다.' });
    }

    const pricedItems = items.map((item) => ({
      product_id: Number(item.product_id),
      quantity: toNumber(item.quantity),
      unit_price: productPrices.get(Number(item.product_id))
    }));
    if (pricedItems.some((i) => !Number.isInteger(i.product_id) || !Number.isInteger(i.quantity) || i.quantity < 1)) {
      await client.query('ROLLBACK');
      return res.status(400).json({ message: '발주 수량은 1개 이상의 정수여야 합니다.' });
    }

    const totalAmount = pricedItems.reduce((s, i) => s + i.quantity * i.unit_price, 0);
    const orderNumber = await nextOrderNumber(client);

    const { rows: [order] } = await client.query(
      `INSERT INTO orders
         (order_number, dealer_id, distributor_id, total_amount, delivery_address, payment_terms, note, status, received_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, 'CONVERTED', NOW())
       RETURNING *`,
      [orderNumber, req.session.user.id, companyId(req.session.user), totalAmount,
       req.body.delivery_address || '', req.body.payment_terms || null, req.body.note || null]
    );

    for (const item of pricedItems) {
      await client.query(
        `INSERT INTO order_items (order_id, product_id, quantity, unit_price)
         VALUES ($1, $2, $3, $4)`,
        [order.id, item.product_id, item.quantity, item.unit_price]
      );
    }

    await client.query('COMMIT');
    res.status(201).json({ order });
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
});

router.post('/:id/deliver', roleCheck('dealer'), async (req, res) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const { rows } = await client.query(
      `UPDATE orders SET status = 'DELIVERED', updated_at = NOW()
       WHERE id = $1 AND dealer_id = $2 AND status = 'SHIPPED'
       RETURNING *`,
      [req.params.id, req.session.user.id]
    );
    if (!rows[0]) {
      await client.query('ROLLBACK');
      return res.status(404).json({ message: '입고확인 가능한 발주서를 찾을 수 없습니다.' });
    }
    await client.query(
      `UPDATE shipments SET received_at = NOW(), received_by = $2
       WHERE order_id = $1 AND received_at IS NULL`,
      [req.params.id, req.session.user.id]
    );
    await client.query('COMMIT');
    res.json({ order: rows[0] });
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
});

router.patch('/:id', roleCheck('admin', 'distributor'), async (req, res) => {
  const client = await pool.connect();
  try {
    const items = Array.isArray(req.body.items) ? req.body.items : [];
    if (!items.length) return res.status(400).json({ message: '발주 품목을 1개 이상 입력해주세요.' });

    const normalizedItems = items.map((item) => ({
      product_id: Number(item.product_id),
      quantity: toNumber(item.quantity),
      unit_price: toNumber(item.unit_price)
    }));
    if (normalizedItems.some((item) => !Number.isInteger(item.product_id)
      || !Number.isInteger(item.quantity) || item.quantity < 1 || item.unit_price < 0)) {
      return res.status(400).json({ message: '발주 품목의 제품, 수량 또는 단가를 확인해주세요.' });
    }

    await client.query('BEGIN');
    const isDistributor = req.session.user.role === 'distributor';
    const allowedStatuses = isDistributor ? ['PENDING', 'RECEIVED'] : ['CONVERTED', 'CONFIRMED'];
    const order = await client.query(
      `UPDATE orders
       SET delivery_address = COALESCE($4, delivery_address),
           payment_terms = COALESCE($5, payment_terms),
           note = COALESCE($6, note),
           status = CASE WHEN $2::boolean AND status = 'PENDING' THEN 'RECEIVED' ELSE status END,
           received_at = CASE WHEN $2::boolean THEN COALESCE(received_at, NOW()) ELSE received_at END,
           updated_at = NOW()
       WHERE id = $1
         AND ($2::boolean = false OR distributor_id = $3)
         AND status = ANY($7::varchar[])
       RETURNING *`,
      [req.params.id, isDistributor, companyId(req.session.user), req.body.delivery_address, req.body.payment_terms, req.body.note, allowedStatuses]
    );
    if (!order.rows[0]) {
      await client.query('ROLLBACK');
      return res.status(404).json({ message: '수정 가능한 발주서를 찾을 수 없습니다.' });
    }

    await client.query('DELETE FROM order_items WHERE order_id = $1', [req.params.id]);
    let total = 0;
    for (const item of normalizedItems) {
      total += item.quantity * item.unit_price;
      await client.query(
        `INSERT INTO order_items (order_id, product_id, quantity, unit_price)
         VALUES ($1, $2, $3, $4)`,
        [req.params.id, item.product_id, item.quantity, item.unit_price]
      );
    }
    await client.query('UPDATE orders SET total_amount = $2 WHERE id = $1', [req.params.id, total]);

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
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const { rows } = await client.query(
      `UPDATE orders
       SET status = 'CONVERTED',
           received_at = COALESCE(received_at, NOW()),
           converted_at = NOW(),
           updated_at = NOW()
       WHERE id = $1 AND distributor_id = $2 AND status IN ('PENDING', 'RECEIVED')
       RETURNING *`,
      [req.params.id, companyId(req.session.user)]
    );
    if (!rows[0]) {
      await client.query('ROLLBACK');
      return res.status(404).json({ message: '전환 가능한 발주서를 찾을 수 없습니다.' });
    }

    // 전환 시점의 제조사 판매가를 스냅샷으로 남긴다 (총판→대리점 단가인 unit_price는 그대로 둠).
    await client.query(
      `UPDATE order_items oi
       SET manufacturer_unit_price = p.base_price
       FROM products p
       WHERE oi.product_id = p.id AND oi.order_id = $1`,
      [req.params.id]
    );

    await client.query('COMMIT');
    res.json({ order: rows[0] });
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
});

router.patch('/:id/status', roleCheck('admin'), async (req, res) => {
  const status = req.body.status;
  const timestamps = {
    CONFIRMED: 'confirmed_at = NOW(),',
    CANCELLED: ''
  };
  if (!['CONFIRMED', 'CANCELLED'].includes(status)) {
    return res.status(400).json({ message: '허용되지 않은 상태입니다.' });
  }
  const allowedCurrentStatuses = status === 'CONFIRMED'
    ? ['CONVERTED']
    : ['PENDING', 'RECEIVED', 'CONVERTED', 'CONFIRMED'];
  const { rows } = await pool.query(
    `UPDATE orders
     SET status = $2,
         ${timestamps[status]}
         updated_at = NOW()
     WHERE id = $1 AND status = ANY($3::varchar[])
     RETURNING *`,
    [req.params.id, status, allowedCurrentStatuses]
  );
  if (!rows[0]) return res.status(409).json({ message: '현재 상태에서는 요청한 상태로 변경할 수 없습니다.' });
  res.json({ order: rows[0] });
});

module.exports = router;
