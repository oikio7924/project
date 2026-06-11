-- 기존 ht_bill_power_plant에 업태/업종 컬럼 추가 (계약자 화면 저장 반영용)
-- 이미 컬럼이 있으면 실행 전에 확인하세요.

ALTER TABLE ht_bill_power_plant
  ADD COLUMN biz_type VARCHAR(50) NULL COMMENT '업태' AFTER corp_num,
  ADD COLUMN biz_classification VARCHAR(50) NULL COMMENT '업종' AFTER biz_type;
