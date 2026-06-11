/**
 * dy_power_plant (원격 monitering) → dm_plant (로컬 dmweb) 복사 스크립트
 * 원본 데이터는 건드리지 않음 (읽기 전용)
 *
 * 실행: node scripts/migrate-plant-data.js
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

// DPP_VOLUM: "100kW", "100.5", "100 kW" 등 → 숫자만 추출
function parseCapacity(val) {
  if (!val) return 0;
  const n = parseFloat(String(val).replace(/[^0-9.]/g, ""));
  return isNaN(n) ? 0 : n;
}

// DPP_STATUS: 개통 상태 → CHAR(1) Y/N
function parseGridStatus(val) {
  if (!val) return "N";
  const s = String(val).trim().toUpperCase();
  if (s === "Y" || s.includes("개통") && !s.includes("미")) return "Y";
  return "N";
}

function rowToValues(r) {
  return [
    r.DPP_KEYNO,                              // id (원본 PK 유지 — inverter_data.site_id와 일치시키기 위해)
    r.DPP_NAME   || "",                        // name
    r.DPP_AREA   || "",                        // region
    r.DPP_LOCATION || "",                      // address
    r.DPP_Y_LOCATION || null,                  // lat (Y좌표 = 위도)
    r.DPP_X_LOCATION || null,                  // lng (X좌표 = 경도)
    parseCapacity(r.DPP_VOLUM),               // capacity_kw
    r.DPP_INVER_COUNT || 0,                   // inverter_count
    r.DPP_INVER  || "",                        // inv_brand
    "",                                        // brand (원본에 없음)
    "",                                        // model (원본에 없음)
    (r.DPP_SN    || "").substring(0, 100),    // inverter_sn (3000→100 truncate)
    parseGridStatus(r.DPP_STATUS),            // grid_status
    (r.DPP_USER  || "").substring(0, 20) || null, // owner_id (100→20 truncate)
    r.DPP_DEL_YN || "N",                      // del_yn
    r.DPP_DATE   || null,                      // registered_at
  ];
}

const INSERT_SQL =
  "INSERT INTO dm_plant " +
  "(id, name, region, address, lat, lng, capacity_kw, inverter_count, " +
  " inv_brand, brand, model, inverter_sn, grid_status, owner_id, del_yn, registered_at) " +
  "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) " +
  "ON DUPLICATE KEY UPDATE " +
  "  name=VALUES(name), region=VALUES(region), address=VALUES(address), " +
  "  lat=VALUES(lat), lng=VALUES(lng), capacity_kw=VALUES(capacity_kw), " +
  "  inverter_count=VALUES(inverter_count), inv_brand=VALUES(inv_brand), " +
  "  inverter_sn=VALUES(inverter_sn), grid_status=VALUES(grid_status), " +
  "  owner_id=VALUES(owner_id), del_yn=VALUES(del_yn), registered_at=VALUES(registered_at)";

async function run() {
  console.log("원격 DB 연결 중...");
  const src = await mysql.createConnection(SRC);
  console.log("로컬 DB 연결 중...");
  const dst = await mysql.createConnection(DST);

  const [rows] = await src.execute(
    "SELECT * FROM dy_power_plant WHERE DPP_DEL_YN = 'N' ORDER BY DPP_KEYNO"
  );
  console.log(`총 ${rows.length}개 발전소 복사 시작`);

  let copied = 0;
  for (const row of rows) {
    const vals = rowToValues(row);
    await dst.execute(INSERT_SQL, vals);
    copied++;
    process.stdout.write(`\r진행: ${copied} / ${rows.length}`);
  }

  console.log(`\n완료: ${copied}개 발전소 복사됨`);
  await src.end();
  await dst.end();
}

run().catch((e) => { console.error("\n오류:", e.message); process.exit(1); });
