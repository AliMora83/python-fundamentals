-- Companies that have never placed a sales order (LEFT JOIN ... IS NULL)
SELECT p.id, p.name
FROM res_partner p
LEFT JOIN sale_order o ON o.partner_id = p.id
WHERE p.is_company = true
  AND o.id IS NULL
ORDER BY p.name;
