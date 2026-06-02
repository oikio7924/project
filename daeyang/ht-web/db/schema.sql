-- 운영용 MariaDB 스키마
-- 실행 예시: mysql -u계정 -p DB명 < db/schema.sql

-- ============================================================
-- ti_users : 로그인 계정 (회사/사용자 단위)
-- ============================================================
CREATE TABLE IF NOT EXISTS ti_users (
  id                 INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 사용자 고유 번호 (자동증가)
  username           VARCHAR(120) NOT NULL UNIQUE,                     -- 로그인 아이디 (중복 불가)
  password           VARCHAR(255) NOT NULL,                            -- 비밀번호 (bcrypt 해시)
  active_supplier_id INT UNSIGNED NULL,                                -- 현재 선택된 공급자 ID (ti_suppliers.id 참조)
  notice_text        VARCHAR(1000) NOT NULL DEFAULT '',                -- 발행 페이지 상단에 표시할 공지 문구
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP      -- 계정 생성 일시
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- ti_suppliers : 공급자 정보 (세금계산서의 "공급자" 란)
-- ============================================================
CREATE TABLE IF NOT EXISTS ti_suppliers (
  id                 INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 공급자 고유 번호
  user_id            INT UNSIGNED NOT NULL,                            -- 소유 계정 (ti_users.id)
  biz_no             VARCHAR(40)  NOT NULL DEFAULT '',                 -- 사업자등록번호 (예: 123-45-67890)
  corp_name          VARCHAR(200) NOT NULL DEFAULT '',                 -- 상호(법인명)
  ceo_name           VARCHAR(100) NOT NULL DEFAULT '',                 -- 대표자명
  address            VARCHAR(255) NOT NULL DEFAULT '',                 -- 사업장 주소
  biz_type           VARCHAR(120) NOT NULL DEFAULT '',                 -- 업태 (예: 서비스업)
  biz_item           VARCHAR(120) NOT NULL DEFAULT '',                 -- 종목 (예: 전기안전관리)
  email              VARCHAR(120) NOT NULL DEFAULT '',                 -- 공급자 이메일
  contact_dept       VARCHAR(120) NOT NULL DEFAULT '',                 -- 담당부서명
  contact_name       VARCHAR(120) NOT NULL DEFAULT '',                 -- 담당자 이름
  contact_phone      VARCHAR(60)  NOT NULL DEFAULT '',                 -- 담당자 전화번호
  contact_extension  VARCHAR(30)  NOT NULL DEFAULT '',                 -- 담당자 내선번호
  contact_email      VARCHAR(120) NOT NULL DEFAULT '',                 -- 담당자 이메일
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,     -- 등록 일시
  updated_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 최종 수정 일시
  INDEX idx_suppliers_user (user_id),
  CONSTRAINT fk_ti_suppliers_user FOREIGN KEY (user_id) REFERENCES ti_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- ti_recipients : 공급받는자 (세금계산서의 "공급받는자" 란)
-- ============================================================
CREATE TABLE IF NOT EXISTS ti_recipients (
  id                  INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 공급받는자 고유 번호 (문서번호에도 사용됨)
  user_id             INT UNSIGNED NOT NULL,                            -- 소유 계정 (ti_users.id)
  kind                VARCHAR(20)  NOT NULL DEFAULT 'individual',       -- 구분: individual(개인), business(사업자), foreign(외국인)
  biz_subtype         VARCHAR(20)  NULL,                                -- 사업자 세부: sole(개인사업자), corp(법인), nonprofit(비영리)
  display_name        VARCHAR(200) NOT NULL DEFAULT '',                 -- 상호 또는 이름 (화면·세금계산서에 표시)
  biz_no              VARCHAR(40)  NOT NULL DEFAULT '',                 -- 사업자등록번호 또는 주민등록번호
  ceo_name            VARCHAR(120) NOT NULL DEFAULT '',                 -- 대표자명
  address             VARCHAR(255) NOT NULL DEFAULT '',                 -- 사업장 주소
  email               VARCHAR(120) NOT NULL DEFAULT '',                 -- 이메일 (세금계산서 수신용)
  biz_type            VARCHAR(120) NOT NULL DEFAULT '',                 -- 업태
  biz_item            VARCHAR(120) NOT NULL DEFAULT '',                 -- 종목
  internal_memo       VARCHAR(500) NOT NULL DEFAULT '',                 -- 내부 관리 메모 (세금계산서에 미표시)
  svc_safety          TINYINT(1)   NOT NULL DEFAULT 0,                  -- 안전관리 서비스 계약 여부 (0/1)
  svc_tax             TINYINT(1)   NOT NULL DEFAULT 0,                  -- 세무 서비스 계약 여부 (0/1)
  svc_billing         TINYINT(1)   NOT NULL DEFAULT 0,                  -- 청구 서비스 계약 여부 (0/1)
  svc_monitoring      TINYINT(1)   NOT NULL DEFAULT 0,                  -- 모니터링 서비스 계약 여부 (0/1)
  monitoring_type     VARCHAR(100) NOT NULL DEFAULT '',                 -- 모니터링 종류 (ti_monitoring_options.name 참조)
  payment_method      VARCHAR(50)  NOT NULL DEFAULT '',                 -- 결제방식 (예: 자동이체(CMS), 직접송금)
  capacity            DECIMAL(10,3) NOT NULL DEFAULT 0,                 -- 용량 (현재 미사용, 예비 컬럼)
  reception_capacity  DECIMAL(10,3) NOT NULL DEFAULT 0,                 -- 수전용량 (kW)
  generation_capacity DECIMAL(10,3) NOT NULL DEFAULT 0,                 -- 태양광 발전용량 (kW)
  biz_cert_file       VARCHAR(255) NOT NULL DEFAULT '',                 -- 사업자등록증 파일 저장 경로
  biz_cert_name       VARCHAR(255) NOT NULL DEFAULT '',                 -- 사업자등록증 원본 파일명
  created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,     -- 등록 일시
  updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 최종 수정 일시
  INDEX idx_recipients_user (user_id),
  CONSTRAINT fk_ti_recipients_user FOREIGN KEY (user_id) REFERENCES ti_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- ti_recipient_items : 공급받는자별 품목(발전소) 목록
-- 한 공급받는자가 여러 발전소를 가질 수 있어 별도 테이블로 관리
-- ============================================================
CREATE TABLE IF NOT EXISTS ti_recipient_items (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 품목 고유 번호
  recipient_id    INT UNSIGNED NOT NULL,                            -- 소속 공급받는자 (ti_recipients.id)
  plant_name      VARCHAR(200) NOT NULL DEFAULT '',                 -- 발전소명
  fixed_item_name VARCHAR(200) NOT NULL DEFAULT '',                 -- 세금계산서에 고정 표시할 품목명 (비어있으면 발전소명 사용)
  monthly_supply  DECIMAL(15,2) NOT NULL DEFAULT 0,                 -- 월 공급가액 (원)
  monthly_tax     DECIMAL(15,2) NOT NULL DEFAULT 0,                 -- 월 세액 = monthly_supply × 10% (원)
  quantity        DECIMAL(18,2) NOT NULL DEFAULT 0,                 -- 수량 (hometaxbill 전송용, 0이면 빈칸으로 발행)
  unit_price      DECIMAL(18,2) NOT NULL DEFAULT 0,                 -- 단가 (hometaxbill 전송용, 0이면 빈칸으로 발행)
  note            VARCHAR(500)  NOT NULL DEFAULT '',                -- 비고
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,     -- 등록 일시
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 최종 수정 일시
  INDEX idx_items_recipient (recipient_id),
  CONSTRAINT fk_ti_items_recipient FOREIGN KEY (recipient_id) REFERENCES ti_recipients(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- ti_issue_records : 전자세금계산서 발행 이력
-- 전송 시도마다 새 레코드 생성 (실패 이력도 보존)
-- 문서번호(homemunseo_id) = issue_date(8자리) + '-' + recipient_id(4자리) + id(6자리)
-- ============================================================
CREATE TABLE IF NOT EXISTS ti_issue_records (
  id                 INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 발행 레코드 고유 번호 (문서번호 뒷 6자리에 사용)
  user_id            INT UNSIGNED NOT NULL,                            -- 발행한 계정 (ti_users.id)
  created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,     -- 레코드 생성 일시
  year_month_key     CHAR(7)  NOT NULL,                                -- 귀속 연월 (예: 2026-05)
  issue_date         CHAR(10) NOT NULL DEFAULT '',                     -- 작성일자 (예: 2026-05-27)
  recipient_id       INT UNSIGNED NOT NULL DEFAULT 0,                  -- 공급받는자 ID (ti_recipients.id, 문서번호에 사용)
  recipient_name     VARCHAR(200) NOT NULL DEFAULT '',                 -- 발행 당시 공급받는자 상호 (스냅샷)
  total_supply       DECIMAL(15,2) NOT NULL DEFAULT 0,                 -- 총 공급가액 (원)
  total_tax          DECIMAL(15,2) NOT NULL DEFAULT 0,                 -- 총 세액 (원)
  item_json          TEXT,                                             -- 발행 당시 품목 목록 JSON 스냅샷 (NULL이면 현재 품목 사용)
  transmit_status    VARCHAR(30)  NOT NULL DEFAULT 'not_sent',         -- 전송 상태:
                                                                       --   not_sent           : 미전송(발행대기)
                                                                       --   transmitted_practice: 홈택스빌 전송완료
                                                                       --   issued             : 국세청 발급완료
                                                                       --   transmit_failed    : 전송실패 (이력 보존, 재발행 가능)
                                                                       --   issue_failed       : 발급실패 (이력 보존, 재발행 가능)
  status             VARCHAR(30)  NOT NULL DEFAULT 'issued',           -- 내부 상태 (현재 issued 고정, 예비)
  last_hometax_error VARCHAR(500) NOT NULL DEFAULT '',                 -- 마지막 홈택스빌 오류 메시지
  mock_seed          TINYINT(1)   NOT NULL DEFAULT 0,                  -- 테스트 목업 여부 (1이면 실제 전송 안 된 모의 레코드)
  INDEX idx_issue_user_created (user_id, created_at),
  INDEX idx_issue_user_ym (user_id, year_month_key),
  CONSTRAINT fk_ti_issue_user FOREIGN KEY (user_id) REFERENCES ti_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- ti_monitoring_options : 모니터링 종류 선택지 (사용자 정의)
-- ============================================================
CREATE TABLE IF NOT EXISTS ti_monitoring_options (
  id         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 옵션 고유 번호
  user_id    INT UNSIGNED NOT NULL,                            -- 소유 계정 (ti_users.id)
  name       VARCHAR(100) NOT NULL,                            -- 모니터링 종류 이름 (예: 한전SCADA, 자체모니터링)
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,     -- 등록 일시
  UNIQUE KEY uq_mon_opt (user_id, name),                       -- 동일 계정 내 이름 중복 불가
  INDEX idx_mon_opt_user (user_id),
  CONSTRAINT fk_ti_mon_opt_user FOREIGN KEY (user_id) REFERENCES ti_users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- ti_issue_matrix_notes : 연간 발행 현황표의 셀별 메모
-- (발행내역 페이지의 연×수급자 매트릭스에서 셀마다 메모 입력)
-- ============================================================
CREATE TABLE IF NOT EXISTS ti_issue_matrix_notes (
  id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 메모 고유 번호
  user_id      INT UNSIGNED NOT NULL,                            -- 소유 계정 (ti_users.id)
  year_no      INT          NOT NULL,                            -- 연도 (예: 2026)
  recipient_id INT UNSIGNED NOT NULL,                            -- 공급받는자 ID (ti_recipients.id)
  note         VARCHAR(500) NOT NULL DEFAULT '',                 -- 메모 내용
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 최종 수정 일시
  UNIQUE KEY uq_matrix_note (user_id, year_no, recipient_id),   -- 계정+연도+수급자 조합은 유일
  INDEX idx_matrix_note_user_year (user_id, year_no),
  CONSTRAINT fk_ti_matrix_user      FOREIGN KEY (user_id)      REFERENCES ti_users(id)      ON DELETE CASCADE,
  CONSTRAINT fk_ti_matrix_recipient FOREIGN KEY (recipient_id) REFERENCES ti_recipients(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
