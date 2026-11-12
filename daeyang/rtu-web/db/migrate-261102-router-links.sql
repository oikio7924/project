-- 2026-11-02 라우터 ↔ 발전소를 다대다 연결로 변경 (rtm_* 테이블이 비어 있을 때 1회 실행)
-- 이유: keyno 145(민정·영자·재두)는 라우터가 발전소마다 1대씩 3대, 윤서 4~7호·한빛 1·2·5호는 라우터 1대를 같이 씀
-- 새로 설치하는 서버는 db/schema.sql 만 실행하면 되고 이 파일은 필요 없다.
ALTER TABLE rtm_plant  DROP COLUMN router_id;
ALTER TABLE rtm_router DROP COLUMN plant_id;
CREATE TABLE IF NOT EXISTS rtm_router_plant (
  router_id   VARCHAR(10)  NOT NULL COMMENT '라우터 ID (rtm_router.router_id)',
  plant_id    VARCHAR(10)  NOT NULL COMMENT '발전소 ID (rtm_plant.plant_id)',
  linked_at   DATE         NULL     COMMENT '이 발전소에 연결(설치)한 날',
  unlinked_at DATE         NULL     COMMENT '연결 해제(회수·교체)한 날, 지금 연결 중이면 NULL',
  note        VARCHAR(500) NULL     COMMENT '연결 메모 (예: 공용 라우터)',
  PRIMARY KEY (router_id, plant_id),
  KEY idx_rtm_rp_plant (plant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='RTU 통합관리 - 라우터와 발전소 연결 (다대다)';
GRANT SELECT, INSERT, UPDATE, DELETE ON monitering.rtm_router_plant TO 'rtuweb'@'localhost';
