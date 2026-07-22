-- ERPFINAL - Accounting AutoFix (Safe)
-- Chay thu cong tren Postgres sau khi backup DB.
-- Muc tieu: sua cac lech du lieu "an toan", KHONG dong vao ton kho.

BEGIN;

-- =========================================================
-- 0) Preview nhanh truoc khi sua
-- =========================================================
SELECT 'START_AT' AS info, NOW() AS ts;

-- =========================================================
-- 1) Dong bo tong no/co cua journal_entries theo journal_lines
-- =========================================================
WITH line_sum AS (
  SELECT
    jl.entry_id,
    SUM(COALESCE(jl.debit, 0))  AS sum_debit,
    SUM(COALESCE(jl.credit, 0)) AS sum_credit
  FROM journal_lines jl
  GROUP BY jl.entry_id
),
need_fix AS (
  SELECT
    je.id,
    ls.sum_debit,
    ls.sum_credit
  FROM journal_entries je
  JOIN line_sum ls ON ls.entry_id = je.id
  WHERE COALESCE(je.total_debit, 0)  <> COALESCE(ls.sum_debit, 0)
     OR COALESCE(je.total_credit, 0) <> COALESCE(ls.sum_credit, 0)
)
UPDATE journal_entries je
SET
  total_debit  = nf.sum_debit,
  total_credit = nf.sum_credit
FROM need_fix nf
WHERE je.id = nf.id;

-- =========================================================
-- 2) Dong bo debt.paid_amount, debt.balance theo debt_payments
-- =========================================================
WITH pay_sum AS (
  SELECT debt_id, SUM(COALESCE(amount, 0)) AS paid
  FROM debt_payments
  GROUP BY debt_id
),
calc AS (
  SELECT
    d.id,
    COALESCE(ps.paid, 0) AS paid_new,
    (COALESCE(d.amount, 0) - COALESCE(ps.paid, 0)) AS bal_new
  FROM debts d
  LEFT JOIN pay_sum ps ON ps.debt_id = d.id
)
UPDATE debts d
SET
  paid_amount = c.paid_new,
  balance = c.bal_new
FROM calc c
WHERE d.id = c.id
  AND (
    COALESCE(d.paid_amount, 0) <> COALESCE(c.paid_new, 0)
    OR COALESCE(d.balance, 0) <> COALESCE(c.bal_new, 0)
  );

-- =========================================================
-- 3) Cap nhat debt.status theo balance + due_date
-- =========================================================
UPDATE debts d
SET status = CASE
  WHEN COALESCE(d.balance, 0) <= 0 THEN 'paid'
  WHEN d.due_date IS NOT NULL AND d.due_date < CURRENT_DATE THEN 'overdue'
  WHEN COALESCE(d.balance, 0) < COALESCE(d.amount, 0) THEN 'partial'
  ELSE 'open'
END
WHERE d.status IS DISTINCT FROM CASE
  WHEN COALESCE(d.balance, 0) <= 0 THEN 'paid'
  WHEN d.due_date IS NOT NULL AND d.due_date < CURRENT_DATE THEN 'overdue'
  WHEN COALESCE(d.balance, 0) < COALESCE(d.amount, 0) THEN 'partial'
  ELSE 'open'
END;

-- =========================================================
-- 4) Dong bo VAT record theo chung tu goc (neu co reference)
-- =========================================================
UPDATE vat_records vr
SET
  vat_amount = si.vat_amount,
  total_amount = si.total_amount,
  taxable_amount = si.subtotal
FROM stock_ins si
WHERE vr.reference_type = 'stock_in'
  AND vr.reference_id = si.id
  AND (
    COALESCE(vr.vat_amount, 0) <> COALESCE(si.vat_amount, 0)
    OR COALESCE(vr.total_amount, 0) <> COALESCE(si.total_amount, 0)
    OR COALESCE(vr.taxable_amount, 0) <> COALESCE(si.subtotal, 0)
  );

UPDATE vat_records vr
SET
  vat_amount = so.vat_amount,
  total_amount = so.total_amount,
  taxable_amount = so.subtotal
FROM stock_outs so
WHERE vr.reference_type = 'stock_out'
  AND vr.reference_id = so.id
  AND (
    COALESCE(vr.vat_amount, 0) <> COALESCE(so.vat_amount, 0)
    OR COALESCE(vr.total_amount, 0) <> COALESCE(so.total_amount, 0)
    OR COALESCE(vr.taxable_amount, 0) <> COALESCE(so.subtotal, 0)
  );

-- =========================================================
-- 5) Bao cao sau khi sua
-- =========================================================
SELECT
  'AFTER_FIX_JE_UNBALANCED' AS check_name,
  COUNT(*) AS issue_count
FROM journal_entries je
WHERE COALESCE(je.total_debit, 0) <> COALESCE(je.total_credit, 0);

WITH pay_sum AS (
  SELECT debt_id, SUM(COALESCE(amount, 0)) AS paid
  FROM debt_payments
  GROUP BY debt_id
)
SELECT
  'AFTER_FIX_DEBT_BALANCE_MISMATCH' AS check_name,
  COUNT(*) AS issue_count
FROM debts d
LEFT JOIN pay_sum ps ON ps.debt_id = d.id
WHERE COALESCE(d.balance, 0) <> (COALESCE(d.amount, 0) - COALESCE(ps.paid, 0));

SELECT
  'AFTER_FIX_VAT_INPUT_MISMATCH' AS check_name,
  COUNT(*) AS issue_count
FROM vat_records vr
JOIN stock_ins si
  ON vr.reference_type = 'stock_in' AND vr.reference_id = si.id
WHERE COALESCE(vr.vat_amount, 0) <> COALESCE(si.vat_amount, 0)
   OR COALESCE(vr.total_amount, 0) <> COALESCE(si.total_amount, 0)
   OR COALESCE(vr.taxable_amount, 0) <> COALESCE(si.subtotal, 0);

SELECT
  'AFTER_FIX_VAT_OUTPUT_MISMATCH' AS check_name,
  COUNT(*) AS issue_count
FROM vat_records vr
JOIN stock_outs so
  ON vr.reference_type = 'stock_out' AND vr.reference_id = so.id
WHERE COALESCE(vr.vat_amount, 0) <> COALESCE(so.vat_amount, 0)
   OR COALESCE(vr.total_amount, 0) <> COALESCE(so.total_amount, 0)
   OR COALESCE(vr.taxable_amount, 0) <> COALESCE(so.subtotal, 0);

-- Neu ket qua OK thi COMMIT. Neu can hoan tac thi ROLLBACK.
-- COMMIT;
ROLLBACK;
