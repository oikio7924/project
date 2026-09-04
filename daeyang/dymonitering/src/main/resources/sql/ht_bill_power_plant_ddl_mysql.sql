-- ht_bill_power_plant: 발전소(계약자) 마스터 (HT 전용)
-- 주의: 기존 테이블이 있을 수 있으니 먼저 확인 후 실행하세요.

CREATE TABLE ht_bill_power_plant (
  id                    INT             NOT NULL AUTO_INCREMENT COMMENT 'PK',
  -- 회원유형/계약자 유형 등 (원하시는 값에 맞춰 사용)
  member_type          VARCHAR(30)    NULL COMMENT '회원유형(분류용)',

  -- 사업자/개인 구분 (발전소 계약자가 사업자/개인인 경우)
  party_type            CHAR(2)        NOT NULL DEFAULT '01' COMMENT '01=사업자 02=개인',
  -- 사업자일 때 추가 구분
  biz_owner_type        CHAR(1)        NULL COMMENT '사업자구분: P=개인사업자, C=법인사업자 (party_type=01에서 사용)',

  corp_name            VARCHAR(100)   NULL COMMENT '상호명(사업자) 또는 성명(개인)',
  ceo_name             VARCHAR(50)    NULL COMMENT '대표자(사업자)',
  corp_num             VARCHAR(20)    NULL COMMENT '사업자등록번호(사업자)',
  biz_type             VARCHAR(50)    NULL COMMENT '업태',
  biz_classification   VARCHAR(50)    NULL COMMENT '업종',
  id_num               VARCHAR(20)    NULL COMMENT '주민등록번호(개인)',

  mobile_phone         VARCHAR(30)    NULL COMMENT '휴대전화',
  address              VARCHAR(200)   NULL COMMENT '주소',
  email                VARCHAR(100)   NULL COMMENT '이메일',

  -- 결제방식/계약정보(텍스트로 스냅샷 저장)
  payment_method       VARCHAR(20)    NULL COMMENT '결제방식: AUTO(자동이체) / DIRECT(직접이체)',
  biz_license_file     VARCHAR(255)   NULL COMMENT '사업자등록증 PDF 저장 파일명',
  contract_info        TEXT           NULL COMMENT '계약정보(요약/스냅샷)',
  contract_detail      TEXT           NULL COMMENT '계약상세(스냅샷)',
  monitoring            TEXT           NULL COMMENT '모니터링(스냅샷)',
  memo                  TEXT           NULL COMMENT '메모',

  use_yn               CHAR(1)        NOT NULL DEFAULT 'Y' COMMENT '사용여부 Y/N',
  created_at           DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           DATETIME       NULL ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  KEY idx_ht_bill_power_plant_use (use_yn),
  KEY idx_ht_bill_power_plant_party_type (party_type),
  KEY idx_ht_bill_power_plant_biz_owner_type (biz_owner_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='bill 발전소(계약자) 마스터(HT)';

