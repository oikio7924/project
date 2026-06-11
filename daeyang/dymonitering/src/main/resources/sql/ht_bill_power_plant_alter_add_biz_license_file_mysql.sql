ALTER TABLE ht_bill_power_plant
  ADD COLUMN biz_license_file VARCHAR(255) NULL COMMENT '사업자등록증 PDF 저장 파일명' AFTER payment_method;
