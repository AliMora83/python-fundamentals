-- Top 10 products by quantity sold on confirmed orders (multi-table join)
-- Product name is JSONB (translatable), so ->> 'en_US' extracts the text
SELECT t.name ->> 'en_US' AS product,
       SUM(l.product_uom_qty) AS qty_sold
FROM sale_order_line l
JOIN sale_order o        ON o.id = l.order_id
JOIN product_product pp  ON pp.id = l.product_id
JOIN product_template t  ON t.id = pp.product_tmpl_id
WHERE o.state = 'sale'
GROUP BY t.name ->> 'en_US'
ORDER BY qty_sold DESC
LIMIT 10;
