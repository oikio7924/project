const fs = require("fs");
const path = require("path");
const { seedMapKeysFromEnv } = require("./mapSettings");

const DM_TABLES = [
  "dm_settings",
  "dm_inverter_info",
  "dm_construction",
  "dm_construction_contacts",
  "dm_notice_files",
  "dm_notice",
  "dm_user",
  "dm_inverter_error",
  "dm_inverter_detail",
  "dm_inverter_main",
  "dm_inverter_data",
  "dm_plant",
];

async function dropAllTables(db) {
  await db.execute("SET FOREIGN_KEY_CHECKS = 0");
  for (const table of DM_TABLES) {
    await db.execute(`DROP TABLE IF EXISTS ${table}`);
    console.log(`[dm-web] DROP TABLE ${table}`);
  }
  await db.execute("SET FOREIGN_KEY_CHECKS = 1");
  console.log("[dm-web] 기존 테이블 전체 삭제 완료");
}

async function runSchema(db) {
  const filePath = path.join(__dirname, "..", "db", "schema.sql");
  const raw = fs.readFileSync(filePath, "utf8");
  const parts = raw
    .split(";")
    .map(function (s) {
      return s
        .split("\n")
        .filter(function (line) {
          const t = line.trim();
          return t && !t.startsWith("--");
        })
        .join("\n")
        .trim();
    })
    .filter(Boolean);
  for (let i = 0; i < parts.length; i++) {
    await db.execute(parts[i]);
  }
  console.log("[dm-web] 스키마 적용 완료");
}

async function seedContactsIfEmpty(db) {
  const [[{ c }]] = await db.execute("SELECT COUNT(*) AS c FROM dm_construction_contacts");
  if (Number(c) > 0) return;

  const contacts = [
    ["kim1", "이민환", "대양에스코", "차장", "061-332-8086(501)", 1],
    ["kim2", "고웅", "기술1부", "과장", "061-332-8086(402)", 2],
    ["hwang", "김경훈", "기술1부", "대리", "061-332-8086(403)", 3],
  ];
  for (let i = 0; i < contacts.length; i++) {
    await db.execute(
      "INSERT INTO dm_construction_contacts (code, name, dept, position, phone, sort_order) VALUES (?,?,?,?,?,?)",
      contacts[i]
    );
  }
  console.log("[dm-web] 공사 담당자 초기 데이터 삽입 완료");
}

async function seedAdminIfEmpty(db) {
  const seedId = process.env.DM_SEED_USER;
  const seedPw = process.env.DM_SEED_PASSWORD;
  if (!seedId || !seedPw) return;

  const [[{ c }]] = await db.execute("SELECT COUNT(*) AS c FROM dm_user WHERE username = ?", [seedId]);
  if (Number(c) > 0) {
    // 계정이 이미 있으면 role이 user인 경우 developer로 승격
    await db.execute(
      "UPDATE dm_user SET role = 'admin' WHERE username = ? AND role = 'user'",
      [seedId]
    );
    return;
  }

  const keyno = "UI_" + Math.random().toString(36).slice(2, 7).toUpperCase();
  await db.execute(
    "INSERT INTO dm_user (id, username, display_name, password, role, del_yn, lock_yn) VALUES (?,?,?,?,'admin','N','N')",
    [keyno, seedId, seedId, seedPw]
  );
  console.log(`[dm-web] 초기 관리자 계정 생성: ${seedId}`);
}

async function expandPasswordColumnIfNeeded(db) {
  const [[{ char_len }]] = await db.execute(
    "SELECT CHARACTER_MAXIMUM_LENGTH AS char_len FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='dm_user' AND COLUMN_NAME='password'"
  );
  if (Number(char_len) < 200) {
    await db.execute("ALTER TABLE dm_user MODIFY COLUMN password VARCHAR(200) NOT NULL COMMENT '비밀번호'");
    console.log("[dm-web] dm_user.password 컬럼 크기 확장 완료 (80→200)");
  }
}

async function migrateSafetyTable(db) {
  // dm_safety 테이블이 구 버전(start_date/end_date/category 컬럼)이면 재생성
  const [[exists]] = await db.execute(
    "SELECT COUNT(*) AS cnt FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='dm_safety'"
  );
  if (!Number(exists.cnt)) return; // 없으면 schema.sql에서 새로 생성되므로 skip

  const [[hasType]] = await db.execute(
    "SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='dm_safety' AND COLUMN_NAME='type'"
  );
  if (Number(hasType.cnt)) return; // 이미 있으면 skip

  // 구 버전 테이블 → 새 구조로 교체 (데이터 손실 감수)
  await db.execute("DROP TABLE dm_safety");
  await db.execute(
    "CREATE TABLE dm_safety (" +
    "  id           INT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY," +
    "  config_id    INT UNSIGNED  NULL," +
    "  plant_id     INT UNSIGNED  NOT NULL," +
    "  type         VARCHAR(30)   NOT NULL DEFAULT '안전관리'," +
    "  inspect_date DATE          NOT NULL," +
    "  content      TEXT          NULL," +
    "  created_by   VARCHAR(100)  NULL," +
    "  created_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP," +
    "  INDEX idx_dm_safety_date  (inspect_date)," +
    "  INDEX idx_dm_safety_plant (plant_id)" +
    ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='안전관리 점검 기록'"
  );
  console.log("[dm-web] dm_safety 테이블 마이그레이션 완료");
}

async function addRoleColumnIfMissing(db) {
  const [[{ cnt }]] = await db.execute(
    "SELECT COUNT(*) AS cnt FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='dm_user' AND COLUMN_NAME='role'"
  );
  if (Number(cnt) === 0) {
    await db.execute("ALTER TABLE dm_user ADD COLUMN role VARCHAR(20) NOT NULL DEFAULT 'user' COMMENT '권한 user/admin/developer' AFTER password");
    console.log("[dm-web] dm_user.role 컬럼 추가 완료");
  }
}

async function migrateRtuTables(db) {
  for (const tbl of ['dm_rtu', 'dm_hw_version', 'dm_sw_version']) {
    const [[{ cnt }]] = await db.execute(
      `SELECT COUNT(*) AS cnt FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='${tbl}'`
    );
    if (!Number(cnt)) console.log(`[dm-web] ${tbl} 테이블 없음 — schema.sql에서 생성됩니다`);
  }
}

async function initDb(pool) {
  const conn = await pool.getConnection();
  try {
    if (process.env.DB_RESET === "true") {
      console.log("[dm-web] DB_RESET=true — 기존 테이블 초기화 시작");
      await dropAllTables(conn);
    }
    await runSchema(conn);
    await expandPasswordColumnIfNeeded(conn);
    await addRoleColumnIfMissing(conn);
    await migrateSafetyTable(conn);
    await migrateRtuTables(conn);
    await seedContactsIfEmpty(conn);
    await seedAdminIfEmpty(conn);
    await seedMapKeysFromEnv(conn);
  } finally {
    conn.release();
  }
}

module.exports = { initDb, runSchema };
