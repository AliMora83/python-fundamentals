-- Posted invoice revenue per month (date_trunc + GROUP BY)
SELECT date_trunc('month', invoice_date)::date AS month,
       COUNT(*) AS invoices,
       SUM(amount_total) AS revenue
FROM account_move
WHERE move_type = 'out_invoice'
  AND state = 'posted'
GROUP BY 1
ORDER BY 1;
