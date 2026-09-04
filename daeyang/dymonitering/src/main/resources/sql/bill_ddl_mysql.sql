-- ============================================================
-- bill.do 전용 테이블 DDL (MySQL)
-- 달력 일정, 공급자, 공급받는자, 발행 템플릿, 발행내역, 문서번호
-- ============================================================

-- 1) bill 전용 로그인 사용자 (선택 사항)
CREATE TABLE ht_bill_user (
    id              INT             NOT NULL AUTO_INCREMENT COMMENT 'PK',
    login_id        VARCHAR(50)     NOT NULL COMMENT '로그인 아이디',
    login_pw        VARCHAR(255)    NOT NULL COMMENT '암호화 비밀번호',
    name            VARCHAR(50)    NULL COMMENT '이름',
    use_yn          CHAR(1)         NOT NULL DEFAULT 'Y' COMMENT '사용여부 Y/N',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_bill_user_login_id (login_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'bill 전용 사용자';


-- 2) 달력 일정 (메인 페이지 메모보드용)
CREATE TABLE ht_bill_schedule (
    id              INT             NOT NULL AUTO_INCREMENT COMMENT 'PK',
    schedule_date   DATE            NOT NULL COMMENT '일정 날짜',
    title           VARCHAR(200)    NULL COMMENT '제목',
    memo            TEXT            NULL COMMENT '메모 내용',
    created_by      INT             NULL COMMENT '작성자 bill_user.id',
    created_at      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME        NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_bill_schedule_date (schedule_date),
    KEY idx_bill_schedule_created_by (created_by)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'bill 달력 일정';


-- 3) 공급자
CREATE TABLE ht_bill_provider (
    id                  INT             NOT NULL AUTO_INCREMENT COMMENT 'PK',
    corp_num            VARCHAR(20)     NOT NULL COMMENT '사업자등록번호',
    biz_type            VARCHAR(50)     NULL COMMENT '업태',
    biz_classification  VARCHAR(50)     NULL COMMENT '업종',
    corp_name           VARCHAR(100)    NOT NULL COMMENT '상호',
    ceo_name            VARCHAR(50)     NULL COMMENT '대표자명',
    contact_name        VARCHAR(50)     NULL COMMENT '담당자명',
    contact_phone       VARCHAR(20)     NULL COMMENT '담당자 연락처',
    email               VARCHAR(100)    NULL COMMENT '이메일',
    address             VARCHAR(200)    NULL COMMENT '주소',
    last_document_no    VARCHAR(30)     NULL COMMENT '마지막 문서번호(고유번호) - 다음 발행 시 +1',
    use_yn              CHAR(1)         NOT NULL DEFAULT 'Y' COMMENT '사용여부 Y/N',
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_bill_provider_corp_num (corp_num)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'bill 공급자';


-- 4) 공급받는자 (사업자 / 개인 구분)
-- recipient_type: 01=사업자, 02=개인(주민등록번호), 03=외국인
CREATE TABLE ht_bill_recipient (
    id                  INT             NOT NULL AUTO_INCREMENT COMMENT 'PK',
    provider_id         INT             NULL COMMENT '주로 사용하는 공급자 bill_provider.id (참고용)',
    recipient_type      CHAR(2)         NOT NULL DEFAULT '01' COMMENT '01=사업자 02=개인(주민) 03=외국인',
    -- 사업자일 때(01)
    corp_num            VARCHAR(20)     NULL COMMENT '사업자등록번호 (사업자일 때 사용)',
    tax_num             VARCHAR(20)     NULL COMMENT '종사업장번호 (사업자)',
    biz_type            VARCHAR(50)     NULL COMMENT '업태 (사업자)',
    biz_classification  VARCHAR(50)     NULL COMMENT '업종 (사업자)',
    corp_name           VARCHAR(100)    NULL COMMENT '상호(사업자) 또는 성명(개인)',
    ceo_name            VARCHAR(50)     NULL COMMENT '대표자명 (사업자)',
    -- 개인일 때(02, 03)
    id_num              VARCHAR(20)     NULL COMMENT '주민등록번호(02) 또는 외국인등록번호(03)',
    --
    contact_name        VARCHAR(50)     NULL COMMENT '담당자명',
    contact_phone       VARCHAR(20)     NULL COMMENT '담당자 연락처',
    email               VARCHAR(100)    NULL COMMENT '이메일',
    address             VARCHAR(200)    NULL COMMENT '주소',
    use_yn              CHAR(1)         NOT NULL DEFAULT 'Y' COMMENT '사용여부 Y/N',
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_bill_recipient_provider (provider_id),
    KEY idx_bill_recipient_type (recipient_type),
    KEY idx_bill_recipient_corp_num (corp_num),
    KEY idx_bill_recipient_id_num (id_num)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'bill 공급받는자(사업자/개인 구분)';


-- 5) 발행 템플릿 (발전소별 고정 금액·품목 기본값 - 매달 품목명만 바꿔서 일괄 저장용)
CREATE TABLE ht_bill_invoice_template (
    id                  INT             NOT NULL AUTO_INCREMENT COMMENT 'PK',
    provider_id         INT             NOT NULL COMMENT '공급자 bill_provider.id',
    recipient_id       INT             NOT NULL COMMENT '공급받는자 bill_recipient.id',
    -- 금액
    supply_total        DECIMAL(15,0)   NOT NULL DEFAULT 0 COMMENT '공급가액 합계',
    tax_total           DECIMAL(15,0)   NOT NULL DEFAULT 0 COMMENT '세액 합계',
    grand_total         DECIMAL(15,0)   NOT NULL DEFAULT 0 COMMENT '총 금액',
    cash                DECIMAL(15,0)   NOT NULL DEFAULT 0 COMMENT '현금',
    scheck              DECIMAL(15,0)   NOT NULL DEFAULT 0 COMMENT '수표',
    draft               DECIMAL(15,0)   NOT NULL DEFAULT 0 COMMENT '어음',
    uncollected         DECIMAL(15,0)   NOT NULL DEFAULT 0 COMMENT '외상미수금',
    -- 품목 상세 (1건 기준)
    unit                VARCHAR(20)     NULL COMMENT '규격',
    quantity            VARCHAR(20)     NULL COMMENT '수량',
    unit_price          DECIMAL(15,0)   NULL COMMENT '단가',
    supply_price        DECIMAL(15,0)   NULL COMMENT '공급가액',
    tax_amount          DECIMAL(15,0)   NULL COMMENT '세액',
    description         VARCHAR(200)    NULL COMMENT '비고',
    -- 기타
    purpose_type        VARCHAR(10)     NULL COMMENT '영수/청구 등',
    party_type_code     VARCHAR(10)     NULL COMMENT '공급받는자 구분',
    type_code1          VARCHAR(10)     NULL COMMENT '세금계산서 종류1',
    type_code2          VARCHAR(10)     NULL COMMENT '세금계산서 종류2',
    sub_keyno           VARCHAR(10)     NULL COMMENT '발행종류 구분(한전/거래처 등)',
    use_yn              CHAR(1)         NOT NULL DEFAULT 'Y' COMMENT '사용여부 Y/N',
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_bill_template_provider_recipient (provider_id, recipient_id),
    KEY idx_bill_template_provider (provider_id),
    KEY idx_bill_template_recipient (recipient_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'bill 발행 템플릿(고정 금액)';


-- 6) 발행내역 (실제 세금계산서 발행/전송 건)
CREATE TABLE ht_bill_invoice_log (
    id                  INT             NOT NULL AUTO_INCREMENT COMMENT 'PK',
    provider_id         INT             NOT NULL COMMENT '공급자 bill_provider.id',
    recipient_id        INT             NOT NULL COMMENT '공급받는자 bill_recipient.id',
    template_id         INT             NULL COMMENT '참조한 템플릿 bill_invoice_template.id',
    -- 품목명(매달 바꾸는 값)
    subject             VARCHAR(200)   NOT NULL COMMENT '품목명(예: 26.04월분 전기안전관리비)',
    document_no         VARCHAR(30)    NOT NULL COMMENT '문서고유번호(homeid)',
    issue_date          VARCHAR(8)     NULL COMMENT '발행일자 yyyyMMdd',
    -- 금액 (템플릿 복사 또는 직접 입력)
    supply_total        DECIMAL(15,0)   NOT NULL DEFAULT 0,
    tax_total           DECIMAL(15,0)   NOT NULL DEFAULT 0,
    grand_total         DECIMAL(15,0)   NOT NULL DEFAULT 0,
    cash                DECIMAL(15,0)   NOT NULL DEFAULT 0,
    scheck              DECIMAL(15,0)   NOT NULL DEFAULT 0,
    draft               DECIMAL(15,0)   NOT NULL DEFAULT 0,
    uncollected         DECIMAL(15,0)   NOT NULL DEFAULT 0,
    unit                VARCHAR(20)     NULL,
    quantity            VARCHAR(20)     NULL,
    unit_price          DECIMAL(15,0)   NULL,
    supply_price        DECIMAL(15,0)   NULL,
    tax_amount          DECIMAL(15,0)   NULL,
    description         VARCHAR(200)    NULL,
    purpose_type        VARCHAR(10)     NULL,
    party_type_code     VARCHAR(10)     NULL,
    type_code1          VARCHAR(10)     NULL,
    type_code2          VARCHAR(10)     NULL,
    sub_keyno           VARCHAR(10)     NULL,
    -- 전송 상태
    send_yn             CHAR(1)         NOT NULL DEFAULT 'N' COMMENT '전송여부 Y/N',
    status              VARCHAR(10)     NULL COMMENT '전송결과코드(0=성공 등)',
    error_msg           VARCHAR(500)    NULL COMMENT '전송 실패 시 메시지',
    sent_at             DATETIME        NULL COMMENT '전송 일시',
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_bill_invoice_log_provider (provider_id),
    KEY idx_bill_invoice_log_recipient (recipient_id),
    KEY idx_bill_invoice_log_issue_date (issue_date),
    KEY idx_bill_invoice_log_send_yn (send_yn),
    KEY idx_bill_invoice_log_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'bill 발행내역';


-- 7) 문서번호 발급용 (공급자별 다음 번호)
CREATE TABLE ht_bill_document_key (
    id              INT             NOT NULL AUTO_INCREMENT COMMENT 'PK',
    provider_id     INT             NOT NULL COMMENT '공급자 bill_provider.id',
    prefix          VARCHAR(20)     NULL COMMENT '번호 접두어(선택)',
    next_no         INT             NOT NULL DEFAULT 1 COMMENT '다음 발급할 순번',
    updated_at      DATETIME        NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_bill_doc_key_provider (provider_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT 'bill 문서번호 발급';
