-- ERPFINAL - Accounting Healthcheck
-- Postgres SQL (chay tren pgAdmin/DBeaver/psql)
-- Muc tieu: phat hien lech du lieu ke toan sau khi sua logic nhap/xuat + quy doi don vi.

-- =========================================================
-- 1) But toan khong can (tong no != tong co)
-- =========================================================
SELECT
  'JE_UNBALANCED' AS issue_type,
  je.id,
  je.code,
  je.date,
  je.reference_type,
  je.reference_id,
  je.reference_code,
  je.total_debit,
  je.total_credit
FROM journal_entries je
WHERE COALESCE(je.total_debit, 0) <> COALESCE(je.total_credit, 0)
ORDER BY je.date DESC, je.id DESC;

-- =========================================================
-- 2) But toan header lech so voi tong line
-- =========================================================
WITH line_sum AS (
  SELECT
    jl.entry_id,
    SUM(COALESCE(jl.debit, 0)) AS sum_debit,
    SUM(COALESCE(jl.credit, 0)) AS sum_credit
  FROM journal_lines jl
  GROUP BY jl.entry_id
)
SELECT
  'JE_HEADER_LINE_MISMATCH' AS issue_type,
  je.id,
  je.code,
  je.date,
  je.total_debit,
  je.total_credit,
  ls.sum_debit,
  ls.sum_credit
FROM journal_entries je
JOIN line_sum ls ON ls.entry_id = je.id
WHERE COALESCE(je.total_debit, 0) <> COALESCE(ls.sum_debit, 0)
   OR COALESCE(je.total_credit, 0) <> COALESCE(ls.sum_credit, 0)
ORDER BY je.date DESC, je.id DESC;

-- =========================================================
-- 3) Phieu da xac nhan nhung chua co but toan
-- =========================================================
SELECT
  'CONFIRMED_STOCK_IN_NO_JE' AS issue_type,
  si.id,
  si.code,
  si.date,
  si.total_amount
FROM stock_ins si
LEFT JOIN journal_entries je
  ON je.reference_type = 'stock_in' AND je.reference_id = si.id
WHERE si.status = 'confirmed'
  AND je.id IS NULL
ORDER BY si.date DESC, si.id DESC;

SELECT
  'CONFIRMED_STOCK_OUT_NO_JE' AS issue_type,
  so.id,
  so.code,
  so.date,
  so.total_amount
FROM stock_outs so
LEFT JOIN journal_entries je
  ON je.reference_type = 'stock_out' AND je.reference_id = so.id
WHERE so.status = 'confirmed'
  AND je.id IS NULL
ORDER BY so.date DESC, so.id DESC;

-- =========================================================
-- 4) Phieu chua xac nhan/da huy nhung van co but toan
-- =========================================================
SELECT
  'DRAFT_OR_CANCELLED_STOCK_IN_HAS_JE' AS issue_type,
  si.id,
  si.code,
  si.status,
  si.date,
  je.id AS journal_entry_id,
  je.code AS journal_code
FROM stock_ins si
JOIN journal_entries je
  ON je.reference_type = 'stock_in' AND je.reference_id = si.id
WHERE si.status IN ('draft', 'cancelled')
ORDER BY si.date DESC, si.id DESC;

SELECT
  'DRAFT_OR_CANCELLED_STOCK_OUT_HAS_JE' AS issue_type,
  so.id,
  so.code,
  so.status,
  so.date,
  je.id AS journal_entry_id,
  je.code AS journal_code
FROM stock_outs so
JOIN journal_entries je
  ON je.reference_type = 'stock_out' AND je.reference_id = so.id
WHERE so.status IN ('draft', 'cancelled')
ORDER BY so.date DESC, so.id DESC;

-- =========================================================
-- 5) Trung but toan cho cung chung tu nguon
-- =========================================================
SELECT
  'DUPLICATE_JE_BY_REFERENCE' AS issue_type,
  je.reference_type,
  je.reference_id,
  COUNT(*) AS journal_count,
  STRING_AGG(je.code, ', ' ORDER BY je.id) AS journal_codes
FROM journal_entries je
WHERE je.reference_type IN ('stock_in', 'stock_out', 'debt_payment')
  AND je.reference_id IS NOT NULL
GROUP BY je.reference_type, je.reference_id
HAVING COUNT(*) > 1
ORDER BY journal_count DESC, je.reference_type, je.reference_id;

-- Chi tinh but toan goc (bo qua code -REV) de tranh false positive do dao but toan.
SELECT
  'DUPLICATE_PRIMARY_JE_BY_REFERENCE' AS issue_type,
  je.reference_type,
  je.reference_id,
  COUNT(*) AS journal_count,
  STRING_AGG(je.code, ', ' ORDER BY je.id) AS journal_codes
FROM journal_entries je
WHERE je.reference_type IN ('stock_in', 'stock_out', 'debt_payment')
  AND je.reference_id IS NOT NULL
  AND je.code NOT LIKE '%-REV'
GROUP BY je.reference_type, je.reference_id
HAVING COUNT(*) > 1
ORDER BY journal_count DESC, je.reference_type, je.reference_id;

-- =========================================================
-- 6) Cong no lech so voi thanh toan thuc te
--    balance phai = amount - SUM(payment.amount)
-- =========================================================
WITH pay_sum AS (
  SELECT debt_id, SUM(COALESCE(amount, 0)) AS paid
  FROM debt_payments
  GROUP BY debt_id
)
SELECT
  'DEBT_BALANCE_MISMATCH' AS issue_type,
  d.id,
  d.reference_type,
  d.reference_id,
  d.reference_code,
  d.amount,
  d.paid_amount,
  COALESCE(ps.paid, 0) AS paid_by_payments,
  d.balance,
  (COALESCE(d.amount, 0) - COALESCE(ps.paid, 0)) AS expected_balance
FROM debts d
LEFT JOIN pay_sum ps ON ps.debt_id = d.id
WHERE COALESCE(d.balance, 0) <> (COALESCE(d.amount, 0) - COALESCE(ps.paid, 0))
ORDER BY d.id DESC;

-- =========================================================
-- 7) Cong no tham chieu chung tu chua confirmed
-- =========================================================
SELECT
  'DEBT_REF_STOCK_IN_NOT_CONFIRMED' AS issue_type,
  d.id AS debt_id,
  d.reference_code,
  si.id AS stock_in_id,
  si.status
FROM debts d
JOIN stock_ins si
  ON d.reference_type = 'stock_in' AND d.reference_id = si.id
WHERE si.status <> 'confirmed'
ORDER BY d.id DESC;

SELECT
  'DEBT_REF_STOCK_OUT_NOT_CONFIRMED' AS issue_type,
  d.id AS debt_id,
  d.reference_code,
  so.id AS stock_out_id,
  so.status
FROM debts d
JOIN stock_outs so
  ON d.reference_type = 'stock_out' AND d.reference_id = so.id
WHERE so.status <> 'confirmed'
ORDER BY d.id DESC;

-- =========================================================
-- 8) VAT record lech so voi chung tu goc
-- =========================================================
SELECT
  'VAT_INPUT_MISMATCH_STOCK_IN' AS issue_type,
  vr.id AS vat_id,
  vr.reference_code,
  vr.vat_amount AS vat_record_amount,
  si.vat_amount AS stock_in_vat_amount,
  vr.total_amount AS vat_record_total,
  si.total_amount AS stock_in_total
FROM vat_records vr
JOIN stock_ins si
  ON vr.reference_type = 'stock_in' AND vr.reference_id = si.id
WHERE COALESCE(vr.vat_amount, 0) <> COALESCE(si.vat_amount, 0)
   OR COALESCE(vr.total_amount, 0) <> COALESCE(si.total_amount, 0)
ORDER BY vr.id DESC;

SELECT
  'VAT_OUTPUT_MISMATCH_STOCK_OUT' AS issue_type,
  vr.id AS vat_id,
  vr.reference_code,
  vr.vat_amount AS vat_record_amount,
  so.vat_amount AS stock_out_vat_amount,
  vr.total_amount AS vat_record_total,
  so.total_amount AS stock_out_total
FROM vat_records vr
JOIN stock_outs so
  ON vr.reference_type = 'stock_out' AND vr.reference_id = so.id
WHERE COALESCE(vr.vat_amount, 0) <> COALESCE(so.vat_amount, 0)
   OR COALESCE(vr.total_amount, 0) <> COALESCE(so.total_amount, 0)
ORDER BY vr.id DESC;

-- =========================================================
-- 9) Dashboard nhanh: so luong loi theo nhom
-- =========================================================
WITH
  je_unbalanced AS (
    SELECT COUNT(*) AS c
    FROM journal_entries
    WHERE COALESCE(total_debit, 0) <> COALESCE(total_credit, 0)
  ),
  confirmed_no_je AS (
    SELECT
      (SELECT COUNT(*) FROM stock_ins si
       LEFT JOIN journal_entries je ON je.reference_type='stock_in' AND je.reference_id=si.id
       WHERE si.status='confirmed' AND je.id IS NULL)
      +
      (SELECT COUNT(*) FROM stock_outs so
       LEFT JOIN journal_entries je ON je.reference_type='stock_out' AND je.reference_id=so.id
       WHERE so.status='confirmed' AND je.id IS NULL) AS c
  ),
  duplicate_je AS (
    SELECT COUNT(*) AS c
    FROM (
      SELECT reference_type, reference_id
      FROM journal_entries
      WHERE reference_type IN ('stock_in','stock_out','debt_payment')
        AND reference_id IS NOT NULL
        AND code NOT LIKE '%-REV'
      GROUP BY reference_type, reference_id
      HAVING COUNT(*) > 1
    ) x
  ),
  debt_mismatch AS (
    SELECT COUNT(*) AS c
    FROM debts d
    LEFT JOIN (
      SELECT debt_id, SUM(COALESCE(amount,0)) AS paid
      FROM debt_payments
      GROUP BY debt_id
    ) ps ON ps.debt_id = d.id
    WHERE COALESCE(d.balance,0) <> (COALESCE(d.amount,0)-COALESCE(ps.paid,0))
  )
SELECT 'JE_UNBALANCED' AS check_name, c FROM je_unbalanced
UNION ALL
SELECT 'CONFIRMED_NO_JE', c FROM confirmed_no_je
UNION ALL
SELECT 'DUPLICATE_JE', c FROM duplicate_je
UNION ALL
SELECT 'DEBT_BALANCE_MISMATCH', c FROM debt_mismatch;

