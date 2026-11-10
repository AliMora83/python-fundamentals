-- 00_explore.sql
-- First raw SQL against a local Odoo 18 demo database ("practice").
-- Run with: docker compose exec db psql -U odoo -d practice

-- First 10 contacts (res_partner = Contacts app)
SELECT id, name, email, is_company
FROM res_partner
LIMIT 10;

-- Count companies vs individuals
SELECT is_company, COUNT(*)
FROM res_partner
GROUP BY is_company;

-- 10 most recent customer invoices (account_move = invoices/journal entries)
SELECT id, name, move_type, state, amount_total
FROM account_move
WHERE move_type = 'out_invoice'
ORDER BY id DESC
LIMIT 10;
