-- ht_bill_power_plant_recipient_contract: 발전소-공급받는자 계약금액(연도별)
-- HT 전용. (발전소가 여러 개일 수 있으므로 power_plant_id 포함)

CREATE TABLE ht_bill_power_plant_recipient_contract (
  id                    INT             NOT NULL AUTO_INCREMENT COMMENT 'PK',
  power_plant_id       INT             NOT NULL COMMENT 'ht_bill_power_plant.id',
  recipient_id         INT             NOT NULL COMMENT 'ht_bill_recipient.id',
  contract_year        INT             NOT NULL COMMENT '계약 연도(예: 2026)',
  item_no              INT             NOT NULL DEFAULT 1 COMMENT '품목 순번(동일 계약내 N건)',

  -- 금액(공급가/세액/합계) - 사용자가 수정하는 값
  supply_total         DECIMAL(15,0)  NOT NULL DEFAULT 0 COMMENT '공급가액',
  tax_total            DECIMAL(15,0)  NOT NULL DEFAULT 0 COMMENT '세액',
  grand_total          DECIMAL(15,0)  NOT NULL DEFAULT 0 COMMENT '합계금액',
  item_name            VARCHAR(255)   NULL COMMENT '품목명',

  use_yn                CHAR(1)        NOT NULL DEFAULT 'Y' COMMENT '사용여부 Y/N',
  memo                   TEXT           NULL COMMENT '계약 메모(선택)',

  created_at            DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME       NULL ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE KEY uk_ht_bill_pp_rcpt_year_item (power_plant_id, recipient_id, contract_year, item_no),
  KEY idx_ht_bill_pp_rcpt (power_plant_id, contract_year),
  KEY idx_ht_bill_rcpt (recipient_id, contract_year)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='bill 발전소-공급받는자 계약금액(연도별)';

