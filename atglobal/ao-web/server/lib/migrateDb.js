'use strict';

const pool = require('../db');

async function migrateDb() {
  await pool.query(`
    ALTER TABLE users
      ADD COLUMN IF NOT EXISTS manager_name VARCHAR(100),
      ADD COLUMN IF NOT EXISTS manager_department VARCHAR(100),
      ADD COLUMN IF NOT EXISTS manager_position VARCHAR(100),
      ADD COLUMN IF NOT EXISTS manager_phone VARCHAR(30),
      ADD COLUMN IF NOT EXISTS manager_email VARCHAR(120),
      ADD COLUMN IF NOT EXISTS manager_memo TEXT,
      ADD COLUMN IF NOT EXISTS company_phone VARCHAR(20),
      ADD COLUMN IF NOT EXISTS business_number VARCHAR(20),
      ADD COLUMN IF NOT EXISTS fax VARCHAR(20),
      ADD COLUMN IF NOT EXISTS ceo_name VARCHAR(100),
      ADD COLUMN IF NOT EXISTS open_date DATE,
      ADD COLUMN IF NOT EXISTS business_type VARCHAR(100),
      ADD COLUMN IF NOT EXISTS business_item VARCHAR(100),
      ADD COLUMN IF NOT EXISTS is_owner BOOLEAN NOT NULL DEFAULT false,
      ADD COLUMN IF NOT EXISTS is_member_manager BOOLEAN NOT NULL DEFAULT false;

    ALTER TABLE users
      DROP CONSTRAINT IF EXISTS users_status_check;
    ALTER TABLE users
      ADD CONSTRAINT users_status_check
      CHECK (status IN ('pending','active','inactive','rejected','deleted'));

    ALTER TABLE orders
      ADD COLUMN IF NOT EXISTS payment_terms TEXT;

    ALTER TABLE orders
      DROP CONSTRAINT IF EXISTS orders_status_check;
    ALTER TABLE orders
      ADD CONSTRAINT orders_status_check
      CHECK (status IN ('PENDING','RECEIVED','CONVERTED','CONFIRMED','PARTIALLY_SHIPPED','SHIPPED','DELIVERED','CANCELLED'));

    ALTER TABLE shipments
      ADD COLUMN IF NOT EXISTS received_at TIMESTAMP,
      ADD COLUMN IF NOT EXISTS received_by INTEGER REFERENCES users(id),
      ADD COLUMN IF NOT EXISTS carrier_code VARCHAR(20);

    -- 한 발주서를 여러 번 나눠 출고할 수 있도록 order_id 유일 제약 해제
    ALTER TABLE shipments DROP CONSTRAINT IF EXISTS shipments_order_id_key;
    DROP INDEX IF EXISTS idx_shipments_order_unique;

    CREATE TABLE IF NOT EXISTS shipment_items (
      id SERIAL PRIMARY KEY,
      shipment_id INTEGER REFERENCES shipments(id) ON DELETE CASCADE NOT NULL,
      order_item_id INTEGER REFERENCES order_items(id) NOT NULL,
      product_id INTEGER REFERENCES products(id) NOT NULL,
      quantity INTEGER NOT NULL CHECK (quantity > 0)
    );
    CREATE INDEX IF NOT EXISTS idx_shipment_items_shipment ON shipment_items(shipment_id);
    CREATE INDEX IF NOT EXISTS idx_shipment_items_order_item ON shipment_items(order_item_id);

    DO $$
    BEGIN
      IF NOT EXISTS (
        SELECT barcode_raw
        FROM product_batches
        WHERE barcode_raw IS NOT NULL
        GROUP BY barcode_raw
        HAVING COUNT(*) > 1
      ) THEN
        CREATE UNIQUE INDEX IF NOT EXISTS idx_product_batches_barcode_unique
          ON product_batches(barcode_raw)
          WHERE barcode_raw IS NOT NULL;
      END IF;
    END
    $$;

    -- 제품 모델명 중복 등록 방지 (샘플 스크립트를 재실행해도 동일 모델이 계속 추가되지 않도록)
    CREATE UNIQUE INDEX IF NOT EXISTS idx_products_model_name_unique ON products(model_name);

    CREATE TABLE IF NOT EXISTS distributor_product_prices (
      id SERIAL PRIMARY KEY,
      distributor_id INTEGER REFERENCES users(id) NOT NULL,
      product_id INTEGER REFERENCES products(id) NOT NULL,
      price NUMERIC(15, 2) NOT NULL,
      updated_at TIMESTAMP DEFAULT NOW(),
      UNIQUE(distributor_id, product_id)
    );

    -- 총판이 발주를 제조사로 전환하는 순간의 제조사 판매가 스냅샷.
    -- unit_price(총판→대리점 판매가)는 그대로 두고, 제조사→총판 거래명세서에서만 이 값을 쓴다.
    ALTER TABLE order_items
      ADD COLUMN IF NOT EXISTS manufacturer_unit_price NUMERIC(15, 2);

    -- 총판/대리점이 설정에서 직접 등록하는 자사 로고. 미등록 시 헤더/발주서/거래명세서 등에서 공란으로 표시된다.
    ALTER TABLE users
      ADD COLUMN IF NOT EXISTS logo_url TEXT;

    -- 기본주소/상세주소를 분리 저장(기존엔 하나로 합쳐서 저장해 설정 화면 재조회 시 상세주소만 항상 빈 값으로 보였음)
    ALTER TABLE users
      ADD COLUMN IF NOT EXISTS address_detail VARCHAR(100);

    -- 회원가입 시 입력한 담당자 이름/연락처를 설정 > 담당자 정보에도 그대로 보이도록 초기값 채움
    UPDATE users SET manager_name = name WHERE manager_name IS NULL;
    UPDATE users SET manager_phone = phone WHERE manager_phone IS NULL;

    -- 기존 총판 루트 계정(직원이 아닌, 사업자번호로 인증된 계정)을 관리자로 백필
    UPDATE users SET is_owner = true WHERE role = 'distributor' AND distributor_id IS NULL;
  `);

  // 제조사 시드 관리자 계정을 관리자로 백필 (ADMIN_USERNAME은 신뢰 가능한 서버 환경변수)
  const adminUsername = process.env.ADMIN_USERNAME || 'admin';
  await pool.query(`UPDATE users SET is_owner = true WHERE username = $1`, [adminUsername]);
}

module.exports = migrateDb;
