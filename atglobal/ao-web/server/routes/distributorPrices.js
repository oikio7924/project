'use strict';

const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');
const roleCheck = require('../middleware/roleCheck');
const { toNumber, companyId } = require('../utils');

const router = express.Router();
router.use(requireAuth);

router.get('/', roleCheck('distributor'), async (req, res) => {
  const { rows } = await pool.query(
    `SELECT p.id, p.name, p.model_name, p.spec, p.base_price, dpp.price
     FROM products p
     LEFT JOIN distributor_product_prices dpp
       ON dpp.product_id = p.id AND dpp.distributor_id = $1
     WHERE p.is_active = true
     ORDER BY p.id`,
    [companyId(req.session.user)]
  );
  res.json({ prices: rows });
});

router.put('/:productId', roleCheck('distributor'), async (req, res) => {
  const price = Math.trunc(toNumber(req.body.price));
  if (!Number.isInteger(price) || price <= 0) return res.status(400).json({ message: '판매가는 0보다 큰 정수로 입력해주세요.' });

  const { rows } = await pool.query(
    `INSERT INTO distributor_product_prices (distributor_id, product_id, price)
     VALUES ($1, $2, $3)
     ON CONFLICT (distributor_id, product_id) DO UPDATE
       SET price = $3, updated_at = NOW()
     RETURNING *`,
    [companyId(req.session.user), req.params.productId, price]
  );
  res.json({ price: rows[0] });
});

module.exports = router;
