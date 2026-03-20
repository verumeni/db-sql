-- 遅くなりやすい例1: ユーザー別の最新注文
EXPLAIN (ANALYZE, BUFFERS)
SELECT o.*
FROM orders o
WHERE o.user_id = 12345
ORDER BY o.ordered_at DESC
LIMIT 20;

-- 遅くなりやすい例2: 期間 + status 集計
EXPLAIN (ANALYZE, BUFFERS)
SELECT order_status, count(*), sum(total_amount)
FROM orders
WHERE ordered_at >= now() - interval '30 days'
GROUP BY order_status;

-- 遅くなりやすい例3: join + sort
EXPLAIN (ANALYZE, BUFFERS)
SELECT u.email, o.id, o.total_amount
FROM users u
JOIN orders o ON o.user_id = u.id
WHERE u.status = 'active'
ORDER BY o.total_amount DESC
LIMIT 100;