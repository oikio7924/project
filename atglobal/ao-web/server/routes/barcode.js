'use strict';

const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');
const roleCheck = require('../middleware/roleCheck');

const router = express.Router();
router.use(requireAuth, roleCheck('admin'));

// 개별 상품 바코드 파싱
// 형식: ATG|{모델명}|{개별식별번호}|{제조일YYYYMMDD}
// 예시: ATG|PB-10000|SN2024000001|20240601
function parseBarcode(raw) {
  const parts = raw.trim().split('|');
  if (parts.length < 3) return null;

  const prefix = parts[0];
  if (prefix !== 'ATG') return null;

  const modelName = parts[1] || null;
  const lotNumber = parts[2] || null;
  const mfgRaw = parts[3] || null;

  let manufactureDate = null;
  if (mfgRaw && mfgRaw.length === 8) {
    const y = mfgRaw.slice(0, 4);
    const m = mfgRaw.slice(4, 6);
    const d = mfgRaw.slice(6, 8);
    manufactureDate = `${y}-${m}-${d}`;
  }

  return { modelName, lotNumber, manufactureDate, quantity: 1 };
}

// 바코드 스캔 처리
router.post('/scan', async (req, res) => {
  const barcode = String(req.body.barcode || '').trim();
  if (!barcode) return res.status(400).json({ message: '바코드 데이터가 없습니다.' });

  const parsed = parseBarcode(barcode);
  if (!parsed) {
    return res.status(400).json({ message: '지원하지 않는 바코드 형식입니다. (ATG|모델명|개별식별번호|제조일)' });
  }

  const product = await pool.query(
    `SELECT * FROM products WHERE model_name = $1 AND is_active = true`,
    [parsed.modelName]
  );
  if (!product.rows[0]) {
    return res.status(404).json({ message: `제품을 찾을 수 없습니다: ${parsed.modelName}` });
  }

  const prod = product.rows[0];
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    await client.query('SELECT pg_advisory_xact_lock(hashtext($1))', [barcode]);

    const duplicate = await client.query(
      'SELECT id FROM product_batches WHERE barcode_raw = $1',
      [barcode]
    );
    if (duplicate.rows[0]) {
      await client.query('ROLLBACK');
      return res.status(409).json({ message: '이미 입고 처리된 상품 바코드입니다.' });
    }

    // 개별 상품 스캔 기록 저장
    const batch = await client.query(
      `INSERT INTO product_batches (product_id, barcode_raw, lot_number, manufacture_date, quantity, scanned_by)
       VALUES ($1, $2, $3, $4, 1, $5) RETURNING *`,
      [prod.id, barcode, parsed.lotNumber, parsed.manufactureDate, req.session.user.id]
    );

    // 관리자 재고 수량 증가
    await client.query(
      `INSERT INTO inventory (product_id, quantity, min_quantity)
       VALUES ($1, $2, 0)
       ON CONFLICT (product_id) DO UPDATE SET quantity = inventory.quantity + $2, updated_at = NOW()`,
      [prod.id, 1]
    );

    await client.query('COMMIT');
    res.json({
      ok: true,
      batch: batch.rows[0],
      product: { id: prod.id, name: prod.name, model_name: prod.model_name },
      parsed
    });
  } catch (err) {
    await client.query('ROLLBACK');
    if (err.code === '23505') {
      return res.status(409).json({ message: '이미 입고 처리된 상품 바코드입니다.' });
    }
    throw err;
  } finally {
    client.release();
  }
});

// 개별 상품 스캔 이력 조회
router.get('/batches', async (_req, res) => {
  const { rows } = await pool.query(
    `SELECT pb.*, p.name AS product_name, p.model_name, u.name AS scanned_by_name
     FROM product_batches pb
     JOIN products p ON p.id = pb.product_id
     LEFT JOIN users u ON u.id = pb.scanned_by
     ORDER BY pb.scanned_at DESC
     LIMIT 200`
  );
  res.json({ batches: rows });
});

// 개별 상품 스캔 삭제 (재고 1개 차감)
router.delete('/batches/:id', async (req, res) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const batch = await client.query('SELECT * FROM product_batches WHERE id = $1', [req.params.id]);
    if (!batch.rows[0]) return res.status(404).json({ message: '스캔 상품을 찾을 수 없습니다.' });

    await client.query(
      `UPDATE inventory SET quantity = GREATEST(0, quantity - $2), updated_at = NOW() WHERE product_id = $1`,
      [batch.rows[0].product_id, batch.rows[0].quantity]
    );
    await client.query('DELETE FROM product_batches WHERE id = $1', [req.params.id]);
    await client.query('COMMIT');
    res.json({ ok: true });
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
});

module.exports = router;
