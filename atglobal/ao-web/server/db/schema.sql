DROP TABLE IF EXISTS shipments CASCADE;
DROP TABLE IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS distributor_inventory CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  company_name VARCHAR(100),
  role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'distributor', 'dealer')),
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'inactive', 'rejected')),
  distributor_id INTEGER REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  model_name VARCHAR(100) NOT NULL,
  spec VARCHAR(200),
  base_price NUMERIC(15, 2) DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE inventory (
  id SERIAL PRIMARY KEY,
  product_id INTEGER REFERENCES products(id) NOT NULL,
  quantity INTEGER DEFAULT 0,
  min_quantity INTEGER DEFAULT 0,
  note TEXT,
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(product_id)
);

CREATE TABLE distributor_inventory (
  id SERIAL PRIMARY KEY,
  distributor_id INTEGER REFERENCES users(id) NOT NULL,
  product_id INTEGER REFERENCES products(id) NOT NULL,
  quantity INTEGER DEFAULT 0,
  min_quantity INTEGER DEFAULT 0,
  note TEXT,
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(distributor_id, product_id)
);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  order_number VARCHAR(30) UNIQUE NOT NULL,
  dealer_id INTEGER REFERENCES users(id) NOT NULL,
  distributor_id INTEGER REFERENCES users(id) NOT NULL,
  status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'RECEIVED', 'CONVERTED', 'CONFIRMED', 'SHIPPED', 'CANCELLED')),
  delivery_address TEXT,
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

CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE NOT NULL,
  product_id INTEGER REFERENCES products(id) NOT NULL,
  quantity INTEGER NOT NULL,
  unit_price NUMERIC(15, 2) NOT NULL,
  amount NUMERIC(15, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

CREATE TABLE sales (
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

CREATE TABLE shipments (
  id SERIAL PRIMARY KEY,
  shipment_number VARCHAR(30) UNIQUE NOT NULL,
  order_id INTEGER REFERENCES orders(id) NOT NULL,
  dealer_id INTEGER REFERENCES users(id) NOT NULL,
  distributor_id INTEGER REFERENCES users(id) NOT NULL,
  delivery_address TEXT,
  tracking_number VARCHAR(100),
  shipped_at TIMESTAMP DEFAULT NOW(),
  note TEXT
);

CREATE INDEX idx_users_role_status ON users(role, status);
CREATE INDEX idx_orders_dealer ON orders(dealer_id);
CREATE INDEX idx_orders_distributor ON orders(distributor_id);
CREATE INDEX idx_orders_status ON orders(status);
