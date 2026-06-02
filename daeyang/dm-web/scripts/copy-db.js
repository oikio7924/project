/**
 * copy-db.js
 * remote monitering(139.150.73.219) → local dmweb(127.0.0.1) 전체 복사
 *
 * 사용법:
 *   node scripts/copy-db.js                          # 전체 복사
 *   node scripts/copy-db.js --table dy_power_plant   # 특정 테이블만
 *   node scripts/copy-db.js --skip-schema            # 데이터만 (스키마 유지)
 *   node scripts/copy-db.js --batch 20000            # 배치 크기
 */

"use strict";
const mysql = require("mysql2");
const mysqlP = require("mysql2/promise");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "../.env") });

const REMOTE_CFG = {
  host: "139.150.73.219",
  port: 3306,
  user: "root",
  password: "qwer4321!",
  database: "monitering",
  connectTimeout: 30000,
  supportBigNumbers: true,
};

const LOCAL_CFG = {
  host: "127.0.0.1",
  port: 3306,
  user: process.env.MARIADB_USER || "root",
  password: process.env.MARIADB_PASSWORD || "qwer4321!",
  database: "dmweb",
  connectTimeout: 10000,
  supportBigNumbers: true,
};

const args = process.argv.slice(2);
const onlyTable = args.includes("--table") ? args[args.indexOf("--table") + 1] : null;
const fromTable = args.includes("--from-table") ? args[args.indexOf("--from-table") + 1] : null;
const skipSchema = args.includes("--skip-schema");
const BATCH = args.includes("--batch")
  ? parseInt(args[args.indexOf("--batch") + 1], 10)
  : 20000;

function log(msg) {
  const ts = new Date().toISOString().replace("T", " ").slice(0, 19);
  console.log(`[${ts}] ${msg}`);
}
function fmt(n) { return Number(n).toLocaleString(); }

// 콜백 커넥션 → Promise 래핑 (results 배열 그대로 반환)
function rq(conn, sql, params) {
  return new Promise((resolve, reject) => {
    conn.query(sql, params || [], (err, results) => {
      if (err) return reject(err);
      resolve(results);
    });
  });
}

// ── 테이블 스트리밍 복사 ──────────────────────────────────────────────────────
function copyTableStream(remoteConn, localConn, table, cols) {
  return new Promise((resolve, reject) => {
    const fields = cols.map((c) => c.Field);
    const colNames = fields.map((f) => `\`${f}\``).join(", ");
    const singlePh = fields.map(() => "?").join(", ");

    let batch = [];
    let copied = 0;
    let flushing = false;
    let ended = false;
    const t0 = Date.now();

    function showProgress() {
      const elapsed = ((Date.now() - t0) / 1000).toFixed(1);
      process.stdout.write(`\r  ${fmt(copied)}행 — ${elapsed}s`);
    }

    function doResolve() {
      console.log();
      resolve(copied);
    }

    async function flushBatch(rows) {
      if (rows.length === 0) {
        flushing = false;
        if (ended) doResolve();
        else stream.resume();
        return;
      }
      const rowValues = rows.map((row) =>
        fields.map((f) => {
          const v = row[f];
          return v === undefined ? null : v;
        })
      );
      const bulkPh = rowValues.map(() => `(${singlePh})`).join(",");
      const sql = `INSERT IGNORE INTO \`${table}\` (${colNames}) VALUES ${bulkPh}`;
      try {
        await localConn.query(sql, rowValues.flat());
        copied += rows.length;
        showProgress();
        flushing = false;
        if (ended && batch.length === 0) {
          doResolve();
        } else if (ended) {
          // 잔여 배치 처리
          flushing = true;
          const remaining = batch;
          batch = [];
          await flushBatch(remaining);
        } else {
          stream.resume();
        }
      } catch (e) {
        reject(e);
      }
    }

    const stream = remoteConn
      .query(`SELECT * FROM \`${table}\``)
      .stream({ highWaterMark: BATCH });

    stream.on("data", (row) => {
      batch.push(row);
      if (batch.length >= BATCH && !flushing) {
        flushing = true;
        stream.pause();
        const current = batch;
        batch = [];
        flushBatch(current);
      }
    });

    stream.on("end", () => {
      ended = true;
      if (!flushing) {
        flushing = true;
        const current = batch;
        batch = [];
        flushBatch(current);
      }
    });

    stream.on("error", reject);
  });
}

// ── 메인 ──────────────────────────────────────────────────────────────────────
async function main() {
  log("원격 DB 연결 중...");
  const remoteConn = mysql.createConnection(REMOTE_CFG);
  await new Promise((res, rej) => remoteConn.connect((e) => (e ? rej(e) : res())));

  log("로컬 DB 연결 중...");
  const localConn = await mysqlP.createConnection(LOCAL_CFG);

  try {
    // strict mode 비활성화 (0000-00-00 같은 레거시 default 허용)
    await localConn.query("SET sql_mode = ''");
    // FK 체크 전체 비활성화 (스키마/데이터 순서 무관)
    await localConn.query("SET FOREIGN_KEY_CHECKS=0");

    // 테이블 목록 (BASE TABLE만)
    let tables;
    if (onlyTable) {
      tables = [onlyTable];
    } else {
      const rows = await rq(
        remoteConn,
        "SELECT TABLE_NAME FROM information_schema.TABLES" +
        " WHERE TABLE_SCHEMA = ? AND TABLE_TYPE = 'BASE TABLE'" +
        " ORDER BY TABLE_NAME",
        [REMOTE_CFG.database]
      );
      tables = rows.map((r) => r.TABLE_NAME);
    }

    // --from-table: 특정 테이블부터 재개
    if (fromTable) {
      const idx = tables.indexOf(fromTable);
      if (idx === -1) {
        throw new Error(`--from-table '${fromTable}' 테이블을 찾을 수 없습니다.`);
      }
      tables = tables.slice(idx);
      log(`'${fromTable}'부터 재개 (${tables.length}개 남음)`);
    }

    log(`테이블 ${tables.length}개 복사 시작 (배치=${fmt(BATCH)})`);

    for (const table of tables) {
      log(`\n[${table}]`);

      // 스키마 복사
      if (!skipSchema) {
        const schemaRows = await rq(remoteConn, `SHOW CREATE TABLE \`${table}\``);
        let createSql = schemaRows[0]["Create Table"];
        // 1차: 확실한 zero-date default 수정
        createSql = createSql
          .replace(/DEFAULT '0000-00-00 00:00:00'/g, "DEFAULT NULL")
          .replace(/DEFAULT '0000-00-00'/g, "DEFAULT NULL");
        await localConn.query(`DROP TABLE IF EXISTS \`${table}\``);
        try {
          await localConn.query(createSql);
        } catch (e) {
          if (e.code === "ER_INVALID_DEFAULT") {
            // 2차: current_timestamp() 등 비호환 function default 전부 제거
            createSql = createSql.replace(/DEFAULT current_timestamp\(\)/gi, "DEFAULT NULL");
            await localConn.query(createSql);
            log(`  ⚠ 비호환 DEFAULT 수정 후 스키마 생성`);
          } else {
            throw e;
          }
        }
        log(`  스키마 OK`);
      }

      // 행 수
      const countRows = await rq(remoteConn, `SELECT COUNT(*) AS cnt FROM \`${table}\``);
      const total = Number(countRows[0].cnt);
      log(`  ${fmt(total)} 행`);

      if (total === 0) continue;

      // 컬럼 정보
      const cols = await rq(remoteConn, `SHOW COLUMNS FROM \`${table}\``);

      const copied = await copyTableStream(remoteConn, localConn, table, cols);
      log(`  ✓ ${fmt(copied)}행 완료`);
    }

    await localConn.query("SET FOREIGN_KEY_CHECKS=1");
    log("\n✓ 전체 복사 완료");
  } finally {
    remoteConn.end();
    await localConn.end().catch(() => {});
  }
}

main().catch((err) => {
  console.error("\n오류:", err.message || err);
  process.exit(1);
});
