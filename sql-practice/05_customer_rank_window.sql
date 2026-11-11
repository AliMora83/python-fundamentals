-- Rank customers by revenue and share of total (window function)
SELECT p.name AS customer,
       SUM(m.amount_total) AS revenue,
       RANK() OVER (ORDER BY SUM(m.amount_total) DESC) AS rank,
       ROUND(100 * SUM(m.amount_total)
             / SUM(SUM(m.amount_total)) OVER (), 1) AS pct_of_total
FROM account_move m
JOIN res_partner p ON p.id = m.partner_id
WHERE m.move_type = 'out_invoice'
  AND m.state = 'posted'
GROUP BY p.name
ORDER BY rank;
