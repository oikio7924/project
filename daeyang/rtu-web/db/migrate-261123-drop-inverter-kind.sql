-- 2026-11-23 인버터 구성 "구성 구분"(세팅 요청/실설치) 칸 삭제 (사용자 결정: 한 대 한 줄이 되면서 필요 없음)
-- ※ 순서: kind 를 안 쓰는 rtu-web 코드를 먼저 배포한 뒤에 실행할 것 (예전 코드는 요청서 저장 때 kind 에 값을 넣음)
-- 예전 값은 rtm_change_log 변경 이력에 남아 있음
ALTER TABLE rtm_inverter DROP COLUMN kind;
