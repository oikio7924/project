"use strict";

// ── 테이블명 ─────────────────────────────────────────────────
// DB 전환 시 이 객체만 수정하면 됩니다.
const T = {
  plant:        "dy_power_plant",
  inverterData: "dy_inverter_data",
  inverterMain: "dy_inverter_data_main",
  inverterError:"dy_inverter_error",
  user:         "u_userinfo",
  board:        "b_board_notice",
  construction: "dm_construction",
  contacts:     "dm_construction_contacts",
};

// ── 서브쿼리 ─────────────────────────────────────────────────
const latestMainSub =
  `SELECT DDM_DPP_KEYNO,` +
  ` MAX(DDM_D_DATA + 0) AS today_kwh,` +
  ` MAX(DDM_P_DATA + 0) AS yesterday_kwh,` +
  ` MAX(DDM_ACTIVE_P + 0) AS current_kw,` +
  ` MAX(DDM_CUL_DATA + 0) AS cumulative_kwh,` +
  ` MAX(DDM_DATE) AS last_received_at` +
  ` FROM ${T.inverterMain} GROUP BY DDM_DPP_KEYNO`;

// ── PLANT_SELECT 빌더 ────────────────────────────────────────
// 선택적 컬럼 존재 여부를 확인 후 SELECT 문 생성 (서버 시작 시 1회 실행)
let PLANT_SELECT = "";

async function buildPlantSelect(q) {
  const OPTIONAL = [
    { col: "DPP_BRAND", alias: "brand" },
    { col: "DPP_MODEL", alias: "model" },
  ];
  const [colRows] = await q(
    "SELECT COLUMN_NAME FROM information_schema.COLUMNS" +
    ` WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = '${T.plant}'` +
    " AND COLUMN_NAME IN (" + OPTIONAL.map(() => "?").join(",") + ")",
    OPTIONAL.map(o => o.col)
  );
  const existing = colRows.map(r => r.COLUMN_NAME);
  const optionalSql = OPTIONAL.map(o =>
    existing.includes(o.col) ? `p.${o.col} AS ${o.alias}` : `'' AS ${o.alias}`
  ).join(", ");

  PLANT_SELECT =
    `SELECT p.DPP_KEYNO AS id, p.DPP_NAME AS name, p.DPP_AREA AS region,` +
    ` p.DPP_LOCATION AS address, p.DPP_X_LOCATION AS lat, p.DPP_Y_LOCATION AS lng,` +
    ` CAST(p.DPP_VOLUM AS DECIMAL(12,2)) AS capacity_kw,` +
    ` p.DPP_INVER_COUNT AS inverter_count, p.DPP_INVER AS inv_brand, p.DPP_DATE AS registered_at,` +
    ` ${optionalSql},` +
    ` m.today_kwh, m.yesterday_kwh, m.current_kw, m.cumulative_kwh, m.last_received_at` +
    ` FROM ${T.plant} p` +
    ` LEFT JOIN (${latestMainSub}) m` +
    ` ON m.DDM_DPP_KEYNO = CONVERT(CAST(p.DPP_KEYNO AS CHAR) USING utf8mb4) `;
}

function getPlantSelect() { return PLANT_SELECT; }

// ── SQL 쿼리 ─────────────────────────────────────────────────
const SQL = {

  // ── 인증 ──────────────────────────────────────────────────
  login:
    `SELECT UI_KEYNO, UI_ID, UI_NAME, UI_PASSWORD, UI_EMAIL` +
    ` FROM ${T.user} WHERE UI_ID = ? AND UI_DELYN = 'N' AND UI_LOCKYN = 'N' LIMIT 1`,

  loginUpdateMeta:
    `UPDATE ${T.user} SET UI_LASTLOGIN = NOW(), UI_LOGIN_COUNT = UI_LOGIN_COUNT + 1 WHERE UI_KEYNO = ?`,

  // ── 대시보드 ───────────────────────────────────────────────
  dashboardSummary:
    `SELECT COUNT(DISTINCT p.DPP_KEYNO) AS total_sites,` +
    ` SUM(CASE WHEN m.current_kw > 0 THEN 1 ELSE 0 END) AS running,` +
    ` IFNULL(SUM(m.current_kw), 0) AS total_output_kw,` +
    ` IFNULL(SUM(m.today_kwh), 0) / 1000 AS today_mwh,` +
    ` IFNULL(SUM(m.yesterday_kwh), 0) / 1000 AS yesterday_mwh,` +
    ` IFNULL(SUM(m.cumulative_kwh), 0) / 1000000 AS cumulative_gwh,` +
    ` IFNULL(SUM(CAST(p.DPP_VOLUM AS DECIMAL(12,2))), 0) AS total_capacity_kw` +
    ` FROM ${T.plant} p` +
    ` LEFT JOIN (${latestMainSub}) m` +
    ` ON m.DDM_DPP_KEYNO = CONVERT(CAST(p.DPP_KEYNO AS CHAR) USING utf8mb4)` +
    ` WHERE p.DPP_DEL_YN = 'N' AND p.DPP_STATUS = 'Y'`,

  // ── 발전소 인버터 최신 상태 ────────────────────────────────
  inverterLatest:
    `SELECT d.DI_NAME, d.Active_Power, d.Work_Mode, d.DSP_Error_Code, d.Conn_date` +
    ` FROM ${T.inverterData} d` +
    ` INNER JOIN (` +
    `   SELECT DI_NAME, MAX(Conn_date) AS max_date` +
    `   FROM ${T.inverterData} WHERE DP_KEYNO = ? GROUP BY DI_NAME` +
    ` ) latest ON d.DI_NAME = latest.DI_NAME AND d.Conn_date = latest.max_date` +
    ` WHERE d.DP_KEYNO = ? ORDER BY d.DI_NAME`,

  // ── 금일 발전 시간 계산 ────────────────────────────────────
  todayGenHours:
    `SELECT COUNT(DISTINCT CONCAT(DATE_FORMAT(Conn_date,'%H:'), LPAD(FLOOR(MINUTE(Conn_date)/10)*10,2,'0'))) AS slot_cnt` +
    ` FROM ${T.inverterData}` +
    ` WHERE DP_KEYNO = ? AND DATE(Conn_date) = CURDATE() AND Active_Power > 0`,

  // ── 인버터 실시간 상세 ─────────────────────────────────────
  inverterDetail:
    `SELECT DI_NAME, Active_Power, Daily_Generation, Cumulative_Generation, Work_Mode,` +
    ` DSP_Error_Code, DSP_Alarm_Code, Conn_date,` +
    ` Phase_voltage_of_phase_A, Phase_voltage_of_phase_B, Phase_voltage_of_phase_C,` +
    ` Current_of_phase_A, Current_of_phase_B, Current_of_phase_C,` +
    ` Internal_temperature, Grid_Frequency` +
    ` FROM ${T.inverterData} WHERE DP_KEYNO = ? ORDER BY DI_NAME`,

  // ── 알람 (동적 LIMIT, siteId 조건 선택적) ─────────────────
  alarms: (hasSiteId, limit) =>
    `SELECT DIE_DPP_NAME, DIE_INVERTER_NAME, DIE_DSP_ERROR, DIE_DSP_S_ERROR,` +
    ` DIE_DATE, DIE_ARM_ALARM, DIE_ARM_ERROR` +
    ` FROM ${T.inverterError}` +
    (hasSiteId ? ` WHERE DIE_DPP_KEYNO = ?` : ``) +
    ` ORDER BY DIE_KEYNO DESC LIMIT ${limit}`,

  // ── 시간대별 발전량 ────────────────────────────────────────
  hourlyLatestDate:
    `SELECT DATE(Conn_date) AS d FROM ${T.inverterData}` +
    ` WHERE DP_KEYNO = ? ORDER BY Conn_date DESC LIMIT 1`,

  // Daily_Generation 이월분 제거: 인버터별 당일 최솟값 차감
  hourly: (invFilter) =>
    `SELECT slot_time, SUM(kw) AS kw, SUM(kwh) AS kwh` +
    ` FROM (` +
    `   SELECT d.DI_NAME, d.slot_time, d.kw,` +
    `     GREATEST(0, d.max_dg - COALESCE(b.min_dg, 0)) AS kwh` +
    `   FROM (` +
    `     SELECT DI_NAME,` +
    `       CONCAT(DATE_FORMAT(Conn_date,'%H:'), LPAD(FLOOR(MINUTE(Conn_date)/10)*10,2,'0')) AS slot_time,` +
    `       AVG(COALESCE(Active_Power, 0)) AS kw,` +
    `       MAX(COALESCE(Daily_Generation + 0, 0)) AS max_dg` +
    `     FROM ${T.inverterData}` +
    `     WHERE DP_KEYNO = ? AND DATE(Conn_date) = ?${invFilter}` +
    `     GROUP BY DI_NAME, slot_time` +
    `   ) d` +
    `   LEFT JOIN (` +
    `     SELECT DI_NAME, MIN(COALESCE(Daily_Generation + 0, 0)) AS min_dg` +
    `     FROM ${T.inverterData}` +
    `     WHERE DP_KEYNO = ? AND DATE(Conn_date) = ?${invFilter}` +
    `     GROUP BY DI_NAME` +
    `   ) b ON d.DI_NAME = b.DI_NAME` +
    ` ) t GROUP BY slot_time ORDER BY slot_time`,

  // ── 게시판 ─────────────────────────────────────────────────
  boardCount: (where) => `SELECT COUNT(*) AS total FROM ${T.board} ${where}`,

  boardList: (where) =>
    `SELECT BN_KEYNO AS id, BN_CATEGORY_NAME AS category, BN_PLANT_NAME AS site_name,` +
    ` BN_TITLE AS title, BN_REGNM AS author, BN_HITS AS views, DATE(BN_REGDT) AS created_at` +
    ` FROM ${T.board} ${where} ORDER BY BN_REGDT DESC, BN_KEYNO DESC LIMIT 200`,

  boardInsert:
    `INSERT INTO ${T.board}` +
    ` (BN_CATEGORY_NAME, BN_PLANT_NAME, BN_TITLE, BN_REGNM, BN_REGDT, BN_HITS, BN_DEL_YN, BN_CONTENTS)` +
    ` VALUES (?,?,?,?,NOW(),0,'N','')`,

  boardUpdate:
    `UPDATE ${T.board} SET BN_CATEGORY_NAME=?, BN_PLANT_NAME=?, BN_TITLE=? WHERE BN_KEYNO=?`,

  boardDelete:
    `UPDATE ${T.board} SET BN_DEL_YN='Y' WHERE BN_KEYNO=?`,

  // ── 공사현황 ───────────────────────────────────────────────
  constructionSite:
    `SELECT DPP_KEYNO AS id, DPP_NAME AS name FROM ${T.plant}` +
    ` WHERE DPP_KEYNO = ? AND DPP_DEL_YN = 'N' LIMIT 1`,

  constructionContacts:
    `SELECT id, code, name, dept, position, phone FROM ${T.contacts} ORDER BY sort_order, id`,

  constructionGet:
    `SELECT * FROM ${T.construction} WHERE site_id = ? LIMIT 1`,

  constructionContactByCode:
    `SELECT id FROM ${T.contacts} WHERE code = ? LIMIT 1`,

  constructionCheck:
    `SELECT site_id FROM ${T.construction} WHERE site_id = ? LIMIT 1`,

  constructionUpdate:
    `UPDATE ${T.construction}` +
    ` SET current_step=?, operator_business=?, operator_address=?,` +
    ` operator_phone=?, operator_email=?, permit_plant_name=?, permit_capacity=?,` +
    ` permit_location=?, permit_install_type=?, permit_received_at=?, permit_expected_at=?,` +
    ` selected_contact_id=? WHERE site_id=?`,

  constructionInsert:
    `INSERT INTO ${T.construction}` +
    ` (site_id, current_step, operator_business, operator_address,` +
    ` operator_phone, operator_email, permit_plant_name, permit_capacity,` +
    ` permit_location, permit_install_type, permit_received_at, permit_expected_at,` +
    ` selected_contact_id) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)`,

  // ── 개인설정 ───────────────────────────────────────────────
  settingsGet:
    `SELECT UI_ID, UI_EMAIL, UI_PHONE FROM ${T.user} WHERE UI_KEYNO = ? LIMIT 1`,

  settingsUpdateWithPw:
    `UPDATE ${T.user}` +
    ` SET UI_PASSWORD=?, UI_EMAIL=?, UI_PHONE=?, UI_PASSWORD_CHDT=NOW() WHERE UI_KEYNO=?`,

  settingsUpdate:
    `UPDATE ${T.user} SET UI_EMAIL=?, UI_PHONE=? WHERE UI_KEYNO=?`,
};

module.exports = { T, SQL, buildPlantSelect, getPlantSelect };
