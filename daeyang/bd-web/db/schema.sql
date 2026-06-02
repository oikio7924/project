-- 태양광 발전소 인허가 일정관리 스키마
-- 실행 예시: mysql -u계정 -p DB명 < db/schema.sql
--
-- 테이블 prefix: bdm_ (Biz Dev Management)
-- 데이터베이스: monitoring (세금계산서와 동일 DB 공유)
-- 서버 포트: 3001

-- ─────────────────────────────────────────────
-- 발전소 인허가 정보
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS bdm_plants (
  id                          INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '발전소 ID',

  -- 기본 정보
  plant_name                  VARCHAR(255) NOT NULL                  COMMENT '발전소 명',
  owner_name                  VARCHAR(255) NOT NULL DEFAULT ''       COMMENT '사업자 명',
  contact                     VARCHAR(100) NOT NULL DEFAULT ''       COMMENT '연락처',
  address                     VARCHAR(500) NOT NULL DEFAULT ''       COMMENT '소재지',
  capacity                    VARCHAR(100) NOT NULL DEFAULT ''       COMMENT '용량 (예: 999kW)',
  install_type                VARCHAR(100) NOT NULL DEFAULT ''       COMMENT '설치형태 (지상형/건물형/수상형 등)',
  memo                        TEXT                  NULL             COMMENT '메모',

  -- 발전사업 인허가
  power_biz_permit_scheduled  DATE          NULL                     COMMENT '발전사업허가예정일',
  power_biz_permit_date       DATE          NULL                     COMMENT '발전사업허가일',
  power_biz_permit_expire     DATE          NULL                     COMMENT '발전사업만료일',

  -- 개발행위 인허가
  dev_permit_date             DATE          NULL                     COMMENT '개발행위허가일',
  dev_permit_expire           DATE          NULL                     COMMENT '개발행위만료일',

  -- PPA (전력구매계약)
  ppa_receive_date            DATE          NULL                     COMMENT 'PPA 접수일',
  ppa_receive_capacity        VARCHAR(100) NOT NULL DEFAULT ''       COMMENT 'PPA 접수용량',

  -- 준공 및 운전
  dev_completion_date         DATE          NULL                     COMMENT '개발행위준공일',
  commercial_operation_date   DATE          NULL                     COMMENT '상업운전개시일',

  -- 메타
  created_at                  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP            COMMENT '등록일시',
  updated_at                  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
                                           ON UPDATE CURRENT_TIMESTAMP                  COMMENT '수정일시',

  -- 인덱스 (만료일 기준 조회 빈도 높음)
  INDEX idx_bdm_power_expire  (power_biz_permit_expire),
  INDEX idx_bdm_dev_expire    (dev_permit_expire),
  INDEX idx_bdm_plant_name    (plant_name),
  INDEX idx_bdm_created       (created_at)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='태양광 발전소 인허가 정보';
