BEGIN;

-- Preview current values before normalization
-- SELECT 'stock_ins' AS table_name, status, COUNT(*) FROM stock_ins GROUP BY status ORDER BY status;
-- SELECT 'stock_outs' AS table_name, status, COUNT(*) FROM stock_outs GROUP BY status ORDER BY status;
-- SELECT 'debts' AS table_name, status, COUNT(*) FROM debts GROUP BY status ORDER BY status;

-- Normalize stock-in status
UPDATE stock_ins
SET status = CASE
    WHEN status IS NULL OR btrim(status) = '' THEN 'draft'
    WHEN lower(status) IN ('draft', 'nhap', 'nháp', 'nhap moi') THEN 'draft'
    WHEN lower(status) IN ('confirmed', 'xác nhận', 'xac nhan', 'đã xác nhận', 'da xac nhan', 'nhập') THEN 'confirmed'
    WHEN lower(status) IN ('cancelled', 'cancel', 'đã hủy', 'da huy', 'hủy', 'huy') THEN 'cancelled'
    ELSE lower(status)
END
WHERE status IS DISTINCT FROM CASE
    WHEN status IS NULL OR btrim(status) = '' THEN 'draft'
    WHEN lower(status) IN ('draft', 'nhap', 'nháp', 'nhap moi') THEN 'draft'
    WHEN lower(status) IN ('confirmed', 'xác nhận', 'xac nhan', 'đã xác nhận', 'da xac nhan', 'nhập') THEN 'confirmed'
    WHEN lower(status) IN ('cancelled', 'cancel', 'đã hủy', 'da huy', 'hủy', 'huy') THEN 'cancelled'
    ELSE lower(status)
END;

-- Normalize stock-out status
UPDATE stock_outs
SET status = CASE
    WHEN status IS NULL OR btrim(status) = '' THEN 'draft'
    WHEN lower(status) IN ('draft', 'nhap', 'nháp', 'nhap moi') THEN 'draft'
    WHEN lower(status) IN ('confirmed', 'xác nhận', 'xac nhan', 'đã xác nhận', 'da xac nhan', 'xuất', 'xuat') THEN 'confirmed'
    WHEN lower(status) IN ('cancelled', 'cancel', 'đã hủy', 'da huy', 'hủy', 'huy') THEN 'cancelled'
    ELSE lower(status)
END
WHERE status IS DISTINCT FROM CASE
    WHEN status IS NULL OR btrim(status) = '' THEN 'draft'
    WHEN lower(status) IN ('draft', 'nhap', 'nháp', 'nhap moi') THEN 'draft'
    WHEN lower(status) IN ('confirmed', 'xác nhận', 'xac nhan', 'đã xác nhận', 'da xac nhan', 'xuất', 'xuat') THEN 'confirmed'
    WHEN lower(status) IN ('cancelled', 'cancel', 'đã hủy', 'da huy', 'hủy', 'huy') THEN 'cancelled'
    ELSE lower(status)
END;

-- Normalize debt status
UPDATE debts
SET status = CASE
    WHEN status IS NULL OR btrim(status) = '' THEN 'open'
    WHEN lower(status) IN ('open', 'phải thu', 'phai thu', 'phải trả', 'phai tra', 'mở', 'mo') THEN 'open'
    WHEN lower(status) IN ('partial', 'một phần', 'mot phan') THEN 'partial'
    WHEN lower(status) IN ('paid', 'đã thanh toán', 'da thanh toan') THEN 'paid'
    WHEN lower(status) IN ('overdue', 'quá hạn', 'qua han') THEN 'overdue'
    ELSE lower(status)
END
WHERE status IS DISTINCT FROM CASE
    WHEN status IS NULL OR btrim(status) = '' THEN 'open'
    WHEN lower(status) IN ('open', 'phải thu', 'phai thu', 'phải trả', 'phai tra', 'mở', 'mo') THEN 'open'
    WHEN lower(status) IN ('partial', 'một phần', 'mot phan') THEN 'partial'
    WHEN lower(status) IN ('paid', 'đã thanh toán', 'da thanh toan') THEN 'paid'
    WHEN lower(status) IN ('overdue', 'quá hạn', 'qua han') THEN 'overdue'
    ELSE lower(status)
END;

-- Recompute debt status from amount / balance / due_date after normalization
UPDATE debts
SET status = CASE
    WHEN COALESCE(balance, 0) <= 0 THEN 'paid'
    WHEN due_date IS NOT NULL AND due_date < CURRENT_DATE THEN 'overdue'
    WHEN COALESCE(balance, 0) < COALESCE(amount, 0) THEN 'partial'
    ELSE 'open'
END;

COMMIT;

-- Verify after normalization
-- SELECT 'stock_ins' AS table_name, status, COUNT(*) FROM stock_ins GROUP BY status ORDER BY status;
-- SELECT 'stock_outs' AS table_name, status, COUNT(*) FROM stock_outs GROUP BY status ORDER BY status;
-- SELECT 'debts' AS table_name, status, COUNT(*) FROM debts GROUP BY status ORDER BY status;
