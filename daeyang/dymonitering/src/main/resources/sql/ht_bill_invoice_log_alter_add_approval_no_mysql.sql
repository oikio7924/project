-- 국세청 전자세금계산서 승인번호(전송 성공 후 저장)
-- 예: 20260223-10260223-46084667 형식

ALTER TABLE ht_bill_invoice_log
  ADD COLUMN approval_no VARCHAR(64) NULL COMMENT '국세청 승인번호(전자세금계산서)' AFTER document_no;
