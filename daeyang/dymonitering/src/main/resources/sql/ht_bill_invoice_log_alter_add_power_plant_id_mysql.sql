-- ht_bill_invoice_log에 power_plant_id를 추가
-- 월별 O 계산을 발전소 기준으로 하기 위해 필요합니다.

ALTER TABLE ht_bill_invoice_log
  ADD COLUMN power_plant_id INT NULL COMMENT '발전소 ht_bill_power_plant.id (월별 O 계산용)';

CREATE INDEX idx_ht_bill_invoice_log_power_plant_id
  ON ht_bill_invoice_log (power_plant_id);

