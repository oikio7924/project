INSERT INTO products (name, model_name, spec, base_price)
VALUES
  ('파워뱅크', 'PB-10000', '10,000Wh', 1500000),
  ('파워뱅크', 'PB-20000', '20,000Wh', 2500000)
ON CONFLICT DO NOTHING;

INSERT INTO inventory (product_id, quantity, min_quantity, note)
SELECT id, 0, 5, '초기 등록'
FROM products
ON CONFLICT DO NOTHING;
