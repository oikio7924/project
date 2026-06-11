/**
 * dy_inverter_data (원격 monitering) → dm_inverter_data (로컬 dmweb) 복사 스크립트
 * 원본 데이터는 건드리지 않음 (읽기 전용)
 *
 * 실행: node scripts/migrate-inverter-data.js
 */
require("dotenv").config();
const mysql = require("mysql2/promise");

const SRC = {
  host: "139.150.73.219",
  port: 3306,
  user: process.env.MARIADB_USER || "root",
  password: process.env.MARIADB_PASSWORD,
  database: "monitering",
  charset: "utf8mb4",
  dateStrings: true,
};

const DST = {
  host: process.env.MARIADB_HOST || "127.0.0.1",
  port: Number(process.env.MARIADB_PORT || 3306),
  user: process.env.MARIADB_USER || "root",
  password: process.env.MARIADB_PASSWORD,
  database: process.env.MARIADB_DATABASE || "dmweb",
  charset: "utf8mb4",
  dateStrings: true,
};

const BATCH = 2000;

const INSERT_SQL =
  "INSERT IGNORE INTO dm_inverter_data (" +
  "site_id, inverter_name, collected_at," +
  "active_power, daily_gen, cumulative_gen, total_gen_hour," +
  "work_mode, grid_frequency," +
  "volt_ab, volt_bc, volt_ca, volt_a, volt_b, volt_c," +
  "curr_a, curr_b, curr_c, freq_a, freq_b, freq_c," +
  "vpv1,ipv1,ppv1, vpv2,ipv2,ppv2, vpv3,ipv3,ppv3," +
  "vpv4,ipv4,ppv4, vpv5,ipv5,ppv5, vpv6,ipv6,ppv6," +
  "vpv7,ipv7,ppv7, vpv8,ipv8,ppv8, vpv9,ipv9,ppv9," +
  "vpv10,ipv10,ppv10, vpv11,ipv11,ppv11, vpv12,ipv12,ppv12," +
  "vpv13,ipv13,ppv13, vpv14,ipv14,ppv14, vpv15,ipv15,ppv15," +
  "vpv16,ipv16,ppv16, vpv17,ipv17,ppv17, vpv18,ipv18,ppv18," +
  "vpv19,ipv19,ppv19, vpv20,ipv20,ppv20, vpv21,ipv21,ppv21," +
  "vpv22,ipv22,ppv22, vpv23,ipv23,ppv23, vpv24,ipv24,ppv24," +
  "istr1,istr2,istr3,istr4,istr5,istr6," +
  "istr7,istr8,istr9,istr10,istr11,istr12," +
  "istr13,istr14,istr15,istr16,istr17,istr18," +
  "istr19,istr20,istr21,istr22,istr23,istr24," +
  "temperature, cabinet_temp," +
  "dsp_error, dsp_alarm, slave_dsp_error, slave_dsp_alarm," +
  "pv_string_fault, temp_fault, safety_code," +
  "phase_type, power_capacity, rated_line_voltage" +
  ") VALUES ?";

function rowToValues(r) {
  return [
    r.DP_KEYNO, r.DI_NAME, r.Conn_date,
    r.Active_Power, r.Daily_Generation, r.Cumulative_Generation, r.Total_Generation_Hour,
    r.Work_Mode, r.Grid_Frequency,
    r.voltage_of_phase_A_to_B, r.voltage_of_phase_B_to_C, r.voltage_of_phase_C_to_A,
    r.Phase_voltage_of_phase_A, r.Phase_voltage_of_phase_B, r.Phase_voltage_of_phase_C,
    r.Current_of_phase_A, r.Current_of_phase_B, r.Current_of_phase_C,
    r.Frequency_of_phase_A, r.Frequency_of_phase_B, r.Frequency_of_phase_C,
    r.Vpv1,r.Ipv1,r.Ppv1, r.Vpv2,r.Ipv2,r.Ppv2, r.Vpv3,r.Ipv3,r.Ppv3,
    r.Vpv4,r.Ipv4,r.Ppv4, r.Vpv5,r.Ipv5,r.Ppv5, r.Vpv6,r.Ipv6,r.Ppv6,
    r.Vpv7,r.Ipv7,r.Ppv7, r.Vpv8,r.Ipv8,r.Ppv8, r.Vpv9,r.Ipv9,r.Ppv9,
    r.Vpv10,r.Ipv10,r.Ppv10, r.Vpv11,r.Ipv11,r.Ppv11, r.Vpv12,r.Ipv12,r.Ppv12,
    r.Vpv13,r.Ipv13,null, r.Vpv14,r.Ipv14,null, r.Vpv15,r.Ipv15,null,
    r.Vpv16,r.Ipv16,null, r.Vpv17,r.Ipv17,null, r.Vpv18,r.Ipv18,null,
    r.Vpv19,r.Ipv19,null, r.Vpv20,r.Ipv20,null, r.Vpv21,r.Ipv21,null,
    r.Vpv22,r.Ipv22,null, r.Vpv23,r.Ipv23,null, r.Vpv24,r.Ipv24,null,
    r.Istr1,r.Istr2,r.Istr3,r.Istr4,r.Istr5,r.Istr6,
    r.Istr7,r.Istr8,r.Istr9,r.Istr10,r.Istr11,r.Istr12,
    r.Istr13,r.Istr14,r.Istr15,r.Istr16,r.Istr17,r.Istr18,
    r.Istr19,r.Istr20,r.Istr21,r.Istr22,r.Istr23,r.Istr24,
    r.Internal_temperature, r.Cabinet_Temperature_2,
    r.DSP_Error_Code, r.DSP_Alarm_Code, r.Slave_DSP_ErrorCode, r.Slave_DSP_AlarmCode,
    r.PV_String_Fault_Bit, r.Temperature_Fault_Bit, r.Safety_Code,
    r.Phase, r.PowerCapacity, r.RatedLineVoltage,
  ];
}

async function run() {
  console.log("원격 DB 연결 중...");
  const src = await mysql.createConnection(SRC);
  console.log("로컬 DB 연결 중...");
  const dst = await mysql.createConnection(DST);

  // 전체 건수 확인
  const [[{ total }]] = await src.execute("SELECT COUNT(*) AS total FROM dy_inverter_data");
  console.log(`전체 ${Number(total).toLocaleString()} 건 복사 시작 (배치: ${BATCH}건)`);

  let offset = 0;
  let copied = 0;

  while (offset < total) {
    const [rows] = await src.execute(
      "SELECT * FROM dy_inverter_data ORDER BY Conn_date, DP_KEYNO LIMIT ? OFFSET ?",
      [BATCH, offset]
    );
    if (!rows.length) break;

    const values = rows.map(rowToValues);
    await dst.query(INSERT_SQL, [values]);

    copied += rows.length;
    offset += rows.length;
    const pct = ((offset / total) * 100).toFixed(1);
    process.stdout.write(`\r진행: ${offset.toLocaleString()} / ${Number(total).toLocaleString()} (${pct}%)`);
  }

  console.log(`\n완료: ${copied.toLocaleString()} 건 복사됨`);
  await src.end();
  await dst.end();
}

run().catch((e) => { console.error("\n오류:", e.message); process.exit(1); });
