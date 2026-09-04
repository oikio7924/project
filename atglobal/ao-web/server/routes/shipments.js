'use strict';

const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');
const roleCheck = require('../middleware/roleCheck');
const { toNumber, companyId } = require('../utils');

const router = express.Router();
router.use(requireAuth);

async function nextShipmentNumber(client) {
  const date = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  await client.query('SELECT pg_advisory_xact_lock(hashtext($1))', [`shipment-${date}`]);
  const { rows } = await client.query(
    `SELECT COUNT(*)::int AS count FROM shipments WHERE shipment_number LIKE $1`,
    [`SHP-${date}-%`]
  );
  return `SHP-${date}-${String(rows[0].count + 1).padStart(3, '0')}`;
}

router.post('/', roleCheck('admin'), async (req, res) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    const orderResult = await client.query(
      'SELECT * FROM orders WHERE id = $1 FOR UPDATE',
      [req.body.order_id]
    );
    const order = orderResult.rows[0];
    if (!order) {
      await client.query('ROLLBACK');
      return res.status(404).json({ message: '발주서를 찾을 수 없습니다.' });
    }
    if (!['CONFIRMED', 'PARTIALLY_SHIPPED'].includes(order.status)) {
      await client.query('ROLLBACK');
      return res.status(409).json({ message: '수주 확정 상태의 발주서만 출고할 수 있습니다.' });
    }

    const requestedItems = Array.isArray(req.body.items) ? req.body.items : [];
    if (!requestedItems.length) {
      await client.query('ROLLBACK');
      return res.status(400).json({ message: '출고할 품목을 1개 이상 입력해주세요.' });
    }

    const orderItems = await client.query(
      `SELECT oi.id, oi.product_id, oi.quantity, p.model_name
       FROM order_items oi
       JOIN products p ON p.id = oi.product_id
       WHERE oi.order_id = $1
       FOR UPDATE OF oi`,
      [order.id]
    );
    const orderItemMap = new Map(orderItems.rows.map((item) => [item.id, item]));

    const shippedSoFar = await client.query(
      `SELECT order_item_id, COALESCE(SUM(quantity), 0)::int AS shipped
       FROM shipment_items
       WHERE order_item_id = ANY($1::int[])
       GROUP BY order_item_id`,
      [orderItems.rows.map((item) => item.id)]
    );
    const shippedMap = new Map(shippedSoFar.rows.map((row) => [row.order_item_id, row.shipped]));

    const normalizedItems = requestedItems.map((item) => ({
      order_item_id: Number(item.order_item_id),
      quantity: toNumber(item.quantity)
    }));

    for (const item of normalizedItems) {
      const orderItem = orderItemMap.get(item.order_item_id);
      if (!orderItem) {
        await client.query('ROLLBACK');
        return res.status(400).json({ message: '이 발주서에 속하지 않은 품목이 포함되어 있습니다.' });
      }
      if (!Number.isInteger(item.quantity) || item.quantity < 1) {
        await client.query('ROLLBACK');
        return res.status(400).json({ message: '출고 수량은 1개 이상의 정수여야 합니다.' });
      }
      const remaining = orderItem.quantity - (shippedMap.get(item.order_item_id) || 0);
      if (item.quantity > remaining) {
        await client.query('ROLLBACK');
        return res.status(409).json({
          message: `${orderItem.model_name}의 출고 가능 수량(${remaining}개)을 초과했습니다.`
        });
      }
    }

    const byProduct = new Map();
    for (const item of normalizedItems) {
      const orderItem = orderItemMap.get(item.order_item_id);
      const prev = byProduct.get(orderItem.product_id) || { quantity: 0, model_name: orderItem.model_name };
      prev.quantity += item.quantity;
      byProduct.set(orderItem.product_id, prev);
    }

    const productIds = [...byProduct.keys()];
    const inventory = await client.query(
      'SELECT product_id, quantity FROM inventory WHERE product_id = ANY($1::int[]) FOR UPDATE',
      [productIds]
    );
    const invQuantities = new Map(inventory.rows.map((item) => [item.product_id, item.quantity]));
    const insufficient = [...byProduct.entries()].filter(
      ([productId, item]) => (invQuantities.get(productId) || 0) < item.quantity
    );
    if (insufficient.length) {
      await client.query('ROLLBACK');
      const details = insufficient
        .map(([productId, item]) => `${item.model_name} ${invQuantities.get(productId) || 0}/${item.quantity}`)
        .join(', ');
      return res.status(409).json({ message: `제조사 재고가 부족합니다. (현재/필요: ${details})` });
    }

    for (const [productId, item] of byProduct) {
      await client.query(
        `UPDATE inventory SET quantity = quantity - $2, updated_at = NOW() WHERE product_id = $1`,
        [productId, item.quantity]
      );
    }

    const { rows } = await client.query(
      `INSERT INTO shipments (shipment_number, order_id, dealer_id, distributor_id, delivery_address, tracking_number, carrier_code, note)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       RETURNING *`,
      [
        await nextShipmentNumber(client),
        order.id,
        order.dealer_id,
        order.distributor_id,
        req.body.delivery_address || order.delivery_address,
        req.body.tracking_number || null,
        req.body.carrier_code || null,
        req.body.note || null
      ]
    );
    const shipment = rows[0];

    for (const item of normalizedItems) {
      const orderItem = orderItemMap.get(item.order_item_id);
      await client.query(
        `INSERT INTO shipment_items (shipment_id, order_item_id, product_id, quantity)
         VALUES ($1, $2, $3, $4)`,
        [shipment.id, item.order_item_id, orderItem.product_id, item.quantity]
      );
    }

    const stillRemaining = orderItems.rows.some((orderItem) => {
      const justShipped = normalizedItems
        .filter((item) => item.order_item_id === orderItem.id)
        .reduce((sum, item) => sum + item.quantity, 0);
      const totalShipped = (shippedMap.get(orderItem.id) || 0) + justShipped;
      return totalShipped < orderItem.quantity;
    });

    const nextStatus = stillRemaining ? 'PARTIALLY_SHIPPED' : 'SHIPPED';
    await client.query(
      `UPDATE orders
       SET status = $2,
           shipped_at = CASE WHEN $3 THEN COALESCE(shipped_at, NOW()) ELSE shipped_at END,
           updated_at = NOW()
       WHERE id = $1`,
      [order.id, nextStatus, nextStatus === 'SHIPPED']
    );

    await client.query('COMMIT');
    res.status(201).json({ shipment, order_status: nextStatus });
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
});

router.get('/', roleCheck('admin', 'distributor'), async (req, res) => {
  const params = [];
  let where = '';
  if (req.session.user.role === 'distributor') {
    params.push(companyId(req.session.user));
    where = 'WHERE s.distributor_id = $1';
  }
  const { rows } = await pool.query(
    `SELECT s.*, o.order_number, dealer.company_name AS dealer_company,
            distributor.company_name AS distributor_company,
            CASE WHEN receiver.status = 'deleted' THEN '삭제된 회원입니다' ELSE receiver.name END AS received_by_name,
            receiver.role AS received_by_role,
            receiver.company_name AS received_by_company,
            COALESCE(json_agg(json_build_object(
              'order_item_id', si.order_item_id,
              'product_id', si.product_id,
              'product_name', p.name,
              'model_name', p.model_name,
              'quantity', si.quantity
            ) ORDER BY si.id) FILTER (WHERE si.id IS NOT NULL), '[]') AS items
     FROM shipments s
     JOIN orders o ON o.id = s.order_id
     JOIN users dealer ON dealer.id = s.dealer_id
     JOIN users distributor ON distributor.id = s.distributor_id
     LEFT JOIN users receiver ON receiver.id = s.received_by
     LEFT JOIN shipment_items si ON si.shipment_id = s.id
     LEFT JOIN products p ON p.id = si.product_id
     ${where}
     GROUP BY s.id, o.order_number, dealer.company_name, distributor.company_name,
              receiver.name, receiver.role, receiver.company_name, receiver.status
     ORDER BY s.shipped_at DESC`,
    params
  );
  res.json({ shipments: rows });
});

router.post('/:id/receive', roleCheck('distributor'), async (req, res) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const shipmentResult = await client.query(
      `SELECT * FROM shipments
       WHERE id = $1 AND distributor_id = $2
       FOR UPDATE`,
      [req.params.id, companyId(req.session.user)]
    );
    const shipment = shipmentResult.rows[0];
    if (!shipment) {
      await client.query('ROLLBACK');
      return res.status(404).json({ message: '입고 확인할 출고 내역을 찾을 수 없습니다.' });
    }
    if (shipment.received_at) {
      await client.query('ROLLBACK');
      return res.status(409).json({ message: '이미 입고 확인된 출고 내역입니다.' });
    }

    const order = await client.query('SELECT status FROM orders WHERE id = $1 FOR UPDATE', [shipment.order_id]);

    // 총판은 자체 재고를 갖지 않고 제조사 재고를 그대로 조회만 하므로, 입고 확인 시 별도 재고 반영은 하지 않음

    const { rows } = await client.query(
      `UPDATE shipments
       SET received_at = NOW(), received_by = $2
       WHERE id = $1
       RETURNING *`,
      [shipment.id, req.session.user.id]
    );

    const remainingUnreceived = await client.query(
      `SELECT COUNT(*)::int AS cnt FROM shipments WHERE order_id = $1 AND received_at IS NULL`,
      [shipment.order_id]
    );
    if (order.rows[0].status === 'SHIPPED' && remainingUnreceived.rows[0].cnt === 0) {
      await client.query(
        `UPDATE orders SET status = 'DELIVERED', updated_at = NOW() WHERE id = $1`,
        [shipment.order_id]
      );
    }

    await client.query('COMMIT');
    res.json({ shipment: rows[0] });
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
});

router.patch('/:id', roleCheck('admin'), async (req, res) => {
  const { rows } = await pool.query(
    `UPDATE shipments
     SET tracking_number = COALESCE($2, tracking_number),
         note = COALESCE($3, note)
     WHERE id = $1 RETURNING *`,
    [req.params.id, req.body.tracking_number, req.body.note]
  );
  if (!rows[0]) return res.status(404).json({ message: '출고 내역을 찾을 수 없습니다.' });
  res.json({ shipment: rows[0] });
});

module.exports = router;
