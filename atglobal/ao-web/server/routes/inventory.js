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

router.get('/distributor', roleCheck('distributor'), async (req, res) => {
  const { rows } = await pool.query(
    `SELECT di.*, p.name, p.model_name, p.spec, p.base_price
     FROM distributor_inventory di JOIN products p ON p.id = di.product_id
     WHERE di.distributor_id = $1
     ORDER BY p.id`,
    [req.session.user.id]
  );
  res.json({ inventory: rows });
});

router.post('/distributor', roleCheck('distributor'), async (req, res) => {
  const { rows } = await pool.query(
    `INSERT INTO distributor_inventory (distributor_id, product_id, quantity, min_quantity, note)
     VALUES ($1, $2, $3, $4, $5)
     ON CONFLICT (distributor_id, product_id) DO UPDATE
     SET quantity = EXCLUDED.quantity, min_quantity = EXCLUDED.min_quantity, note = EXCLUDED.note, updated_at = NOW()
     RETURNING *`,
    [req.session.user.id, req.body.product_id, req.body.quantity || 0, req.body.min_quantity || 0, req.body.note || null]
  );
  res.status(201).json({ item: rows[0] });
});

router.patch('/distributor/:id', roleCheck('distributor'), async (req, res) => {
  const { rows } = await pool.query(
    `UPDATE distributor_inventory
     SET quantity = COALESCE($3, quantity),
         min_quantity = COALESCE($4, min_quantity),
         note = COALESCE($5, note),
         updated_at = NOW()
     WHERE id = $1 AND distributor_id = $2 RETURNING *`,
    [req.params.id, req.session.user.id, req.body.quantity, req.body.min_quantity, req.body.note]
  );
  res.json({ item: rows[0] });
});

module.exports = router;
