'use strict';

const express = require('express');
const pool = require('../db');
const { requireAuth } = require('../middleware/auth');
const roleCheck = require('../middleware/roleCheck');

const router = express.Router();
router.use(requireAuth, roleCheck('admin'));

// 바코드 파싱
// 형식: ATG|{모델명}|{로트번호}|{제조일YYYYMMDD}|{수량}
// 예시: ATG|PB-10000|LOT2024001|20240601|50
function parseBarcode(raw) {
  const parts = raw.trim().split('|');
  if (parts.length < 2) return null;

  const prefix = parts[0];
  if (prefix !== 'ATG') return null;

  const modelName = parts[1] || null;
  const lotNumber = parts[2] || null;
  const mfgRaw = parts[3] || null;
  const quantity = parts[4] ? parseInt(parts[4], 10) : 1;

  let manufactureDate = null;
  if (mfgRaw && mfgRaw.length === 8) {
    const y = mfgRaw.slice(0, 4);
    const m = mfgRaw.slice(4, 6);
    const d = mfgRaw.slice(6, 8);
    manufactureDate = `${y}-${m}-${d}`;
  }

  return { modelName, lotNumber, manufactureDate, quantity };
}

// 바코드 스캔 처리
router.post('/scan', async (req, res) => {
  const { barcode } = req.body;
  if (!barcode) return res.status(400).json({ message: '바코드 데이터가 없습니다.' });

  const parsed = parseBarcode(barcode);
  if (!parsed) {
    return res.status(400).json({ message: '지원하지 않는 바코드 형식입니다. (ATG|모델명|로트|제조일|수량)' });
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

    // 배치 기록 저장
    const batch = await client.query(
      `INSERT INTO product_batches (product_id, barcode_raw, lot_number, manufacture_date, quantity, scanned_by)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [prod.id, barcode, parsed.lotNumber, parsed.manufactureDate, parsed.quantity, req.session.user.id]
    );

    // 관리자 재고 수량 증가
    await client.query(
      `INSERT INTO inventory (product_id, quantity, min_quantity)
       VALUES ($1, $2, 0)
       ON CONFLICT (product_id) DO UPDATE SET quantity = inventory.quantity + $2, updated_at = NOW()`,
      [prod.id, parsed.quantity]
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
    throw err;
  } finally {
    client.release();
  }
});

// 배치 이력 조회
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

// 배치 삭제 (수량 복원)
router.delete('/batches/:id', async (req, res) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const batch = await client.query('SELECT * FROM product_batches WHERE id = $1', [req.params.id]);
    if (!batch.rows[0]) return res.status(404).json({ message: '배치를 찾을 수 없습니다.' });

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
