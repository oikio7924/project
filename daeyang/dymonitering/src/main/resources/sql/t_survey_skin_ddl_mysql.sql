-- T_SURVEY_SKIN 테이블이 없을 때 설문 스킨 초기화 오류 방지용
-- (설문 기능 미사용 시 이 테이블이 없으면 CommonPublishServiceImpl.init() 시 오류 발생)
-- MySQL에서 테이블명은 소문자로 저장될 수 있음 (lower_case_table_names 설정에 따름)

CREATE TABLE IF NOT EXISTS T_SURVEY_SKIN (
    SS_KEYNO      VARCHAR(50)   NOT NULL COMMENT 'PK',
    SS_DATA       LONGTEXT      NULL COMMENT '스킨 데이터',
    SS_SKIN_NAME  VARCHAR(200)  NULL COMMENT '스킨명',
    SS_DEL_YN     CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제여부',
    SS_REGDT      DATETIME      NULL COMMENT '등록일시',
    SS_REGNM      VARCHAR(50)   NULL COMMENT '등록자 KEYNO',
    SS_MODDT      DATETIME      NULL COMMENT '수정일시',
    SS_MODNM      VARCHAR(50)   NULL COMMENT '수정자 KEYNO',
    PRIMARY KEY (SS_KEYNO),
    KEY idx_ss_del_yn (SS_DEL_YN)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT '설문 스킨';
