-- ============================================================
--  monitering DB → dmweb DB 데이터 마이그레이션
--  실행 전 dmweb DB에 schema.sql 먼저 적용할 것
--  적용: mysql -u root -p < db/migrate.sql
-- ============================================================
SET NAMES utf8mb4;

-- ── 발전소 ──────────────────────────────────────────────────
INSERT INTO dmweb.dm_plant
  (id, name, region, address, lat, lng, capacity_kw,
   inverter_count, inv_brand, brand, model, inverter_sn,
   grid_status, owner_id, del_yn, registered_at)
SELECT
  DPP_KEYNO,
  COALESCE(DPP_NAME,     ''),
  COALESCE(DPP_AREA,     ''),
  COALESCE(DPP_LOCATION, ''),
  NULLIF(DPP_X_LOCATION, ''),
  NULLIF(DPP_Y_LOCATION, ''),
  CAST(COALESCE(NULLIF(DPP_VOLUM,''), '0') AS DECIMAL(12,2)),
  COALESCE(DPP_INVER_COUNT, 0),
  COALESCE(DPP_INVER,    ''),
  COALESCE(DPP_BRAND,    ''),
  COALESCE(DPP_MODEL,    ''),
  COALESCE(DPP_SN,       ''),
  COALESCE(DPP_STATUS,   'N'),
  DPP_USER,
  COALESCE(DPP_DEL_YN,   'N'),
  DPP_DATE
FROM monitering.dy_power_plant;

-- ── 인버터 실시간 수집 데이터 (대용량 — 시간 소요 가능) ────────
INSERT INTO dmweb.dm_inverter_data (
  site_id, inverter_name, collected_at,
  active_power, daily_gen, cumulative_gen, total_gen_hour,
  work_mode, grid_frequency,
  volt_ab, volt_bc, volt_ca,
  volt_a, volt_b, volt_c,
  curr_a, curr_b, curr_c,
  freq_a, freq_b, freq_c,
  vpv1,  ipv1,  ppv1,  vpv2,  ipv2,  ppv2,
  vpv3,  ipv3,  ppv3,  vpv4,  ipv4,  ppv4,
  vpv5,  ipv5,  ppv5,  vpv6,  ipv6,  ppv6,
  vpv7,  ipv7,  ppv7,  vpv8,  ipv8,  ppv8,
  vpv9,  ipv9,  ppv9,  vpv10, ipv10, ppv10,
  vpv11, ipv11, ppv11, vpv12, ipv12, ppv12,
  vpv13, ipv13, ppv13, vpv14, ipv14, ppv14,
  vpv15, ipv15, ppv15, vpv16, ipv16, ppv16,
  vpv17, ipv17, ppv17, vpv18, ipv18, ppv18,
  vpv19, ipv19, ppv19, vpv20, ipv20, ppv20,
  vpv21, ipv21, ppv21, vpv22, ipv22, ppv22,
  vpv23, ipv23, ppv23, vpv24, ipv24, ppv24,
  istr1,  istr2,  istr3,  istr4,  istr5,  istr6,
  istr7,  istr8,  istr9,  istr10, istr11, istr12,
  istr13, istr14, istr15, istr16, istr17, istr18,
  istr19, istr20, istr21, istr22, istr23, istr24,
  temperature, cabinet_temp,
  dsp_error, dsp_alarm, slave_dsp_error, slave_dsp_alarm,
  pv_string_fault, temp_fault, safety_code,
  phase_type, power_capacity, rated_line_voltage
)
SELECT
  COALESCE(DP_KEYNO, ''),
  COALESCE(DI_NAME,  ''),
  Conn_date,
  Active_Power,
  Daily_Generation,        Cumulative_Generation,   Total_Generation_Hour,
  Work_Mode,               Grid_Frequency,
  voltage_of_phase_A_to_B, voltage_of_phase_B_to_C, voltage_of_phase_C_to_A,
  Phase_voltage_of_phase_A, Phase_voltage_of_phase_B, Phase_voltage_of_phase_C,
  Current_of_phase_A,      Current_of_phase_B,      Current_of_phase_C,
  Frequency_of_phase_A,    Frequency_of_phase_B,    Frequency_of_phase_C,
  Vpv1,  Ipv1,  Ppv1,  Vpv2,  Ipv2,  Ppv2,
  Vpv3,  Ipv3,  Ppv3,  Vpv4,  Ipv4,  Ppv4,
  Vpv5,  Ipv5,  Ppv5,  Vpv6,  Ipv6,  Ppv6,
  Vpv7,  Ipv7,  Ppv7,  Vpv8,  Ipv8,  Ppv8,
  Vpv9,  Ipv9,  Ppv9,  Vpv10, Ipv10, Ppv10,
  Vpv11, Ipv11, Ppv11, Vpv12, Ipv12, Ppv12,
  Vpv13, Ipv13, NULL,  Vpv14, Ipv14, NULL,
  Vpv15, Ipv15, NULL,  Vpv16, Ipv16, NULL,
  Vpv17, Ipv17, NULL,  Vpv18, Ipv18, NULL,
  Vpv19, Ipv19, NULL,  Vpv20, Ipv20, NULL,
  Vpv21, Ipv21, NULL,  Vpv22, Ipv22, NULL,
  Vpv23, Ipv23, NULL,  Vpv24, Ipv24, NULL,
  Istr1,  Istr2,  Istr3,  Istr4,  Istr5,  Istr6,
  Istr7,  Istr8,  Istr9,  Istr10, Istr11, Istr12,
  Istr13, Istr14, Istr15, Istr16, Istr17, Istr18,
  Istr19, Istr20, Istr21, Istr22, Istr23, Istr24,
  Internal_temperature,    Cabinet_Temperature_2,
  DSP_Error_Code,          DSP_Alarm_Code,
  Slave_DSP_ErrorCode,     Slave_DSP_AlarmCode,
  PV_String_Fault_Bit,     Temperature_Fault_Bit,   Safety_Code,
  Phase,                   PowerCapacity,            RatedLineVoltage
FROM monitering.dy_inverter_data;

-- ── 인버터 일별 집계 ─────────────────────────────────────────
INSERT INTO dmweb.dm_inverter_main
  (site_id, today_kwh, yesterday_kwh, current_kw, cumulative_kwh, collected_at)
SELECT
  CAST(DDM_DPP_KEYNO AS UNSIGNED),
  NULLIF(DDM_D_DATA   + 0, 0),
  NULLIF(DDM_P_DATA   + 0, 0),
  NULLIF(DDM_ACTIVE_P + 0, 0),
  NULLIF(DDM_CUL_DATA + 0, 0),
  DDM_DATE
FROM monitering.dy_inverter_data_main;

-- ── 인버터 에러 로그 ─────────────────────────────────────────
INSERT INTO dmweb.dm_inverter_error
  (site_id, site_name, inverter_name,
   dsp_error, dsp_slave_error, arm_alarm, arm_error, occurred_at)
SELECT
  CAST(DIE_DPP_KEYNO AS UNSIGNED),
  COALESCE(DIE_DPP_NAME,      ''),
  COALESCE(DIE_INVERTER_NAME, ''),
  NULLIF(DIE_DSP_ERROR,   ''),
  NULLIF(DIE_DSP_S_ERROR, ''),
  NULLIF(DIE_ARM_ALARM,   ''),
  NULLIF(DIE_ARM_ERROR,   ''),
  DIE_DATE
FROM monitering.dy_inverter_error;

-- ── 사용자 ──────────────────────────────────────────────────
INSERT INTO dmweb.dm_user
  (id, username, display_name, password, email, phone,
   del_yn, lock_yn, login_count, last_login_at, password_changed_at, registered_at)
SELECT
  UI_KEYNO,
  UI_ID,
  COALESCE(UI_NAME,     ''),
  UI_PASSWORD,
  COALESCE(UI_EMAIL,    ''),
  COALESCE(UI_PHONE,    ''),
  COALESCE(UI_DELYN,    'N'),
  COALESCE(UI_LOCKYN,   'N'),
  COALESCE(UI_LOGIN_COUNT, 0),
  NULLIF(UI_LASTLOGIN,       '0000-00-00 00:00:00'),
  NULLIF(UI_PASSWORD_CHDT,   '0000-00-00 00:00:00'),
  COALESCE(NULLIF(UI_REGDT,  '0000-00-00 00:00:00'), NOW())
FROM monitering.u_userinfo;

-- ── 게시판 ──────────────────────────────────────────────────
INSERT INTO dmweb.dm_board
  (id, category, site_name, title, author, views, del_yn, contents, created_at)
SELECT
  BN_KEYNO,
  COALESCE(BN_CATEGORY_NAME, ''),
  COALESCE(BN_PLANT_NAME,    ''),
  COALESCE(BN_TITLE,         ''),
  COALESCE(BN_REGNM,         ''),
  COALESCE(BN_HITS,          0),
  COALESCE(BN_DEL_YN,        'N'),
  BN_CONTENTS,
  COALESCE(NULLIF(BN_REGDT, '0000-00-00 00:00:00'), NOW())
FROM monitering.b_board_notice;
