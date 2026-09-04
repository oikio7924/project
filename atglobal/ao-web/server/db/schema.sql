-- DB_RESET 값과 무관하게 항상 실행됨: 없는 테이블/인덱스만 새로 만들고 기존 데이터는 건드리지 않음
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  company_name VARCHAR(100),
  role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'distributor', 'dealer')),
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'inactive', 'rejected', 'deleted')),
  distributor_id INTEGER REFERENCES users(id),
  address VARCHAR(300),
  manager_name VARCHAR(100),
  manager_department VARCHAR(100),
  manager_position VARCHAR(100),
  manager_phone VARCHAR(30),
  manager_email VARCHAR(120),
  manager_memo TEXT,
  is_owner BOOLEAN NOT NULL DEFAULT false,
  is_member_manager BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  model_name VARCHAR(100) NOT NULL UNIQUE,
  spec VARCHAR(200),
  base_price NUMERIC(15, 2) DEFAULT 0,
  barcode_prefix VARCHAR(50),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS inventory (
  id SERIAL PRIMARY KEY,
  product_id INTEGER REFERENCES products(id) NOT NULL,
  quantity INTEGER DEFAULT 0,
  min_quantity INTEGER DEFAULT 0,
  note TEXT,
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(product_id)
);

CREATE TABLE IF NOT EXISTS distributor_inventory (
  id SERIAL PRIMARY KEY,
  distributor_id INTEGER REFERENCES users(id) NOT NULL,
  product_id INTEGER REFERENCES products(id) NOT NULL,
  quantity INTEGER DEFAULT 0,
  min_quantity INTEGER DEFAULT 0,
  note TEXT,
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(distributor_id, product_id)
);

CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  order_number VARCHAR(30) UNIQUE NOT NULL,
  dealer_id INTEGER REFERENCES users(id) NOT NULL,
  distributor_id INTEGER REFERENCES users(id) NOT NULL,
  status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'RECEIVED', 'CONVERTED', 'CONFIRMED', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED', 'CANCELLED')),
  delivery_address TEXT,
  payment_terms TEXT,
  note TEXT,
  total_amount NUMERIC(15, 2) DEFAULT 0,
  ordered_at TIMESTAMP DEFAULT NOW(),
  received_at TIMESTAMP,
  converted_at TIMESTAMP,
  confirmed_at TIMESTAMP,
  shipped_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE NOT NULL,
  product_id INTEGER REFERENCES products(id) NOT NULL,
  quantity INTEGER NOT NULL,
  unit_price NUMERIC(15, 2) NOT NULL,
  amount NUMERIC(15, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

CREATE TABLE IF NOT EXISTS sales (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id),
  dealer_id INTEGER REFERENCES users(id) NOT NULL,
  distributor_id INTEGER REFERENCES users(id) NOT NULL,
  product_id INTEGER REFERENCES products(id) NOT NULL,
  quantity INTEGER NOT NULL,
  unit_price NUMERIC(15, 2) NOT NULL,
  amount NUMERIC(15, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
  sold_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS shipments (
  id SERIAL PRIMARY KEY,
  shipment_number VARCHAR(30) UNIQUE NOT NULL,
  order_id INTEGER REFERENCES orders(id) NOT NULL,
  dealer_id INTEGER REFERENCES users(id) NOT NULL,
  distributor_id INTEGER REFERENCES users(id) NOT NULL,
  delivery_address TEXT,
  tracking_number VARCHAR(100),
  carrier_code VARCHAR(20),
  shipped_at TIMESTAMP DEFAULT NOW(),
  received_at TIMESTAMP,
  received_by INTEGER REFERENCES users(id),
  note TEXT
);

CREATE TABLE IF NOT EXISTS shipment_items (
  id SERIAL PRIMARY KEY,
  shipment_id INTEGER REFERENCES shipments(id) ON DELETE CASCADE NOT NULL,
  order_item_id INTEGER REFERENCES order_items(id) NOT NULL,
  product_id INTEGER REFERENCES products(id) NOT NULL,
  quantity INTEGER NOT NULL CHECK (quantity > 0)
);

CREATE TABLE IF NOT EXISTS distributor_product_prices (
  id SERIAL PRIMARY KEY,
  distributor_id INTEGER REFERENCES users(id) NOT NULL,
  product_id INTEGER REFERENCES products(id) NOT NULL,
  price NUMERIC(15, 2) NOT NULL,
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(distributor_id, product_id)
);

CREATE TABLE IF NOT EXISTS product_batches (
  id SERIAL PRIMARY KEY,
  product_id INTEGER REFERENCES products(id) NOT NULL,
  barcode_raw VARCHAR(300) UNIQUE NOT NULL,
  lot_number VARCHAR(100),
  manufacture_date DATE,
  quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity = 1),
  note TEXT,
  scanned_by INTEGER REFERENCES users(id),
  scanned_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_role_status ON users(role, status);
CREATE INDEX IF NOT EXISTS idx_orders_dealer ON orders(dealer_id);
CREATE INDEX IF NOT EXISTS idx_orders_distributor ON orders(distributor_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_shipment_items_shipment ON shipment_items(shipment_id);
CREATE INDEX IF NOT EXISTS idx_shipment_items_order_item ON shipment_items(order_item_id);
