-- 2026-11-23 인버터 구성에 인버터 S/N 칸 추가 (사용자 요청: 비고 대신 전용 칸)
ALTER TABLE rtm_inverter
  ADD COLUMN inv_sn VARCHAR(500) NULL
    COMMENT '인버터 S/N (한 대면 하나, 여러 대를 한 줄에 적으면 쉼표로 구분, 예: 7060KMTB216W0385)'
    AFTER model;
