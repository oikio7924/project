-- rtu-web 전용 DB 계정 (DB root 로 1회 실행)
-- 비밀번호는 이 파일에 적지 않는다. 실행할 때 @pw 에 넣고, 같은 값을 서버 .env 의 MARIADB_PASSWORD 에 넣는다.
--   mysql -e "SET @pw='새 비밀번호'; SOURCE db/grant.sql;"
-- 권한 범위
--   rtm_*            : 읽기·쓰기 (rtu-web 전용 테이블)
--   dy_power_plant   : 읽기·추가·수정 (삭제 권한 없음)
--   u_userinfo       : 읽기만 (회원 선택 목록)

SET @create = CONCAT("CREATE USER IF NOT EXISTS 'rtuweb'@'localhost' IDENTIFIED BY '", REPLACE(@pw, "'", "''"), "'");
PREPARE s FROM @create; EXECUTE s; DEALLOCATE PREPARE s;

GRANT SELECT, INSERT, UPDATE, DELETE ON monitering.rtm_plant        TO 'rtuweb'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON monitering.rtm_device       TO 'rtuweb'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON monitering.rtm_device_plant TO 'rtuweb'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON monitering.rtm_hw_version   TO 'rtuweb'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON monitering.rtm_sw_version   TO 'rtuweb'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON monitering.rtm_setup        TO 'rtuweb'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON monitering.rtm_inverter     TO 'rtuweb'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON monitering.rtm_issue        TO 'rtuweb'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON monitering.rtm_router       TO 'rtuweb'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON monitering.rtm_router_plant TO 'rtuweb'@'localhost';
GRANT SELECT, INSERT, UPDATE         ON monitering.rtm_user         TO 'rtuweb'@'localhost';
GRANT SELECT, INSERT                 ON monitering.rtm_change_log   TO 'rtuweb'@'localhost';
GRANT SELECT, INSERT, UPDATE         ON monitering.dy_power_plant   TO 'rtuweb'@'localhost';
GRANT SELECT                         ON monitering.u_userinfo       TO 'rtuweb'@'localhost';
FLUSH PRIVILEGES;
