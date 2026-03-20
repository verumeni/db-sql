-- users: 50,000件
INSERT INTO users (email, name, status, created_at)
SELECT
  'user' || gs || '@example.com',
  'user_' || gs,
  CASE WHEN gs % 20 = 0 THEN 'inactive' ELSE 'active' END,
  now() - (random() * interval '365 days')
FROM generate_series(1, 50000) AS gs;

-- products: 10,000件
INSERT INTO products (sku, name, price, created_at)
SELECT
  'SKU-' || lpad(gs::text, 8, '0'),
  'product_' || gs,
  round((random() * 10000)::numeric, 2),
  now() - (random() * interval '365 days')
FROM generate_series(1, 10000) AS gs;

-- orders: 300,000件
INSERT INTO orders (user_id, order_status, ordered_at, total_amount)
SELECT
  (1 + floor(random() * 50000))::bigint,
  (ARRAY['new','paid','shipped','cancelled'])[1 + floor(random() * 4)::int],
  now() - (random() * interval '365 days'),
  round((random() * 200000)::numeric, 2)
FROM generate_series(1, 300000) AS gs;

-- order_items: 各orderに1-4件（概ね 750,000件前後）
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT
  o.id,
  (1 + floor(random() * 10000))::bigint,
  (1 + floor(random() * 5))::int,
  round((random() * 10000)::numeric, 2)
FROM orders o
CROSS JOIN LATERAL generate_series(1, 1 + floor(random() * 4)::int);

-- 統計更新（実行計画の精度向上）
ANALYZE;