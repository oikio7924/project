-- ht_bill_recipient 확장: 발행담당자 이메일 분리
-- contact_email이 이미 있으면 실행하지 마세요.

ALTER TABLE ht_bill_recipient
  ADD COLUMN contact_email VARCHAR(200) NULL AFTER contact_phone;

