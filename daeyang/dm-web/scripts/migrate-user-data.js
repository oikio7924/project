/**
 * u_userinfo (원격 monitering) → dm_user (로컬 dmweb) 복사 스크립트
 * 비밀번호는 원본 그대로 복사 (재암호화 없음)
 *
 * 실행: node scripts/migrate-user-data.js
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

const INSERT_SQL =
  "INSERT INTO dm_user " +
  "(id, username, display_name, password, email, phone, del_yn, lock_yn, login_count, last_login_at, password_changed_at, registered_at, role) " +
  "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,'user') " +
  "ON DUPLICATE KEY UPDATE " +
  "  username=VALUES(username), display_name=VALUES(display_name), " +
  "  password=VALUES(password), email=VALUES(email), phone=VALUES(phone), " +
  "  del_yn=VALUES(del_yn), lock_yn=VALUES(lock_yn), " +
  "  login_count=VALUES(login_count), last_login_at=VALUES(last_login_at), " +
  "  password_changed_at=VALUES(password_changed_at), registered_at=VALUES(registered_at)";

function rowToValues(r) {
  return [
    r.UI_KEYNO,
    r.UI_ID        || "",
    r.UI_NAME      || r.UI_REP_NAME || "",
    r.UI_PASSWORD  || "",
    r.UI_EMAIL     || "",
    (r.UI_PHONE    || "").substring(0, 30),
    r.UI_DELYN     || "N",
    r.UI_LOCKYN    || "N",
    r.UI_LOGIN_COUNT || 0,
    r.UI_LASTLOGIN   || null,
    r.UI_PASSWORD_CHDT || null,
    r.UI_REGDT       || null,
  ];
}

async function run() {
  console.log("원격 DB 연결 중...");
  const src = await mysql.createConnection(SRC);
  console.log("로컬 DB 연결 중...");
  const dst = await mysql.createConnection(DST);

  const [[{ total }]] = await src.execute("SELECT COUNT(*) AS total FROM u_userinfo WHERE UI_DELYN = 'N'");
  console.log(`총 ${Number(total).toLocaleString()}명 복사 시작`);

  const [rows] = await src.execute(
    "SELECT * FROM u_userinfo WHERE UI_DELYN = 'N' ORDER BY UI_KEYNO"
  );

  let copied = 0, skipped = 0;
  for (const row of rows) {
    if (!row.UI_ID || !row.UI_PASSWORD) { skipped++; continue; }
    await dst.execute(INSERT_SQL, rowToValues(row));
    copied++;
    process.stdout.write(`\r진행: ${copied} / ${rows.length}`);
  }

  console.log(`\n완료: ${copied}명 복사, ${skipped}명 건너뜀 (아이디/비밀번호 없음)`);
  await src.end();
  await dst.end();
}

run().catch((e) => { console.error("\n오류:", e.message); process.exit(1); });
