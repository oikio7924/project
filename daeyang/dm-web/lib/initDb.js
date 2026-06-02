/**
 * dm-web 전용 테이블 생성 및 초기 시드
 * (사용자·발전소·게시판은 기존 s_user_info / dy_power_plant / b_board_notice 사용)
 */
const fs = require("fs");
const path = require("path");
const { seedMapKeysFromEnv } = require("./mapSettings");

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

async function initDb(pool) {
  const conn = await pool.getConnection();
  try {
    await runSchema(conn);
    await seedContactsIfEmpty(conn);
    await seedMapKeysFromEnv(conn);
  } finally {
    conn.release();
  }
}

module.exports = { initDb, runSchema };
