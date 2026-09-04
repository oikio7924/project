"use strict";

const T = {
  plant:        "dm_plant",
  inverterData: "dm_inverter_data",
  inverterMain: "dm_inverter_main",
  inverterError:"dm_inverter_error",
  user:         "dm_user",
  board:        "dm_notice",
  inverterInfo: "dm_inverter_info",
};

const latestMainSub =
  `SELECT site_id,` +
  ` MAX(today_kwh) AS today_kwh,` +
  ` MAX(yesterday_kwh) AS yesterday_kwh,` +
  ` MAX(current_kw) AS current_kw,` +
  ` MAX(cumulative_kwh) AS cumulative_kwh,` +
  ` MAX(collected_at) AS last_received_at` +
  ` FROM ${T.inverterMain} GROUP BY site_id`;

let PLANT_SELECT = "";

function buildPlantSelect() {
  PLANT_SELECT =
    `SELECT p.id, p.name, p.region,` +
    ` p.address, p.lat, p.lng,` +
    ` p.capacity_kw,` +
    ` p.inverter_count, p.inv_brand, p.registered_at,` +
    ` p.brand, p.model,` +
    ` m.today_kwh, m.yesterday_kwh, m.current_kw, m.cumulative_kwh, m.last_received_at` +
    ` FROM ${T.plant} p` +
    ` LEFT JOIN (${latestMainSub}) m ON m.site_id = p.id `;
}

function getPlantSelect() { return PLANT_SELECT; }

const SQL = {

  // ── 인증 ──────────────────────────────────────────────────
  login:
    `SELECT id, username, display_name, password, email, role` +
    ` FROM ${T.user} WHERE username = ? AND del_yn = 'N' AND lock_yn = 'N' LIMIT 1`,

  loginUpdateMeta:
    `UPDATE ${T.user} SET last_login_at = NOW(), login_count = login_count + 1 WHERE id = ?`,

  // ── 대시보드 ───────────────────────────────────────────────
  dashboardSummary:
    `SELECT COUNT(DISTINCT p.id) AS total_sites,` +
    ` SUM(CASE WHEN m.current_kw > 0 THEN 1 ELSE 0 END) AS running,` +
    ` IFNULL(SUM(m.current_kw), 0) AS total_output_kw,` +
    ` IFNULL(SUM(m.today_kwh), 0) AS today_kwh,` +
    ` IFNULL(SUM(m.yesterday_kwh), 0) AS yesterday_kwh,` +
    ` IFNULL(SUM(m.cumulative_kwh), 0) AS cumulative_kwh,` +
    ` IFNULL(SUM(p.capacity_kw), 0) AS total_capacity_kw` +
    ` FROM ${T.plant} p` +
    ` LEFT JOIN (${latestMainSub}) m ON m.site_id = p.id` +
    ` WHERE p.del_yn = 'N' AND p.grid_status = 'Y'`,

  // ── 발전소 인버터 최신 상태 ────────────────────────────────
  inverterLatest:
    `SELECT d.inverter_name, d.active_power, d.daily_gen, d.work_mode, d.dsp_error, d.collected_at,` +
    ` COALESCE(i.model, '') AS inv_model` +
    ` FROM ${T.inverterData} d` +
    ` INNER JOIN (` +
    `   SELECT inverter_name, MAX(collected_at) AS max_date` +
    `   FROM ${T.inverterData} WHERE site_id = ? GROUP BY inverter_name` +
    ` ) latest ON d.inverter_name = latest.inverter_name AND d.collected_at = latest.max_date` +
    ` LEFT JOIN ${T.inverterInfo} i ON i.site_id = ? AND i.inverter_name = d.inverter_name` +
    ` WHERE d.site_id = ? ORDER BY d.inverter_name`,

  // ── 금일 발전 시간 계산 ────────────────────────────────────
  todayGenHours:
    `SELECT COUNT(DISTINCT CONCAT(DATE_FORMAT(collected_at,'%H:'), LPAD(FLOOR(MINUTE(collected_at)/10)*10,2,'0'))) AS slot_cnt` +
    ` FROM ${T.inverterData}` +
    ` WHERE site_id = ? AND DATE(collected_at) = CURDATE() AND active_power > 0`,

  // ── 인버터 실시간 상세 ─────────────────────────────────────
  inverterDetail:
    `SELECT inverter_name, active_power, daily_gen, cumulative_gen, work_mode,` +
    ` dsp_error, dsp_alarm, collected_at,` +
    ` volt_a, volt_b, volt_c,` +
    ` curr_a, curr_b, curr_c,` +
    ` temperature, grid_frequency` +
    ` FROM ${T.inverterData} WHERE site_id = ? ORDER BY inverter_name`,

  // ── 알람 ──────────────────────────────────────────────────
  alarms: (hasSiteId, limit) =>
    `SELECT site_name, inverter_name, dsp_error, dsp_slave_error,` +
    ` occurred_at, arm_alarm, arm_error` +
    ` FROM ${T.inverterError}` +
    (hasSiteId ? ` WHERE site_id = ?` : ``) +
    ` ORDER BY id DESC LIMIT ${limit}`,

  // ── 시간대별 발전량 ────────────────────────────────────────
  hourlyLatestDate:
    `SELECT DATE(collected_at) AS d FROM ${T.inverterData}` +
    ` WHERE site_id = ? ORDER BY collected_at DESC LIMIT 1`,

  hourlyPerInverter: (invFilter) =>
    `SELECT inverter_name, slot_time, kw, kwh FROM (` +
    `   SELECT inverter_name,` +
    `     CONCAT(DATE_FORMAT(collected_at,'%H:'), LPAD(FLOOR(MINUTE(collected_at)/10)*10,2,'0')) AS slot_time,` +
    `     AVG(COALESCE(active_power, 0)) AS kw,` +
    `     GREATEST(0, MAX(COALESCE(daily_gen+0,0)) - MIN(COALESCE(daily_gen+0,0))) AS kwh` +
    `   FROM ${T.inverterData}` +
    `   WHERE site_id = ? AND DATE(collected_at) = ?${invFilter}` +
    `   GROUP BY inverter_name, slot_time` +
    ` ) t ORDER BY slot_time DESC, inverter_name`,

  hourly: (invFilter) =>
    `SELECT slot_time, SUM(kw) AS kw, SUM(kwh) AS kwh` +
    ` FROM (` +
    `   SELECT d.inverter_name, d.slot_time, d.kw,` +
    `     GREATEST(0, d.max_dg - COALESCE(b.min_dg, 0)) AS kwh` +
    `   FROM (` +
    `     SELECT inverter_name,` +
    `       CONCAT(DATE_FORMAT(collected_at,'%H:'), LPAD(FLOOR(MINUTE(collected_at)/10)*10,2,'0')) AS slot_time,` +
    `       AVG(COALESCE(active_power, 0)) AS kw,` +
    `       MAX(COALESCE(daily_gen + 0, 0)) AS max_dg` +
    `     FROM ${T.inverterData}` +
    `     WHERE site_id = ? AND DATE(collected_at) = ?${invFilter}` +
    `     GROUP BY inverter_name, slot_time` +
    `   ) d` +
    `   LEFT JOIN (` +
    `     SELECT inverter_name, MIN(COALESCE(daily_gen + 0, 0)) AS min_dg` +
    `     FROM ${T.inverterData}` +
    `     WHERE site_id = ? AND DATE(collected_at) = ?${invFilter}` +
    `     GROUP BY inverter_name` +
    `   ) b ON d.inverter_name = b.inverter_name` +
    ` ) t GROUP BY slot_time ORDER BY slot_time`,

  // ── 공지사항 ────────────────────────────────────────────────
  boardCount: (where) => `SELECT COUNT(*) AS total FROM ${T.board} n ${where}`,

  boardList: (where) =>
    `SELECT n.id, n.category, n.tags, n.site_name, n.title, n.author, n.views, n.contents, DATE_FORMAT(n.created_at, '%Y-%m-%d %H:%i') AS created_at,` +
    ` (SELECT COUNT(*) FROM dm_notice_files f WHERE f.notice_id = n.id) AS file_count` +
    ` FROM ${T.board} n ${where} ORDER BY n.created_at DESC, n.id DESC LIMIT 200`,

  boardInsert:
    `INSERT INTO ${T.board}` +
    ` (category, tags, site_name, title, author, contents, views, del_yn)` +
    ` VALUES (?,?,?,?,?,?,0,'N')`,

  boardUpdate:
    `UPDATE ${T.board} SET category=?, tags=?, site_name=?, title=?, contents=? WHERE id=?`,

  boardDelete:
    `UPDATE ${T.board} SET del_yn='Y' WHERE id=?`,

  // ── 공지사항 첨부파일 ─────────────────────────────────────────
  noticeViewInc:
    `UPDATE dm_notice SET views = views + 1 WHERE id = ? AND del_yn = 'N'`,

  noticeFiles:
    `SELECT id, original_name, filename, size, mimetype, uploaded_at` +
    ` FROM dm_notice_files WHERE notice_id = ? ORDER BY uploaded_at`,

  noticeFileInsert:
    `INSERT INTO dm_notice_files (notice_id, filename, original_name, size, mimetype) VALUES (?,?,?,?,?)`,

  noticeFileDelete:
    `DELETE FROM dm_notice_files WHERE id = ? AND notice_id = ?`,

  noticeFileGet:
    `SELECT id, filename, original_name, notice_id FROM dm_notice_files WHERE id = ?`,


  // ── 통계: 일별 발전량 (주/월 범위) ────────────────────────────
  statsDaily:
    `SELECT DATE(collected_at) AS stat_date,` +
    ` MAX(COALESCE(today_kwh, 0)) AS kwh` +
    ` FROM ${T.inverterMain}` +
    ` WHERE site_id = ? AND DATE(collected_at) BETWEEN ? AND ?` +
    ` GROUP BY DATE(collected_at) ORDER BY stat_date`,

  // ── 통계: 월별 발전량 (연간) ───────────────────────────────────
  statsMonthly:
    `SELECT DATE_FORMAT(d, '%Y-%m') AS stat_month, SUM(kwh) AS kwh` +
    ` FROM (` +
    `   SELECT DATE(collected_at) AS d, MAX(COALESCE(today_kwh, 0)) AS kwh` +
    `   FROM ${T.inverterMain}` +
    `   WHERE site_id = ? AND YEAR(collected_at) = ?` +
    `   GROUP BY DATE(collected_at)` +
    ` ) sub` +
    ` GROUP BY stat_month ORDER BY stat_month`,

  // ── 개인설정 ───────────────────────────────────────────────
  settingsGet:
    `SELECT username, email, phone FROM ${T.user} WHERE id = ? LIMIT 1`,

  settingsUpdateWithPw:
    `UPDATE ${T.user} SET password=?, email=?, phone=?, password_changed_at=NOW() WHERE id=?`,

  settingsUpdate:
    `UPDATE ${T.user} SET email=?, phone=? WHERE id=?`,

  // ── 인버터 raw 전체 (날짜 전체, 시간대별 테이블 뷰) ─────────────
  inverterRawAll: (invFilter) =>
    `SELECT inverter_name, collected_at,` +
    ` active_power, daily_gen, cumulative_gen, total_gen_hour,` +
    ` work_mode, grid_frequency,` +
    ` volt_ab, volt_bc, volt_ca, volt_a, volt_b, volt_c,` +
    ` curr_a, curr_b, curr_c, freq_a, freq_b, freq_c,` +
    ` temperature, cabinet_temp,` +
    ` dsp_error, dsp_alarm, slave_dsp_error, slave_dsp_alarm, safety_code,` +
    ` vpv1,ipv1,ppv1, vpv2,ipv2,ppv2, vpv3,ipv3,ppv3, vpv4,ipv4,ppv4,` +
    ` vpv5,ipv5,ppv5, vpv6,ipv6,ppv6, vpv7,ipv7,ppv7, vpv8,ipv8,ppv8,` +
    ` vpv9,ipv9,ppv9, vpv10,ipv10,ppv10, vpv11,ipv11,ppv11, vpv12,ipv12,ppv12,` +
    ` istr1,istr2,istr3,istr4,istr5,istr6,` +
    ` istr7,istr8,istr9,istr10,istr11,istr12,` +
    ` istr13,istr14,istr15,istr16,istr17,istr18,` +
    ` istr19,istr20,istr21,istr22,istr23,istr24` +
    ` FROM ${T.inverterData}` +
    ` WHERE site_id = ? AND collected_at >= ? AND collected_at < DATE_ADD(?, INTERVAL 1 DAY)` +
    `${invFilter} ORDER BY collected_at DESC, inverter_name`,

  // ── 인버터 raw 데이터 (통계분석 상세보기) ───────────────────────
  inverterRaw: (invFilter) =>
    `SELECT inverter_name, collected_at,` +
    ` active_power, daily_gen, cumulative_gen, total_gen_hour,` +
    ` work_mode, grid_frequency,` +
    ` volt_ab, volt_bc, volt_ca, volt_a, volt_b, volt_c,` +
    ` curr_a, curr_b, curr_c, freq_a, freq_b, freq_c,` +
    ` temperature, cabinet_temp,` +
    ` dsp_error, dsp_alarm, slave_dsp_error, slave_dsp_alarm, safety_code,` +
    ` vpv1, ipv1, ppv1, vpv2, ipv2, ppv2,` +
    ` vpv3, ipv3, ppv3, vpv4, ipv4, ppv4,` +
    ` vpv5, ipv5, ppv5, vpv6, ipv6, ppv6,` +
    ` vpv7, ipv7, ppv7, vpv8, ipv8, ppv8,` +
    ` vpv9, ipv9, ppv9, vpv10, ipv10, ppv10,` +
    ` vpv11, ipv11, ppv11, vpv12, ipv12, ppv12,` +
    ` istr1, istr2, istr3, istr4, istr5, istr6,` +
    ` istr7, istr8, istr9, istr10, istr11, istr12,` +
    ` istr13, istr14, istr15, istr16, istr17, istr18,` +
    ` istr19, istr20, istr21, istr22, istr23, istr24` +
    ` FROM ${T.inverterData}` +
    ` WHERE site_id = ? AND DATE(collected_at) = ?` +
    ` AND CONCAT(DATE_FORMAT(collected_at,'%H:'), LPAD(FLOOR(MINUTE(collected_at)/10)*10,2,'0')) = ?` +
    `${invFilter} ORDER BY collected_at DESC, inverter_name`,
};

module.exports = { T, SQL, buildPlantSelect, getPlantSelect };
