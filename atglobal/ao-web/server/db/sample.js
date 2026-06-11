'use strict';

require('dotenv').config({ path: require('path').join(__dirname, '../../.env') });

const pool = require('../db');

async function insertSample() {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    const pw = 'Sample1234!';

    // ── 총판 2명 ─────────────────────────────────────────
    const dist1 = await client.query(
      `INSERT INTO users (username, password, name, phone, company_name, role, status)
       VALUES ('dist1', $1, '김총판', '010-1111-2222', '서울총판', 'distributor', 'active')
       ON CONFLICT (username) DO UPDATE SET status='active' RETURNING id`, [pw]
    );
    const dist2 = await client.query(
      `INSERT INTO users (username, password, name, phone, company_name, role, status)
       VALUES ('dist2', $1, '박총판', '010-3333-4444', '부산총판', 'distributor', 'active')
       ON CONFLICT (username) DO UPDATE SET status='active' RETURNING id`, [pw]
    );
    const d1 = dist1.rows[0].id;
    const d2 = dist2.rows[0].id;

    // ── 대리점 4곳 ───────────────────────────────────────
    const deal1 = await client.query(
      `INSERT INTO users (username, password, name, phone, company_name, role, status, distributor_id)
       VALUES ('dealer1', $1, '홍길동', '010-5555-6666', '서울A대리점', 'dealer', 'active', $2)
       ON CONFLICT (username) DO UPDATE SET status='active', distributor_id=$2 RETURNING id`, [pw, d1]
    );
    const deal2 = await client.query(
      `INSERT INTO users (username, password, name, phone, company_name, role, status, distributor_id)
       VALUES ('dealer2', $1, '이영희', '010-7777-8888', '부산B대리점', 'dealer', 'active', $2)
       ON CONFLICT (username) DO UPDATE SET status='active', distributor_id=$2 RETURNING id`, [pw, d1]
    );
    const deal3 = await client.query(
      `INSERT INTO users (username, password, name, phone, company_name, role, status, distributor_id)
       VALUES ('dealer3', $1, '박민수', '010-9999-0000', '대구C대리점', 'dealer', 'active', $2)
       ON CONFLICT (username) DO UPDATE SET status='active', distributor_id=$2 RETURNING id`, [pw, d2]
    );
    const deal4 = await client.query(
      `INSERT INTO users (username, password, name, phone, company_name, role, status, distributor_id)
       VALUES ('dealer4', $1, '최지수', '010-1234-5678', '인천D대리점', 'dealer', 'active', $2)
       ON CONFLICT (username) DO UPDATE SET status='active', distributor_id=$2 RETURNING id`, [pw, d2]
    );
    const [a1, a2, a3, a4] = [deal1.rows[0].id, deal2.rows[0].id, deal3.rows[0].id, deal4.rows[0].id];

    // ── 승인 대기 1명 ────────────────────────────────────
    await client.query(
      `INSERT INTO users (username, password, name, phone, company_name, role, status)
       VALUES ('pending1', $1, '대기유저', '010-0000-1111', '신규대리점', 'dealer', 'pending')
       ON CONFLICT (username) DO NOTHING`, [pw]
    );

    // ── 제품 ID 조회 ─────────────────────────────────────
    const prodRows = await client.query(`SELECT id, base_price FROM products WHERE is_active = true ORDER BY id`);
    const pb10 = prodRows.rows[0];
    const pb20 = prodRows.rows[1];

    // ── 총판 재고 ────────────────────────────────────────
    for (const [distId, qty1, qty2] of [[d1, 200, 150], [d2, 180, 120]]) {
      await client.query(
        `INSERT INTO distributor_inventory (distributor_id, product_id, quantity, min_quantity)
         VALUES ($1, $2, $3, 10) ON CONFLICT (distributor_id, product_id) DO UPDATE SET quantity=$3`,
        [distId, pb10.id, qty1]
      );
      await client.query(
        `INSERT INTO distributor_inventory (distributor_id, product_id, quantity, min_quantity)
         VALUES ($1, $2, $3, 10) ON CONFLICT (distributor_id, product_id) DO UPDATE SET quantity=$3`,
        [distId, pb20.id, qty2]
      );
    }

    // ── 관리자 재고 ──────────────────────────────────────
    await client.query(`UPDATE inventory SET quantity=480, min_quantity=20 WHERE product_id=$1`, [pb10.id]);
    await client.query(`UPDATE inventory SET quantity=370, min_quantity=20 WHERE product_id=$1`, [pb20.id]);

    // ── 발주서 헬퍼 ──────────────────────────────────────
    let orderSeq = 1;
    async function makeOrder(dealerId, distId, status, daysAgo, items, addr = '서울특별시 강남구 테헤란로 123') {
      const date = new Date();
      date.setDate(date.getDate() - daysAgo);
      const dateStr = date.toISOString().slice(0, 10).replace(/-/g, '');
      const orderNumber = `ORD-${dateStr}-${String(orderSeq++).padStart(3, '0')}`;
      const total = items.reduce((s, i) => s + i.qty * i.price, 0);

      const ts = { ordered_at: date, received_at: null, converted_at: null, confirmed_at: null, shipped_at: null };
      if (['RECEIVED','CONVERTED','CONFIRMED','SHIPPED'].includes(status)) {
        const r = new Date(date); r.setHours(r.getHours() + 2); ts.received_at = r;
      }
      if (['CONVERTED','CONFIRMED','SHIPPED'].includes(status)) {
        const c = new Date(date); c.setDate(c.getDate() + 1); ts.converted_at = c;
      }
      if (['CONFIRMED','SHIPPED'].includes(status)) {
        const cf = new Date(date); cf.setDate(cf.getDate() + 2); ts.confirmed_at = cf;
      }
      if (status === 'SHIPPED') {
        const sh = new Date(date); sh.setDate(sh.getDate() + 3); ts.shipped_at = sh;
      }

      const order = await client.query(
        `INSERT INTO orders
           (order_number, dealer_id, distributor_id, status, delivery_address, total_amount,
            ordered_at, received_at, converted_at, confirmed_at, shipped_at)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) RETURNING id`,
        [orderNumber, dealerId, distId, status, addr, total,
         ts.ordered_at, ts.received_at, ts.converted_at, ts.confirmed_at, ts.shipped_at]
      );
      const orderId = order.rows[0].id;
      for (const item of items) {
        await client.query(
          `INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES ($1,$2,$3,$4)`,
          [orderId, item.pid, item.qty, item.price]
        );
      }
      if (status === 'SHIPPED') {
        const shDate = ts.shipped_at;
        const shNum = `SHP-${shDate.toISOString().slice(0,10).replace(/-/g,'')}-${String(orderSeq).padStart(3,'0')}`;
        await client.query(
          `INSERT INTO shipments (shipment_number, order_id, dealer_id, distributor_id, delivery_address, tracking_number, shipped_at)
           VALUES ($1,$2,$3,$4,$5,$6,$7)`,
          [shNum, orderId, dealerId, distId, addr, `CJ${Math.floor(Math.random()*9000000000+1000000000)}`, shDate]
        );
      }
    }

    const p10 = { pid: pb10.id, price: Number(pb10.base_price) };
    const p20 = { pid: pb20.id, price: Number(pb20.base_price) };

    await makeOrder(a1, d1, 'SHIPPED',   30, [{...p10, qty:80}, {...p20, qty:40}]);
    await makeOrder(a1, d1, 'SHIPPED',   20, [{...p10, qty:50}]);
    await makeOrder(a1, d1, 'CONFIRMED', 10, [{...p20, qty:60}]);
    await makeOrder(a1, d1, 'CONVERTED',  5, [{...p10, qty:100},{...p20, qty:30}]);
    await makeOrder(a1, d1, 'RECEIVED',   2, [{...p10, qty:50}]);

    await makeOrder(a2, d1, 'SHIPPED',   25, [{...p20, qty:30}], '부산광역시 해운대구 센텀중앙로 100');
    await makeOrder(a2, d1, 'SHIPPED',   15, [{...p10, qty:40},{...p20, qty:20}], '부산광역시 해운대구 센텀중앙로 100');
    await makeOrder(a2, d1, 'PENDING',    1, [{...p10, qty:30}], '부산광역시 해운대구 센텀중앙로 100');

    await makeOrder(a3, d2, 'SHIPPED',   28, [{...p10, qty:120},{...p20, qty:50}], '대구광역시 수성구 동대구로 100');
    await makeOrder(a3, d2, 'CONFIRMED', 12, [{...p20, qty:80}], '대구광역시 수성구 동대구로 100');
    await makeOrder(a3, d2, 'CONVERTED',  6, [{...p10, qty:70}], '대구광역시 수성구 동대구로 100');
    await makeOrder(a3, d2, 'RECEIVED',   3, [{...p10, qty:50},{...p20, qty:30}], '대구광역시 수성구 동대구로 100');

    await makeOrder(a4, d2, 'SHIPPED',   22, [{...p10, qty:60}], '인천광역시 남동구 인주대로 100');
    await makeOrder(a4, d2, 'PENDING',    4, [{...p20, qty:40}], '인천광역시 남동구 인주대로 100');

    await client.query('COMMIT');

    console.log('✅ 샘플 데이터 삽입 완료!');
    console.log('');
    console.log('── 샘플 계정 (비밀번호: Sample1234!) ──────────────');
    console.log('총판1   | dist1   | 서울총판');
    console.log('총판2   | dist2   | 부산총판');
    console.log('대리점1 | dealer1 | 서울A대리점 (총판1 소속)');
    console.log('대리점2 | dealer2 | 부산B대리점 (총판1 소속)');
    console.log('대리점3 | dealer3 | 대구C대리점 (총판2 소속)');
    console.log('대리점4 | dealer4 | 인천D대리점 (총판2 소속)');
    console.log('────────────────────────────────────────────────────');
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('❌ 오류:', err.message);
  } finally {
    client.release();
    pool.end();
  }
}

insertSample();
