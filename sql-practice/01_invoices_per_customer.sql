-- Posted customer invoices per customer, highest revenue first (INNER JOIN + GROUP BY)
SELECT p.name AS customer,
       COUNT(m.id) AS invoices,
       SUM(m.amount_total) AS revenue
FROM account_move m
JOIN res_partner p ON p.id = m.partner_id
WHERE m.move_type = 'out_invoice'
  AND m.state = 'posted'
GROUP BY p.name
ORDER BY revenue DESC;
