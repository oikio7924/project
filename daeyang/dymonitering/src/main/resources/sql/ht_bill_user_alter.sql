-- ht_bill_user 확장: 권한/기본공급자/회원정보
-- 실행 전/후 백업 권장

-- 이미 컬럼이 있으면 아래 ADD는 에러가 납니다.
-- 필요한 컬럼만 골라 실행하세요. (권장: 아래 4개만 먼저 추가)
--
-- 1) 회원가입 모달용 추가 컬럼
ALTER TABLE ht_bill_user ADD COLUMN department VARCHAR(100) NULL AFTER name;
ALTER TABLE ht_bill_user ADD COLUMN phone VARCHAR(50) NULL AFTER department;
ALTER TABLE ht_bill_user ADD COLUMN extension_no VARCHAR(30) NULL AFTER phone;
ALTER TABLE ht_bill_user ADD COLUMN email VARCHAR(200) NULL AFTER extension_no;
--
-- 2) (이미 적용했다면 실행하지 마세요)
-- ALTER TABLE ht_bill_user ADD COLUMN role VARCHAR(30) NULL AFTER use_yn;
-- ALTER TABLE ht_bill_user ADD COLUMN default_provider_id INT NULL AFTER role;

CREATE UNIQUE INDEX uq_ht_bill_user_login_id ON ht_bill_user (login_id);
-- 로그인 아이디 중복 방지 (이미 있으면 무시/에러 발생 가능)
-- 환경에 따라 index명이 다를 수 있으니 필요시 이름 조정

