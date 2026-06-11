-- 기존 테이블에 품목 순번 컬럼 추가 및 유니크키 재정의
-- 주의: 운영 반영 전 백업/점검 후 실행

ALTER TABLE ht_bill_power_plant_recipient_contract
  ADD COLUMN item_no INT NOT NULL DEFAULT 1 COMMENT '품목 순번(동일 계약내 N건)' AFTER contract_year;

ALTER TABLE ht_bill_power_plant_recipient_contract
  DROP INDEX uk_ht_bill_pp_rcpt_year,
  ADD UNIQUE KEY uk_ht_bill_pp_rcpt_year_item (power_plant_id, recipient_id, contract_year, item_no);
