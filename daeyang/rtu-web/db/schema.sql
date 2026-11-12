-- rtu-web: RTU 통합관리 전용 테이블 (monitering DB 안, 접두어 rtm_)
-- 원본 장부: D:\rtu\대양모니터링 RTU 통합관리.xlsx (시트 6개)
-- 기존 dy_* 테이블은 이 파일에서 만들거나 바꾸지 않는다.
-- 발전소명·용량·주소·인버터 수 등 기본 정보는 dy_power_plant(DPP_KEYNO = keyno)가 원본이다.
-- 엑셀의 "(조회)" 칸은 저장하지 않고 화면에서 JOIN으로 보여준다.
-- 모든 문장은 IF NOT EXISTS: 여러 번 실행해도 기존 데이터는 그대로 둔다.
-- 모든 컬럼에 COMMENT로 용도를 적는다.

-- 발전소장비 시트 (P0001~)
-- 발전소 목록은 dy_power_plant 기준(LEFT JOIN rtm_plant)으로 보여준다.
-- rtm_plant 행은 RTU 관리 정보가 있는 발전소에만 있고, 처음 입력할 때 만든다.
CREATE TABLE IF NOT EXISTS rtm_plant (
  plant_id          VARCHAR(10)  NOT NULL COMMENT '발전소 ID (P0001 형식, rtu-web 내부 번호)',
  dpp_keyno         INT          NOT NULL COMMENT '대양 keyno = dy_power_plant.DPP_KEYNO (발전소 하나에 한 행)',
  use_yn            VARCHAR(10)  NOT NULL DEFAULT '사용' COMMENT '사용 여부: 사용/미사용 (미사용 = 당사 RTU 이용 종료, 장비 회수·폐기와는 별개)',
  comm_type         VARCHAR(10)  NULL     COMMENT '통신 방식: 무선(LTE 라우터)/유선(랜선)',
  remote_method     VARCHAR(30)  NULL     COMMENT '원격 접속 방식: tailscale/Dataplicity/Anydesk/미사용, 모르면 빈칸 (추정 금지)',
  remote_address    VARCHAR(500) NULL     COMMENT '원격 접속 주소 (Tailscale IP 등, 여러 개면 원문 그대로)',
  remote_note       TEXT         NULL     COMMENT '원격 비고 (사내망 IP, 접속 계정 구분 등 메모)',
  jubok_keyno       VARCHAR(50)  NULL     COMMENT '주복(외부 회사 JB 서버) 쪽 발전소 번호, 주복 전송 현장만',
  legacy_inv_count  VARCHAR(20)  NULL     COMMENT '인버터 수량 (기존 장부 값, 참고용)',
  legacy_inv_type   VARCHAR(100) NULL     COMMENT '인버터 종류 (기존 장부 값, 예: GOODWE/KSTAR, 참고용)',
  legacy_protocol   VARCHAR(50)  NULL     COMMENT '프로토콜 (기존 장부 값, 예: 100/60/H/L, 참고용)',
  legacy_access_id  VARCHAR(10)  NULL     COMMENT '기존 원격관리 장부의 접속 ID (R0001 형식)',
  plant_note        TEXT         NULL     COMMENT '발전소 비고 (통합 이력, 특이사항 등)',
  created_at        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '행 생성 일시',
  updated_at        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '행 마지막 수정 일시',
  PRIMARY KEY (plant_id),
  UNIQUE KEY uk_rtm_plant_keyno (dpp_keyno)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='RTU 통합관리 - 발전소별 RTU 관리 정보';

-- 장비이력 시트 (D0001~): RTU 물리 장비 한 대 = 한 행
CREATE TABLE IF NOT EXISTS rtm_device (
  device_id      VARCHAR(10)  NOT NULL COMMENT '장비 기록 ID (D0001 형식)',
  device_type    VARCHAR(20)  NOT NULL DEFAULT 'RTU' COMMENT '장비 구분 (RTU 등)',
  serial_no      VARCHAR(50)  NULL     COMMENT 'RTU S/N (DR-26-004-0005 형식), 미부여 장비는 빈칸 (임의 번호 금지)',
  hw_version     VARCHAR(50)  NULL     COMMENT 'HW 버전·모뎀명 (예: DA-RGOS RTU v3)',
  board_type     VARCHAR(20)  NULL     COMMENT '보드 종류: Zero2/Zero3',
  sw_version     VARCHAR(50)  NULL     COMMENT '설치된 SW 버전 (예: 7.1, 8.0, 9.0)',
  made_date      DATE         NULL     COMMENT '제조일',
  install_date   DATE         NULL     COMMENT '현장 설치일',
  status         VARCHAR(20)  NULL     COMMENT '장비 상태: 사용중/회수/폐기/미사용',
  ctn            VARCHAR(20)  NULL     COMMENT 'LTE 동글 CTN(전화번호), 동글 사용 장비만',
  imei           VARCHAR(30)  NULL     COMMENT 'LTE 동글 IMEI',
  usim_model     VARCHAR(30)  NULL     COMMENT 'LTE 동글 유심 모델',
  usim_no        VARCHAR(30)  NULL     COMMENT 'LTE 동글 유심 번호',
  lte_ip         VARCHAR(50)  NULL     COMMENT 'LTE 동글 IP',
  legacy_site    VARCHAR(100) NULL     COMMENT '기존 장부에 적혀 있던 설치처 표기 (원문 보존)',
  note           TEXT         NULL     COMMENT '비고 (불량 내용, 공용 RTU 설명 등)',
  created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '행 생성 일시',
  updated_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '행 마지막 수정 일시',
  PRIMARY KEY (device_id),
  KEY idx_rtm_device_sn (serial_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='RTU 통합관리 - RTU 장비 (한 대 = 한 행)';

-- 다르고스(RTU) 하드웨어 버전 = S/N 앞부분
-- S/N 형식: DR-연도2자리-하드웨어 변경 차수3자리-그 버전의 몇 번째 장비4자리
--   예) DR-26-003-0004 : 26년, 하드웨어 변경 3번째 버전(콘덴서+rtcX)의 4번째 장비
-- 새 장비 S/N 은 고른 버전의 마지막 번호 + 1 로 자동 부여한다.
CREATE TABLE IF NOT EXISTS rtm_hw_version (
  prefix      VARCHAR(20)  NOT NULL COMMENT 'S/N 앞부분 (DR-연도2자리-변경차수3자리, 예: DR-26-010)',
  title       VARCHAR(100) NULL     COMMENT '내용 (예: 26년, 하드웨어 변경 10)',
  detail      VARCHAR(500) NULL     COMMENT '상세: 이전 버전에서 바뀐 점 (예: 009 + 아날로그 먹스 ic 변경)',
  is_current  TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '지금 만드는 버전 여부: 1이면 새 RTU S/N 기본값 (한 개만)',
  last_seq    INT          NOT NULL DEFAULT 0 COMMENT '이 버전에서 마지막으로 쓴 장비 번호 (다음 새 RTU = last_seq + 1, 미리 적어 둔 빈 행이 있으면 그 행 사용)',
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '행 생성 일시',
  updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '행 마지막 수정 일시',
  PRIMARY KEY (prefix)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='RTU 통합관리 - 다르고스 하드웨어 버전 (S/N 앞부분)';

-- 다르고스 하드웨어 시리얼넘버 표 (2026-11-02 기준). 이미 있으면 건드리지 않는다.
-- last_seq: 장부 기준 마지막 사용 번호. DR-26-010 은 0037 까지 사용(0038~0053 은 미리 적어 둔 빈 행).
INSERT IGNORE INTO rtm_hw_version (prefix, title, detail, is_current, last_seq) VALUES
  ('DR-26-002', '26년, 하드웨어 변경 2',  '콘덴서 부착 (capacitor)', 0, 4),
  ('DR-26-003', '26년, 하드웨어 변경 3',  '콘덴서 + attiny85제거', 0, 1),
  ('DR-26-004', '26년, 하드웨어 변경 4',  '003 +저항값 변경 + 방열판3개 부착', 0, 5),
  ('DR-26-005', '26년, 하드웨어 변경 5',  '004 + 제습제1개', 0, 6),
  ('DR-26-006', '26년, 하드웨어 변경 6',  '005 + rs485 ic 변경', 0, 1),
  ('DR-26-007', '26년, 하드웨어 변경 7',  '006 + 전압분배 저항 추가', 0, 3),
  ('DR-26-008', '26년, 하드웨어 변경 8',  '007 + 백라이트 기능 추가, lcd선명도 조절, 로컬 main 실행', 0, 14),
  ('DR-26-009', '26년, 하드웨어 변경 9',  '008 + 기존 저항값에서 값 3개 변경', 0, 4),
  ('DR-26-010', '26년, 하드웨어 변경 10', '009 + 아날로그 먹스 ic 변경, 485 풀업-풀다운 저항변경', 1, 37),
  ('DR-26-011', '26년, 하드웨어 변경 11', '010 + sd카드 class10 변경', 0, 0);

-- RTU 소프트웨어 버전 (원격 관리.xlsx SN 시트의 SW 표). 장비의 sw_version 칸 숫자 = 이 표의 번호
CREATE TABLE IF NOT EXISTS rtm_sw_version (
  code        VARCHAR(20)  NOT NULL COMMENT 'SW 버전 코드 (예: sw_v12)',
  title       VARCHAR(100) NULL     COMMENT '내용 (예: os이미지 업데이트)',
  detail      VARCHAR(500) NULL     COMMENT '상세 (예: v7.1_261021.img 사용)',
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '행 생성 일시',
  updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '행 마지막 수정 일시',
  PRIMARY KEY (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='RTU 통합관리 - RTU 소프트웨어 버전';

-- 장비 ↔ 발전소 연결 (keyno와 RTU는 일대일이 아님)
--   공용 RTU 한 대에 발전소 여러 개 (윤서 4~7호, 한빛 1·2·5호)
--   발전소 하나에 RTU 여러 대 (keyno 145 민정·영자·재두)
CREATE TABLE IF NOT EXISTS rtm_device_plant (
  device_id   VARCHAR(10)  NOT NULL COMMENT 'RTU 장비 ID (rtm_device.device_id)',
  plant_id    VARCHAR(10)  NOT NULL COMMENT '발전소 ID (rtm_plant.plant_id)',
  linked_at   DATE         NULL     COMMENT '이 발전소에 연결(설치)한 날',
  unlinked_at DATE         NULL     COMMENT '연결 해제(회수·교체)한 날, 지금 연결 중이면 NULL',
  note        VARCHAR(500) NULL     COMMENT '연결 메모 (예: 공용 RTU, 교체 사유)',
  PRIMARY KEY (device_id, plant_id),
  KEY idx_rtm_dp_plant (plant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='RTU 통합관리 - 장비와 발전소 연결 (다대다)';

-- 세팅출고 시트 (S0001~)
CREATE TABLE IF NOT EXISTS rtm_setup (
  setup_id       VARCHAR(10)  NOT NULL COMMENT '세팅 작업 ID (S0001 형식)',
  plant_id       VARCHAR(10)  NOT NULL COMMENT '대상 발전소 ID (rtm_plant.plant_id)',
  req_name       VARCHAR(100) NULL     COMMENT '세팅 요청서에 적힌 발전소 이름 (원문, 예: 한빛 1,2호)',
  req_capacity   VARCHAR(30)  NULL     COMMENT '세팅 요청서의 발전소 용량 (kW)',
  req_address    VARCHAR(200) NULL     COMMENT '세팅 요청서의 주소',
  req_comm       VARCHAR(10)  NULL     COMMENT '세팅 요청서의 인터넷: 유선/무선',
  kind           VARCHAR(10)  NULL     COMMENT '작업 구분: 신규/교체',
  due_date       DATE         NULL     COMMENT '세팅 기한 (요청받은 완료 날짜)',
  due_time       VARCHAR(30)  NULL     COMMENT '기한 시간대: 오전/오후 또는 원문 (예: 오전 11시까지)',
  owner          VARCHAR(30)  NULL     COMMENT '요청 담당자 이름',
  status         VARCHAR(20)  NULL     COMMENT '진행 상태 (세팅 중/시험 중/출고/설치 완료/취소), 빈칸이면 기록 없음',
  device_id      VARCHAR(10)  NULL     COMMENT '이 작업으로 출고한 RTU 장비 ID (rtm_device.device_id)',
  sw_version     VARCHAR(50)  NULL     COMMENT '설치한 SW 버전',
  tested_at      DATE         NULL     COMMENT '시험 완료일',
  shipped_at     DATE         NULL     COMMENT '출고일',
  installed_at   DATE         NULL     COMMENT '현장 설치일',
  collect_ok_at  DATE         NULL     COMMENT '서버 DB에 정상 수집되는 것을 확인한 날',
  next_check     VARCHAR(200) NULL     COMMENT '다음에 확인할 일 (예: RTU S/N 확인)',
  src_file       VARCHAR(200) NULL     COMMENT '세팅 요청서 원본 파일명',
  src_sheet      VARCHAR(100) NULL     COMMENT '세팅 요청서 원본 시트명',
  created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '행 생성 일시',
  updated_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '행 마지막 수정 일시',
  PRIMARY KEY (setup_id),
  KEY idx_rtm_setup_plant (plant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='RTU 통합관리 - RTU 세팅·출고 작업';

-- 인버터구성 시트 (I0001~): 같은 모델 묶음 한 줄 (수량 포함)
CREATE TABLE IF NOT EXISTS rtm_inverter (
  inv_id      VARCHAR(10)   NOT NULL COMMENT '인버터 구성 ID (I0001 형식)',
  setup_id    VARCHAR(10)   NULL     COMMENT '관련 세팅 작업 ID (rtm_setup.setup_id), 없으면 빈칸',
  plant_id    VARCHAR(10)   NOT NULL COMMENT '발전소 ID (rtm_plant.plant_id)',
  kind        VARCHAR(30)   NULL     COMMENT '구성 구분: 세팅 요청(요청서 기준)/실설치(현장 확인)',
  maker       VARCHAR(30)   NULL     COMMENT '인버터 제조사 (sofar/goodwe/hyosung/growatt 등)',
  model       VARCHAR(50)   NULL     COMMENT '인버터 모델명 (예: GW50KBF-MT)',
  unit_kw     DECIMAL(10,2) NULL     COMMENT '인버터 한 대 용량 (kW)',
  qty         INT           NULL     COMMENT '이 모델 대수',
  device_id   VARCHAR(10)   NULL     COMMENT '연결된 RTU 장비 ID (rtm_device.device_id)',
  port        VARCHAR(10)   NULL     COMMENT 'RTU RS485 단자 번호',
  slave_id    VARCHAR(20)   NULL     COMMENT 'Modbus slave ID (여러 대면 범위·목록 원문)',
  inv_name    VARCHAR(100)  NULL     COMMENT '인버터명 (예: 인버터 1호)',
  check_note  VARCHAR(200)  NULL     COMMENT '설정 점검 결과 (예: 요청 구성, 실설치 확인 필요)',
  note        TEXT          NULL     COMMENT '비고',
  created_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '행 생성 일시',
  updated_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '행 마지막 수정 일시',
  PRIMARY KEY (inv_id),
  KEY idx_rtm_inv_plant (plant_id),
  KEY idx_rtm_inv_setup (setup_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='RTU 통합관리 - 발전소 인버터 구성';

-- 작업장애 시트 (H0001~)
CREATE TABLE IF NOT EXISTS rtm_issue (
  issue_id     VARCHAR(10)  NOT NULL COMMENT '작업·장애 이력 ID (H0001 형식)',
  occurred_at  DATE         NULL     COMMENT '발생일',
  plant_id     VARCHAR(10)  NULL     COMMENT '발전소 ID (rtm_plant.plant_id), 특정 발전소가 아니면 빈칸',
  plant_text   VARCHAR(100) NULL     COMMENT '원본 장부에 적힌 발전소 이름 (원문, 예: 주원 1,2,3호)',
  inverter     VARCHAR(100) NULL     COMMENT '관련 인버터 (예: goodwe/60)',
  symptom      TEXT         NULL     COMMENT '증상 또는 작업 내용',
  action_taken TEXT         NULL     COMMENT '조치 내용',
  status       VARCHAR(20)  NULL     COMMENT '처리 상태 (처리 중/완료), 빈칸이면 기록 없음',
  owner        VARCHAR(30)  NULL     COMMENT '처리 담당자',
  checked_at   DATE         NULL     COMMENT '처리 결과 확인일',
  sn_before    VARCHAR(50)  NULL     COMMENT '장비 교체 시 교체 전 RTU S/N',
  sn_after     VARCHAR(50)  NULL     COMMENT '장비 교체 시 교체 후 RTU S/N',
  note         TEXT         NULL     COMMENT '비고',
  created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '행 생성 일시',
  updated_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '행 마지막 수정 일시',
  PRIMARY KEY (issue_id),
  KEY idx_rtm_issue_plant (plant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='RTU 통합관리 - 작업·장애 이력';

-- 라우터관리 시트 (L0001~): 설치 발전소는 rtm_router_plant 로 연결 (설치처 미확인·재고는 연결 없음)
CREATE TABLE IF NOT EXISTS rtm_router (
  router_id    VARCHAR(10)  NOT NULL COMMENT 'LTE 라우터 ID (L0001 형식)',
  modem        VARCHAR(30)  NULL     COMMENT '라우터 모델명 (TX700_B/WD-L700L 등)',
  serial_no    VARCHAR(30)  NULL     COMMENT '라우터 일련번호',
  imei         VARCHAR(30)  NULL     COMMENT '라우터 IMEI',
  usim_model   VARCHAR(30)  NULL     COMMENT '유심 모델 (U9600/U9700 등)',
  usim_no      VARCHAR(30)  NULL     COMMENT '유심 번호',
  ctn          VARCHAR(20)  NULL     COMMENT 'CTN 번호 (회선 전화번호, 예: 012-2575-0229)',
  lte_ip       VARCHAR(50)  NULL     COMMENT 'LTE IP',
  status       VARCHAR(30)  NULL     COMMENT '사용 상태: 확인/해지/재고/사용 중 (설치처 미확인)',
  installed_at DATE         NULL     COMMENT '설치일',
  removed_at   DATE         NULL     COMMENT '회수일',
  legacy_site  VARCHAR(100) NULL     COMMENT '기존 장부에 적혀 있던 설치처 표기 (원문 보존)',
  note         TEXT         NULL     COMMENT '비고 (원격 확인일, A/S 내용 등)',
  created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '행 생성 일시',
  updated_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '행 마지막 수정 일시',
  PRIMARY KEY (router_id),
  KEY idx_rtm_router_ctn (ctn)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='RTU 통합관리 - LTE 라우터';

-- 라우터 ↔ 발전소 연결 (다대다)
--   라우터 한 대를 여러 발전소가 같이 씀 (윤서 4~7호, 한빛 1·2·5호)
--   발전소 하나에 라우터 여러 대 (keyno 145 민정·영자·재두: RTU·라우터 각 1대씩 3대)
CREATE TABLE IF NOT EXISTS rtm_router_plant (
  router_id   VARCHAR(10)  NOT NULL COMMENT '라우터 ID (rtm_router.router_id)',
  plant_id    VARCHAR(10)  NOT NULL COMMENT '발전소 ID (rtm_plant.plant_id)',
  linked_at   DATE         NULL     COMMENT '이 발전소에 연결(설치)한 날',
  unlinked_at DATE         NULL     COMMENT '연결 해제(회수·교체)한 날, 지금 연결 중이면 NULL',
  note        VARCHAR(500) NULL     COMMENT '연결 메모 (예: 공용 라우터)',
  PRIMARY KEY (router_id, plant_id),
  KEY idx_rtm_rp_plant (plant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='RTU 통합관리 - 라우터와 발전소 연결 (다대다)';

-- rtu-web 로그인 계정 (홈페이지 회원 u_userinfo와 별개)
CREATE TABLE IF NOT EXISTS rtm_user (
  user_id     INT          NOT NULL AUTO_INCREMENT COMMENT '사용자 번호',
  username    VARCHAR(50)  NOT NULL COMMENT '로그인 아이디',
  password    VARCHAR(100) NOT NULL COMMENT '비밀번호 (bcrypt 해시)',
  name        VARCHAR(30)  NOT NULL COMMENT '이름 (변경 이력에 표시)',
  is_admin    TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '관리자 여부: 1이면 계정 관리 가능',
  is_active   TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '사용 여부: 0이면 로그인 차단',
  login_fail_count INT     NOT NULL DEFAULT 0 COMMENT '연속 로그인 실패 횟수 (성공하면 0)',
  is_locked   TINYINT(1)   NOT NULL DEFAULT 0 COMMENT '잠금 여부: 5회 실패 시 1, 관리자가 풀어줌',
  last_login  DATETIME     NULL     COMMENT '마지막 로그인 일시',
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '계정 생성 일시',
  PRIMARY KEY (user_id),
  UNIQUE KEY uk_rtm_user_name (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='RTU 통합관리 - rtu-web 로그인 사용자';

-- 변경 이력: rtm_* 와 dy_power_plant 를 바꿀 때마다 한 줄 (이전/이후 값 JSON)
CREATE TABLE IF NOT EXISTS rtm_change_log (
  log_id      BIGINT       NOT NULL AUTO_INCREMENT COMMENT '이력 번호',
  table_name  VARCHAR(50)  NOT NULL COMMENT '바뀐 테이블 이름 (rtm_plant, dy_power_plant 등)',
  row_key     VARCHAR(50)  NOT NULL COMMENT '바뀐 행의 키 (P0001, DPP_KEYNO 등)',
  action      VARCHAR(10)  NOT NULL COMMENT '작업 종류: insert/update/delete',
  before_json LONGTEXT     NULL     COMMENT '바뀌기 전 값 (JSON, insert면 NULL)',
  after_json  LONGTEXT     NULL     COMMENT '바뀐 후 값 (JSON, delete면 NULL)',
  user_id     INT          NULL     COMMENT '작업한 사용자 번호 (rtm_user.user_id)',
  username    VARCHAR(50)  NULL     COMMENT '작업한 사용자 아이디 (계정이 지워져도 남도록 따로 저장)',
  created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '변경 일시',
  PRIMARY KEY (log_id),
  KEY idx_rtm_log_row (table_name, row_key),
  KEY idx_rtm_log_time (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='RTU 통합관리 - 변경 이력';
