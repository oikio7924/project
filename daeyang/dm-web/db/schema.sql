-- ============================================================
--  dmweb 데이터베이스 스키마  (dm_ 접두사 통일)
--  적용: mysql -u root -p dmweb < db/schema.sql
-- ============================================================
SET NAMES utf8mb4;

-- ── 발전소 ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dm_plant (
  id              INT UNSIGNED    NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name            VARCHAR(255)    NOT NULL DEFAULT ''  COMMENT '발전소명',
  region          VARCHAR(100)    NOT NULL DEFAULT ''  COMMENT '지역',
  address         VARCHAR(500)    NOT NULL DEFAULT ''  COMMENT '주소',
  lat             DECIMAL(11,7)   NULL                 COMMENT '위도',
  lng             DECIMAL(11,7)   NULL                 COMMENT '경도',
  capacity_kw     DECIMAL(12,2)   NOT NULL DEFAULT 0   COMMENT '설비용량(kW)',
  inverter_count  INT UNSIGNED    NOT NULL DEFAULT 0   COMMENT '인버터 수',
  inv_brand       VARCHAR(100)    NOT NULL DEFAULT ''  COMMENT '인버터 브랜드',
  brand           VARCHAR(100)    NOT NULL DEFAULT ''  COMMENT '제조사',
  model           VARCHAR(100)    NOT NULL DEFAULT ''  COMMENT '모델',
  inverter_sn     VARCHAR(100)    NOT NULL DEFAULT ''  COMMENT '인버터 시리얼번호',
  grid_status     CHAR(1)         NOT NULL DEFAULT 'N' COMMENT '계통연결 Y/N',
  owner_id        VARCHAR(20)     NULL                 COMMENT '소유자 (dm_user.id FK)',
  del_yn          CHAR(1)         NOT NULL DEFAULT 'N' COMMENT '삭제여부 Y/N',
  registered_at   DATETIME        NULL                 COMMENT '등록일',
  INDEX idx_dm_plant_region (region),
  INDEX idx_dm_plant_del    (del_yn)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='발전소';

-- ── 인버터 실시간 수집 데이터 ────────────────────────────────
-- 당일: 10분 간격 전체 데이터
-- 전일 이전: 인버터별 하루 1건 (그날 마지막 수신값만 유지)
-- 자정 처리: 전날 raw 전체 → dm_inverter_detail 이동 후 최신값 1건씩만 남김
CREATE TABLE IF NOT EXISTS dm_inverter_data (
  id                    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  site_id               VARCHAR(100)    NOT NULL DEFAULT ''                  COMMENT '발전소키 (dm_plant.id)',
  inverter_name         VARCHAR(100)    NOT NULL DEFAULT ''                  COMMENT '인버터명',
  collected_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP   COMMENT '수집시각',

  active_power          FLOAT           NULL                                 COMMENT '유효전력(kW)',
  daily_gen             VARCHAR(100)    NULL                                 COMMENT '일발전량(kWh)',
  cumulative_gen        VARCHAR(100)    NULL                                 COMMENT '누적발전량(kWh)',
  total_gen_hour        VARCHAR(100)    NULL                                 COMMENT '총 발전시간',

  work_mode             VARCHAR(100)    NULL                                 COMMENT '작업모드',
  grid_frequency        VARCHAR(100)    NULL                                 COMMENT '계통주파수',
  volt_ab               VARCHAR(100)    NULL                                 COMMENT 'A-B 선간전압',
  volt_bc               VARCHAR(100)    NULL                                 COMMENT 'B-C 선간전압',
  volt_ca               VARCHAR(100)    NULL                                 COMMENT 'C-A 선간전압',
  volt_a                VARCHAR(100)    NULL                                 COMMENT 'A상 전압',
  volt_b                VARCHAR(100)    NULL                                 COMMENT 'B상 전압',
  volt_c                VARCHAR(100)    NULL                                 COMMENT 'C상 전압',
  curr_a                VARCHAR(100)    NULL                                 COMMENT 'A상 전류',
  curr_b                VARCHAR(100)    NULL                                 COMMENT 'B상 전류',
  curr_c                VARCHAR(100)    NULL                                 COMMENT 'C상 전류',
  freq_a                VARCHAR(100)    NULL                                 COMMENT 'A상 주파수',
  freq_b                VARCHAR(100)    NULL                                 COMMENT 'B상 주파수',
  freq_c                VARCHAR(100)    NULL                                 COMMENT 'C상 주파수',

  vpv1  VARCHAR(100) NULL COMMENT 'PV1 전압',  ipv1  VARCHAR(100) NULL COMMENT 'PV1 전류',  ppv1  VARCHAR(100) NULL COMMENT 'PV1 전력',
  vpv2  VARCHAR(100) NULL COMMENT 'PV2 전압',  ipv2  VARCHAR(100) NULL COMMENT 'PV2 전류',  ppv2  VARCHAR(100) NULL COMMENT 'PV2 전력',
  vpv3  VARCHAR(100) NULL COMMENT 'PV3 전압',  ipv3  VARCHAR(100) NULL COMMENT 'PV3 전류',  ppv3  VARCHAR(100) NULL COMMENT 'PV3 전력',
  vpv4  VARCHAR(100) NULL COMMENT 'PV4 전압',  ipv4  VARCHAR(100) NULL COMMENT 'PV4 전류',  ppv4  VARCHAR(100) NULL COMMENT 'PV4 전력',
  vpv5  VARCHAR(100) NULL COMMENT 'PV5 전압',  ipv5  VARCHAR(100) NULL COMMENT 'PV5 전류',  ppv5  VARCHAR(100) NULL COMMENT 'PV5 전력',
  vpv6  VARCHAR(100) NULL COMMENT 'PV6 전압',  ipv6  VARCHAR(100) NULL COMMENT 'PV6 전류',  ppv6  VARCHAR(100) NULL COMMENT 'PV6 전력',
  vpv7  VARCHAR(100) NULL COMMENT 'PV7 전압',  ipv7  VARCHAR(100) NULL COMMENT 'PV7 전류',  ppv7  VARCHAR(100) NULL COMMENT 'PV7 전력',
  vpv8  VARCHAR(100) NULL COMMENT 'PV8 전압',  ipv8  VARCHAR(100) NULL COMMENT 'PV8 전류',  ppv8  VARCHAR(100) NULL COMMENT 'PV8 전력',
  vpv9  VARCHAR(100) NULL COMMENT 'PV9 전압',  ipv9  VARCHAR(100) NULL COMMENT 'PV9 전류',  ppv9  VARCHAR(100) NULL COMMENT 'PV9 전력',
  vpv10 VARCHAR(100) NULL COMMENT 'PV10 전압', ipv10 VARCHAR(100) NULL COMMENT 'PV10 전류', ppv10 VARCHAR(100) NULL COMMENT 'PV10 전력',
  vpv11 VARCHAR(100) NULL COMMENT 'PV11 전압', ipv11 VARCHAR(100) NULL COMMENT 'PV11 전류', ppv11 VARCHAR(100) NULL COMMENT 'PV11 전력',
  vpv12 VARCHAR(100) NULL COMMENT 'PV12 전압', ipv12 VARCHAR(100) NULL COMMENT 'PV12 전류', ppv12 VARCHAR(100) NULL COMMENT 'PV12 전력',
  vpv13 VARCHAR(100) NULL COMMENT 'PV13 전압', ipv13 VARCHAR(100) NULL COMMENT 'PV13 전류', ppv13 VARCHAR(100) NULL COMMENT 'PV13 전력',
  vpv14 VARCHAR(100) NULL COMMENT 'PV14 전압', ipv14 VARCHAR(100) NULL COMMENT 'PV14 전류', ppv14 VARCHAR(100) NULL COMMENT 'PV14 전력',
  vpv15 VARCHAR(100) NULL COMMENT 'PV15 전압', ipv15 VARCHAR(100) NULL COMMENT 'PV15 전류', ppv15 VARCHAR(100) NULL COMMENT 'PV15 전력',
  vpv16 VARCHAR(100) NULL COMMENT 'PV16 전압', ipv16 VARCHAR(100) NULL COMMENT 'PV16 전류', ppv16 VARCHAR(100) NULL COMMENT 'PV16 전력',
  vpv17 VARCHAR(100) NULL COMMENT 'PV17 전압', ipv17 VARCHAR(100) NULL COMMENT 'PV17 전류', ppv17 VARCHAR(100) NULL COMMENT 'PV17 전력',
  vpv18 VARCHAR(100) NULL COMMENT 'PV18 전압', ipv18 VARCHAR(100) NULL COMMENT 'PV18 전류', ppv18 VARCHAR(100) NULL COMMENT 'PV18 전력',
  vpv19 VARCHAR(100) NULL COMMENT 'PV19 전압', ipv19 VARCHAR(100) NULL COMMENT 'PV19 전류', ppv19 VARCHAR(100) NULL COMMENT 'PV19 전력',
  vpv20 VARCHAR(100) NULL COMMENT 'PV20 전압', ipv20 VARCHAR(100) NULL COMMENT 'PV20 전류', ppv20 VARCHAR(100) NULL COMMENT 'PV20 전력',
  vpv21 VARCHAR(100) NULL COMMENT 'PV21 전압', ipv21 VARCHAR(100) NULL COMMENT 'PV21 전류', ppv21 VARCHAR(100) NULL COMMENT 'PV21 전력',
  vpv22 VARCHAR(100) NULL COMMENT 'PV22 전압', ipv22 VARCHAR(100) NULL COMMENT 'PV22 전류', ppv22 VARCHAR(100) NULL COMMENT 'PV22 전력',
  vpv23 VARCHAR(100) NULL COMMENT 'PV23 전압', ipv23 VARCHAR(100) NULL COMMENT 'PV23 전류', ppv23 VARCHAR(100) NULL COMMENT 'PV23 전력',
  vpv24 VARCHAR(100) NULL COMMENT 'PV24 전압', ipv24 VARCHAR(100) NULL COMMENT 'PV24 전류', ppv24 VARCHAR(100) NULL COMMENT 'PV24 전력',

  istr1  VARCHAR(100) NULL COMMENT '스트링1 전류',  istr2  VARCHAR(100) NULL COMMENT '스트링2 전류',
  istr3  VARCHAR(100) NULL COMMENT '스트링3 전류',  istr4  VARCHAR(100) NULL COMMENT '스트링4 전류',
  istr5  VARCHAR(100) NULL COMMENT '스트링5 전류',  istr6  VARCHAR(100) NULL COMMENT '스트링6 전류',
  istr7  VARCHAR(100) NULL COMMENT '스트링7 전류',  istr8  VARCHAR(100) NULL COMMENT '스트링8 전류',
  istr9  VARCHAR(100) NULL COMMENT '스트링9 전류',  istr10 VARCHAR(100) NULL COMMENT '스트링10 전류',
  istr11 VARCHAR(100) NULL COMMENT '스트링11 전류', istr12 VARCHAR(100) NULL COMMENT '스트링12 전류',
  istr13 VARCHAR(100) NULL COMMENT '스트링13 전류', istr14 VARCHAR(100) NULL COMMENT '스트링14 전류',
  istr15 VARCHAR(100) NULL COMMENT '스트링15 전류', istr16 VARCHAR(100) NULL COMMENT '스트링16 전류',
  istr17 VARCHAR(100) NULL COMMENT '스트링17 전류', istr18 VARCHAR(100) NULL COMMENT '스트링18 전류',
  istr19 VARCHAR(100) NULL COMMENT '스트링19 전류', istr20 VARCHAR(100) NULL COMMENT '스트링20 전류',
  istr21 VARCHAR(100) NULL COMMENT '스트링21 전류', istr22 VARCHAR(100) NULL COMMENT '스트링22 전류',
  istr23 VARCHAR(100) NULL COMMENT '스트링23 전류', istr24 VARCHAR(100) NULL COMMENT '스트링24 전류',

  temperature           VARCHAR(100)    NULL                                 COMMENT '내부온도',
  cabinet_temp          VARCHAR(100)    NULL                                 COMMENT '내각온도',

  dsp_error             VARCHAR(1000)   NULL                                 COMMENT 'DSP 에러코드',
  dsp_alarm             VARCHAR(100)    NULL                                 COMMENT 'DSP 알람코드',
  slave_dsp_error       VARCHAR(100)    NULL                                 COMMENT '하위 DSP 에러코드',
  slave_dsp_alarm       VARCHAR(100)    NULL                                 COMMENT '하위 DSP 알람코드',
  pv_string_fault       VARCHAR(100)    NULL                                 COMMENT 'PV 오류 비트',
  temp_fault            VARCHAR(100)    NULL                                 COMMENT '온도 오류 비트',
  safety_code           VARCHAR(100)    NULL                                 COMMENT '안전 코드',

  phase_type            VARCHAR(100)    NULL                                 COMMENT '상 구성',
  power_capacity        VARCHAR(100)    NULL                                 COMMENT '정격 용량',
  rated_line_voltage    VARCHAR(100)    NULL                                 COMMENT '정격 선간전압',

  INDEX idx_dm_inv_data_site_date (site_id, collected_at),
  INDEX idx_dm_inv_data_name_date (inverter_name, collected_at),
  INDEX idx_dm_inv_data_keyno     (site_id, inverter_name, collected_at),
  INDEX idx_dm_inv_data_power     (active_power)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='인버터 실시간 수집 데이터';

-- ── 인버터 전체 이력 데이터 ──────────────────────────────────
-- 전일 이전의 모든 raw 10분 간격 데이터 보관
-- 자정 처리 시 dm_inverter_data에서 이동되어 누적됨
CREATE TABLE IF NOT EXISTS dm_inverter_detail (
  id                    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  site_id               VARCHAR(100)    NOT NULL DEFAULT ''                  COMMENT '발전소키 (dm_plant.id)',
  inverter_name         VARCHAR(100)    NOT NULL DEFAULT ''                  COMMENT '인버터명',
  collected_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP   COMMENT '수집시각',

  active_power          FLOAT           NULL                                 COMMENT '유효전력(kW)',
  daily_gen             VARCHAR(100)    NULL                                 COMMENT '일발전량(kWh)',
  cumulative_gen        VARCHAR(100)    NULL                                 COMMENT '누적발전량(kWh)',
  total_gen_hour        VARCHAR(100)    NULL                                 COMMENT '총 발전시간',

  work_mode             VARCHAR(100)    NULL                                 COMMENT '작업모드',
  grid_frequency        VARCHAR(100)    NULL                                 COMMENT '계통주파수',
  volt_ab               VARCHAR(100)    NULL                                 COMMENT 'A-B 선간전압',
  volt_bc               VARCHAR(100)    NULL                                 COMMENT 'B-C 선간전압',
  volt_ca               VARCHAR(100)    NULL                                 COMMENT 'C-A 선간전압',
  volt_a                VARCHAR(100)    NULL                                 COMMENT 'A상 전압',
  volt_b                VARCHAR(100)    NULL                                 COMMENT 'B상 전압',
  volt_c                VARCHAR(100)    NULL                                 COMMENT 'C상 전압',
  curr_a                VARCHAR(100)    NULL                                 COMMENT 'A상 전류',
  curr_b                VARCHAR(100)    NULL                                 COMMENT 'B상 전류',
  curr_c                VARCHAR(100)    NULL                                 COMMENT 'C상 전류',
  freq_a                VARCHAR(100)    NULL                                 COMMENT 'A상 주파수',
  freq_b                VARCHAR(100)    NULL                                 COMMENT 'B상 주파수',
  freq_c                VARCHAR(100)    NULL                                 COMMENT 'C상 주파수',

  vpv1  VARCHAR(100) NULL COMMENT 'PV1 전압',  ipv1  VARCHAR(100) NULL COMMENT 'PV1 전류',  ppv1  VARCHAR(100) NULL COMMENT 'PV1 전력',
  vpv2  VARCHAR(100) NULL COMMENT 'PV2 전압',  ipv2  VARCHAR(100) NULL COMMENT 'PV2 전류',  ppv2  VARCHAR(100) NULL COMMENT 'PV2 전력',
  vpv3  VARCHAR(100) NULL COMMENT 'PV3 전압',  ipv3  VARCHAR(100) NULL COMMENT 'PV3 전류',  ppv3  VARCHAR(100) NULL COMMENT 'PV3 전력',
  vpv4  VARCHAR(100) NULL COMMENT 'PV4 전압',  ipv4  VARCHAR(100) NULL COMMENT 'PV4 전류',  ppv4  VARCHAR(100) NULL COMMENT 'PV4 전력',
  vpv5  VARCHAR(100) NULL COMMENT 'PV5 전압',  ipv5  VARCHAR(100) NULL COMMENT 'PV5 전류',  ppv5  VARCHAR(100) NULL COMMENT 'PV5 전력',
  vpv6  VARCHAR(100) NULL COMMENT 'PV6 전압',  ipv6  VARCHAR(100) NULL COMMENT 'PV6 전류',  ppv6  VARCHAR(100) NULL COMMENT 'PV6 전력',
  vpv7  VARCHAR(100) NULL COMMENT 'PV7 전압',  ipv7  VARCHAR(100) NULL COMMENT 'PV7 전류',  ppv7  VARCHAR(100) NULL COMMENT 'PV7 전력',
  vpv8  VARCHAR(100) NULL COMMENT 'PV8 전압',  ipv8  VARCHAR(100) NULL COMMENT 'PV8 전류',  ppv8  VARCHAR(100) NULL COMMENT 'PV8 전력',
  vpv9  VARCHAR(100) NULL COMMENT 'PV9 전압',  ipv9  VARCHAR(100) NULL COMMENT 'PV9 전류',  ppv9  VARCHAR(100) NULL COMMENT 'PV9 전력',
  vpv10 VARCHAR(100) NULL COMMENT 'PV10 전압', ipv10 VARCHAR(100) NULL COMMENT 'PV10 전류', ppv10 VARCHAR(100) NULL COMMENT 'PV10 전력',
  vpv11 VARCHAR(100) NULL COMMENT 'PV11 전압', ipv11 VARCHAR(100) NULL COMMENT 'PV11 전류', ppv11 VARCHAR(100) NULL COMMENT 'PV11 전력',
  vpv12 VARCHAR(100) NULL COMMENT 'PV12 전압', ipv12 VARCHAR(100) NULL COMMENT 'PV12 전류', ppv12 VARCHAR(100) NULL COMMENT 'PV12 전력',
  vpv13 VARCHAR(100) NULL COMMENT 'PV13 전압', ipv13 VARCHAR(100) NULL COMMENT 'PV13 전류', ppv13 VARCHAR(100) NULL COMMENT 'PV13 전력',
  vpv14 VARCHAR(100) NULL COMMENT 'PV14 전압', ipv14 VARCHAR(100) NULL COMMENT 'PV14 전류', ppv14 VARCHAR(100) NULL COMMENT 'PV14 전력',
  vpv15 VARCHAR(100) NULL COMMENT 'PV15 전압', ipv15 VARCHAR(100) NULL COMMENT 'PV15 전류', ppv15 VARCHAR(100) NULL COMMENT 'PV15 전력',
  vpv16 VARCHAR(100) NULL COMMENT 'PV16 전압', ipv16 VARCHAR(100) NULL COMMENT 'PV16 전류', ppv16 VARCHAR(100) NULL COMMENT 'PV16 전력',
  vpv17 VARCHAR(100) NULL COMMENT 'PV17 전압', ipv17 VARCHAR(100) NULL COMMENT 'PV17 전류', ppv17 VARCHAR(100) NULL COMMENT 'PV17 전력',
  vpv18 VARCHAR(100) NULL COMMENT 'PV18 전압', ipv18 VARCHAR(100) NULL COMMENT 'PV18 전류', ppv18 VARCHAR(100) NULL COMMENT 'PV18 전력',
  vpv19 VARCHAR(100) NULL COMMENT 'PV19 전압', ipv19 VARCHAR(100) NULL COMMENT 'PV19 전류', ppv19 VARCHAR(100) NULL COMMENT 'PV19 전력',
  vpv20 VARCHAR(100) NULL COMMENT 'PV20 전압', ipv20 VARCHAR(100) NULL COMMENT 'PV20 전류', ppv20 VARCHAR(100) NULL COMMENT 'PV20 전력',
  vpv21 VARCHAR(100) NULL COMMENT 'PV21 전압', ipv21 VARCHAR(100) NULL COMMENT 'PV21 전류', ppv21 VARCHAR(100) NULL COMMENT 'PV21 전력',
  vpv22 VARCHAR(100) NULL COMMENT 'PV22 전압', ipv22 VARCHAR(100) NULL COMMENT 'PV22 전류', ppv22 VARCHAR(100) NULL COMMENT 'PV22 전력',
  vpv23 VARCHAR(100) NULL COMMENT 'PV23 전압', ipv23 VARCHAR(100) NULL COMMENT 'PV23 전류', ppv23 VARCHAR(100) NULL COMMENT 'PV23 전력',
  vpv24 VARCHAR(100) NULL COMMENT 'PV24 전압', ipv24 VARCHAR(100) NULL COMMENT 'PV24 전류', ppv24 VARCHAR(100) NULL COMMENT 'PV24 전력',

  istr1  VARCHAR(100) NULL COMMENT '스트링1 전류',  istr2  VARCHAR(100) NULL COMMENT '스트링2 전류',
  istr3  VARCHAR(100) NULL COMMENT '스트링3 전류',  istr4  VARCHAR(100) NULL COMMENT '스트링4 전류',
  istr5  VARCHAR(100) NULL COMMENT '스트링5 전류',  istr6  VARCHAR(100) NULL COMMENT '스트링6 전류',
  istr7  VARCHAR(100) NULL COMMENT '스트링7 전류',  istr8  VARCHAR(100) NULL COMMENT '스트링8 전류',
  istr9  VARCHAR(100) NULL COMMENT '스트링9 전류',  istr10 VARCHAR(100) NULL COMMENT '스트링10 전류',
  istr11 VARCHAR(100) NULL COMMENT '스트링11 전류', istr12 VARCHAR(100) NULL COMMENT '스트링12 전류',
  istr13 VARCHAR(100) NULL COMMENT '스트링13 전류', istr14 VARCHAR(100) NULL COMMENT '스트링14 전류',
  istr15 VARCHAR(100) NULL COMMENT '스트링15 전류', istr16 VARCHAR(100) NULL COMMENT '스트링16 전류',
  istr17 VARCHAR(100) NULL COMMENT '스트링17 전류', istr18 VARCHAR(100) NULL COMMENT '스트링18 전류',
  istr19 VARCHAR(100) NULL COMMENT '스트링19 전류', istr20 VARCHAR(100) NULL COMMENT '스트링20 전류',
  istr21 VARCHAR(100) NULL COMMENT '스트링21 전류', istr22 VARCHAR(100) NULL COMMENT '스트링22 전류',
  istr23 VARCHAR(100) NULL COMMENT '스트링23 전류', istr24 VARCHAR(100) NULL COMMENT '스트링24 전류',

  temperature           VARCHAR(100)    NULL                                 COMMENT '내부온도',
  cabinet_temp          VARCHAR(100)    NULL                                 COMMENT '내각온도',

  dsp_error             VARCHAR(1000)   NULL                                 COMMENT 'DSP 에러코드',
  dsp_alarm             VARCHAR(100)    NULL                                 COMMENT 'DSP 알람코드',
  slave_dsp_error       VARCHAR(100)    NULL                                 COMMENT '하위 DSP 에러코드',
  slave_dsp_alarm       VARCHAR(100)    NULL                                 COMMENT '하위 DSP 알람코드',
  pv_string_fault       VARCHAR(100)    NULL                                 COMMENT 'PV 오류 비트',
  temp_fault            VARCHAR(100)    NULL                                 COMMENT '온도 오류 비트',
  safety_code           VARCHAR(100)    NULL                                 COMMENT '안전 코드',

  phase_type            VARCHAR(100)    NULL                                 COMMENT '상 구성',
  power_capacity        VARCHAR(100)    NULL                                 COMMENT '정격 용량',
  rated_line_voltage    VARCHAR(100)    NULL                                 COMMENT '정격 선간전압',

  INDEX idx_dm_inv_detail_site_date (site_id, collected_at),
  INDEX idx_dm_inv_detail_name_date (inverter_name, collected_at),
  INDEX idx_dm_inv_detail_keyno     (site_id, inverter_name, collected_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='인버터 전체 이력 데이터';

-- ── 인버터 일별 집계 (오늘/어제/누적/현재출력) ───────────────
CREATE TABLE IF NOT EXISTS dm_inverter_main (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  site_id         INT UNSIGNED    NOT NULL                       COMMENT '발전소키 (dm_plant.id)',
  today_kwh       DECIMAL(12,3)   NULL                          COMMENT '오늘 발전량(kWh)',
  yesterday_kwh   DECIMAL(12,3)   NULL                          COMMENT '어제 발전량(kWh)',
  current_kw      DECIMAL(10,3)   NULL                          COMMENT '현재 출력(kW)',
  cumulative_kwh  DECIMAL(16,3)   NULL                          COMMENT '누적 발전량(kWh)',
  collected_at    DATETIME        NOT NULL                       COMMENT '수집시각',
  INDEX idx_dm_inv_main_site (site_id),
  INDEX idx_dm_inv_main_date (collected_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='인버터 일별 집계';

-- ── 인버터 에러 로그 ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dm_inverter_error (
  id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  site_id         INT UNSIGNED    NOT NULL                       COMMENT '발전소키 (dm_plant.id)',
  site_name       VARCHAR(255)    NOT NULL DEFAULT ''            COMMENT '발전소명',
  inverter_name   VARCHAR(100)    NOT NULL DEFAULT ''            COMMENT '인버터명',
  dsp_error       VARCHAR(100)    NULL                          COMMENT 'DSP 에러코드',
  dsp_slave_error VARCHAR(100)    NULL                          COMMENT '하위 DSP 에러코드',
  arm_alarm       VARCHAR(100)    NULL                          COMMENT 'ARM 알람',
  arm_error       VARCHAR(100)    NULL                          COMMENT 'ARM 에러',
  occurred_at     DATETIME        NOT NULL                       COMMENT '발생시각',
  INDEX idx_dm_inv_err_site (site_id),
  INDEX idx_dm_inv_err_date (occurred_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='인버터 에러 로그';

-- ── 사용자 ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dm_user (
  id                   VARCHAR(20)  NOT NULL PRIMARY KEY        COMMENT '사용자키',
  username             VARCHAR(100) NOT NULL                    COMMENT '아이디',
  display_name         VARCHAR(100) NOT NULL DEFAULT ''         COMMENT '이름',
  password             VARCHAR(200) NOT NULL                    COMMENT '비밀번호',
  email                VARCHAR(255) NOT NULL DEFAULT ''         COMMENT '이메일',
  phone                VARCHAR(30)  NOT NULL DEFAULT ''         COMMENT '연락처',
  role                 VARCHAR(20)  NOT NULL DEFAULT 'user'      COMMENT '권한 user/admin/developer',
  del_yn               CHAR(1)      NOT NULL DEFAULT 'N'        COMMENT '탈퇴여부 Y/N',
  lock_yn              CHAR(1)      NOT NULL DEFAULT 'N'        COMMENT '잠금여부 Y/N',
  login_count          INT UNSIGNED NOT NULL DEFAULT 0          COMMENT '로그인 횟수',
  last_login_at        DATETIME     NULL                        COMMENT '최근 로그인',
  password_changed_at  DATETIME     NULL                        COMMENT '비밀번호 변경일',
  registered_at        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
  UNIQUE KEY uk_dm_user_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자';

-- ── 안전관리 점검 일정/기록 ────────────────────────────────
CREATE TABLE IF NOT EXISTS dm_safety (
  id          INT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY,
  config_id   INT UNSIGNED  NULL                              COMMENT '설정 ID (dm_safety_config.id)',
  plant_id    INT UNSIGNED  NOT NULL                          COMMENT '발전소 ID',
  type        VARCHAR(30)   NOT NULL DEFAULT '안전관리'        COMMENT '점검 유형',
  inspect_date DATE         NOT NULL                          COMMENT '점검일',
  content     TEXT          NULL                              COMMENT '점검 내용',
  created_by  VARCHAR(100)  NULL                              COMMENT '작성자',
  created_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_dm_safety_date  (inspect_date),
  INDEX idx_dm_safety_plant (plant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='안전관리 점검 기록';

-- ── RTU 장비 현황 ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dm_rtu (
  id         INT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY,
  plant_id   INT UNSIGNED  NOT NULL                          COMMENT '발전소 ID',
  serial     VARCHAR(100)  NULL                              COMMENT '시리얼넘버',
  hw_ver     VARCHAR(50)   NULL                              COMMENT '하드웨어 버전',
  sw_ver     VARCHAR(50)   NULL                              COMMENT '소프트웨어 버전',
  line_type  VARCHAR(10)   NOT NULL DEFAULT '유선'            COMMENT '유선/무선',
  ctn        VARCHAR(50)   NULL                              COMMENT 'CTN번호',
  note       TEXT          NULL                              COMMENT '비고',
  updated_at DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  updated_by VARCHAR(100)  NULL,
  UNIQUE KEY uk_rtu_plant (plant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='RTU(다르고스) 장비 현황';

-- ── RTU 하드웨어 버전 이력 ────────────────────────────────────
CREATE TABLE IF NOT EXISTS dm_hw_version (
  id           INT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY,
  version      VARCHAR(50)   NOT NULL                         COMMENT '버전명',
  release_date DATE          NOT NULL                         COMMENT '출시일',
  description  TEXT          NULL                             COMMENT '변경사항',
  created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='RTU 하드웨어 버전 이력';

-- ── RTU 소프트웨어 버전 이력 ─────────────────────────────────
CREATE TABLE IF NOT EXISTS dm_sw_version (
  id           INT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY,
  version      VARCHAR(50)   NOT NULL                         COMMENT '버전명',
  release_date DATE          NOT NULL                         COMMENT '출시일',
  description  TEXT          NULL                             COMMENT '변경사항',
  created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='RTU 소프트웨어 버전 이력';

-- ── 파트너 관리자 발전소 배정 ────────────────────────────────
CREATE TABLE IF NOT EXISTS dm_user_plants (
  user_id   VARCHAR(20)   NOT NULL COMMENT '사용자 ID (dm_user.id)',
  plant_id  INT UNSIGNED  NOT NULL COMMENT '발전소 ID (dm_plant.id)',
  PRIMARY KEY (user_id, plant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='파트너 관리자 발전소 배정';

-- ── 공지사항 ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dm_notice (
  id          INT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY,
  category    VARCHAR(100)  NOT NULL DEFAULT ''   COMMENT '카테고리',
  tags        VARCHAR(500)  NOT NULL DEFAULT ''   COMMENT '태그 (콤마 구분)',
  site_name   VARCHAR(255)  NOT NULL DEFAULT ''   COMMENT '발전소명',
  title       VARCHAR(500)  NOT NULL DEFAULT ''   COMMENT '제목',
  author      VARCHAR(100)  NOT NULL DEFAULT ''   COMMENT '작성자',
  views       INT UNSIGNED  NOT NULL DEFAULT 0    COMMENT '조회수',
  del_yn      CHAR(1)       NOT NULL DEFAULT 'N'  COMMENT '삭제여부 Y/N',
  contents    MEDIUMTEXT    NULL                  COMMENT '내용 (HTML)',
  created_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
  INDEX idx_dm_notice_del  (del_yn),
  INDEX idx_dm_notice_date (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='공지사항';

-- ── 공지사항 첨부파일 ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dm_notice_files (
  id            INT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY,
  notice_id     INT UNSIGNED  NOT NULL             COMMENT '공지사항 ID',
  filename      VARCHAR(255)  NOT NULL DEFAULT ''  COMMENT '저장 파일명',
  original_name VARCHAR(255)  NOT NULL DEFAULT ''  COMMENT '원본 파일명',
  size          INT UNSIGNED  NOT NULL DEFAULT 0   COMMENT '파일 크기(bytes)',
  mimetype      VARCHAR(100)  NOT NULL DEFAULT ''  COMMENT 'MIME 타입',
  uploaded_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '업로드 시각',
  INDEX idx_dm_notice_files_notice (notice_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='공지사항 첨부파일';

-- ── 공사현황 ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dm_construction (
  site_id               INT UNSIGNED     NOT NULL PRIMARY KEY   COMMENT '발전소키 (dm_plant.id)',
  current_step          TINYINT UNSIGNED NOT NULL DEFAULT 1     COMMENT '현재 단계',
  operator_business     VARCHAR(255)     NOT NULL DEFAULT ''    COMMENT '사업자명',
  operator_address      VARCHAR(500)     NOT NULL DEFAULT ''    COMMENT '사업자 주소',
  operator_phone        VARCHAR(30)      NOT NULL DEFAULT ''    COMMENT '사업자 연락처',
  operator_email        VARCHAR(255)     NOT NULL DEFAULT ''    COMMENT '사업자 이메일',
  permit_plant_name     VARCHAR(255)     NOT NULL DEFAULT ''    COMMENT '허가 발전소명',
  permit_capacity       VARCHAR(50)      NOT NULL DEFAULT ''    COMMENT '허가 용량',
  permit_location       VARCHAR(255)     NOT NULL DEFAULT ''    COMMENT '허가 위치',
  permit_install_type   VARCHAR(50)      NOT NULL DEFAULT ''    COMMENT '설치 유형',
  permit_received_at    DATE             NULL                   COMMENT '허가 접수일',
  permit_expected_at    DATE             NULL                   COMMENT '허가 예정일',
  selected_contact_id   INT UNSIGNED     NULL                   COMMENT '담당자 (dm_construction_contacts.id)',
  updated_at            TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='공사현황';

-- ── 공사현황 실무담당자 ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS dm_construction_contacts (
  id          INT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY,
  code        VARCHAR(32)   NOT NULL             COMMENT '담당자 코드',
  name        VARCHAR(50)   NOT NULL             COMMENT '이름',
  dept        VARCHAR(100)  NOT NULL DEFAULT ''  COMMENT '부서',
  position    VARCHAR(50)   NOT NULL DEFAULT ''  COMMENT '직위',
  phone       VARCHAR(30)   NOT NULL DEFAULT ''  COMMENT '연락처',
  sort_order  INT           NOT NULL DEFAULT 0   COMMENT '정렬순서',
  UNIQUE KEY uk_dm_contacts_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='공사현황 담당자';

-- ── 인버터 메타정보 (모델·용량) ──────────────────────────────
CREATE TABLE IF NOT EXISTS dm_inverter_info (
  id              INT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY,
  site_id         INT UNSIGNED  NOT NULL             COMMENT '발전소키 (dm_plant.id)',
  inverter_name   VARCHAR(100)  NOT NULL             COMMENT '인버터명',
  model           VARCHAR(100)  NOT NULL DEFAULT ''  COMMENT '모델명',
  capacity_kw     DECIMAL(10,2) NOT NULL DEFAULT 0   COMMENT '용량(kW)',
  memo            VARCHAR(255)  NOT NULL DEFAULT ''  COMMENT '메모',
  updated_at      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
  UNIQUE KEY uk_dm_inverter_info (site_id, inverter_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='인버터 메타정보';

-- ── 설정 (지도 API 키 등) ────────────────────────────────────
CREATE TABLE IF NOT EXISTS dm_settings (
  setting_key    VARCHAR(64)  NOT NULL PRIMARY KEY  COMMENT '설정 키',
  setting_value  TEXT         NULL                  COMMENT '설정 값',
  updated_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='설정';
