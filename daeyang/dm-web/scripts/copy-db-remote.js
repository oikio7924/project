/**
 * copy-db-remote.js
 * 원격 서버 내에서 monitering → dmweb 복사
 * 서버 내부에서 INSERT SELECT 처리 — 네트워크 데이터 전송 없음, 매우 빠름
 *
 * 사용법:
 *   node scripts/copy-db-remote.js
 *   node scripts/copy-db-remote.js --table dy_power_plant
 *   node scripts/copy-db-remote.js --from-table s_user_info
 *   node scripts/copy-db-remote.js --skip-schema
 */

"use strict";
const mysqlP = require("mysql2/promise");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "../.env") });

const REMOTE_CFG = {
  host: "139.150.73.219",
  port: 3306,
  user: "root",
  password: "qwer4321!",
  connectTimeout: 30000,
  supportBigNumbers: true,
};

const SRC_DB = "monitering";
const DST_DB = "dmweb";

const args = process.argv.slice(2);
const onlyTable  = args.includes("--table")      ? args[args.indexOf("--table") + 1]      : null;
const fromTable  = args.includes("--from-table") ? args[args.indexOf("--from-table") + 1] : null;
const skipSchema = args.includes("--skip-schema");

function log(msg) {
  const ts = new Date().toISOString().replace("T", " ").slice(0, 19);
  console.log(`[${ts}] ${msg}`);
}
function fmt(n) { return Number(n).toLocaleString(); }

// SHOW CREATE TABLE 결과를 대상 DB 이름으로 변환
function toDestDb(createSql) {
  // "CREATE TABLE `tablename`" → "CREATE TABLE `dmweb`.`tablename`"
  return createSql.replace(/^CREATE TABLE `/, "CREATE TABLE `" + DST_DB + "`.`");
}

async function main() {
  log("원격 서버 연결 중 (" + REMOTE_CFG.host + ")...");
  const conn = await mysqlP.createConnection(REMOTE_CFG);

  try {
    await conn.query("SET sql_mode = ''");
    await conn.query("SET FOREIGN_KEY_CHECKS = 0");

    // 대상 DB 생성
    await conn.query(
      "CREATE DATABASE IF NOT EXISTS `" + DST_DB + "`" +
      " CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    );
    log("대상 DB '" + DST_DB + "' 준비 완료");

    // 테이블 목록
    let tables;
    if (onlyTable) {
      tables = [onlyTable];
    } else {
      const [rows] = await conn.query(
        "SELECT TABLE_NAME FROM information_schema.TABLES" +
        " WHERE TABLE_SCHEMA = ? AND TABLE_TYPE = 'BASE TABLE'" +
        " ORDER BY TABLE_NAME",
        [SRC_DB]
      );
      tables = rows.map((r) => r.TABLE_NAME);
    }

    if (fromTable) {
      const idx = tables.indexOf(fromTable);
      if (idx === -1) throw new Error("'"+fromTable+"' 테이블을 찾을 수 없습니다.");
      tables = tables.slice(idx);
      log("'" + fromTable + "'부터 재개 (" + tables.length + "개 남음)");
    }

    log("테이블 " + tables.length + "개 복사 시작");

    for (const table of tables) {
      log("\n[" + table + "]");

      if (!skipSchema) {
        const [[row]] = await conn.query(
          "SHOW CREATE TABLE `" + SRC_DB + "`.`" + table + "`"
        );
        let createSql = row["Create Table"];

        // 비호환 DEFAULT 수정
        createSql = createSql
          .replace(/DEFAULT '0000-00-00 00:00:00'/g, "DEFAULT NULL")
          .replace(/DEFAULT '0000-00-00'/g, "DEFAULT NULL");

        await conn.query("DROP TABLE IF EXISTS `" + DST_DB + "`.`" + table + "`");
        try {
          await conn.query(toDestDb(createSql));
        } catch (e) {
          if (e.code === "ER_INVALID_DEFAULT") {
            createSql = createSql.replace(/DEFAULT current_timestamp\(\)/gi, "DEFAULT NULL");
            await conn.query(toDestDb(createSql));
            log("  ⚠ 비호환 DEFAULT 수정됨");
          } else {
            throw e;
          }
        }
        log("  스키마 OK");
      }

      // 행 수 확인
      const [[countRow]] = await conn.query(
        "SELECT COUNT(*) AS cnt FROM `" + SRC_DB + "`.`" + table + "`"
      );
      const total = Number(countRow.cnt);
      log("  " + fmt(total) + " 행");

      if (total === 0) continue;

      // 서버 내부 INSERT SELECT (클라이언트 데이터 전송 없음)
      const t0 = Date.now();
      await conn.query(
        "INSERT IGNORE INTO `" + DST_DB + "`.`" + table + "`" +
        " SELECT * FROM `" + SRC_DB + "`.`" + table + "`"
      );
      const elapsed = ((Date.now() - t0) / 1000).toFixed(1);
      log("  ✓ " + fmt(total) + "행 완료 (" + elapsed + "s)");
    }

    await conn.query("SET FOREIGN_KEY_CHECKS = 1");
    log("\n✓ 전체 복사 완료");
  } finally {
    await conn.end().catch(() => {});
  }
}

main().catch((err) => {
  console.error("\n오류:", err.message || err);
  process.exit(1);
});
