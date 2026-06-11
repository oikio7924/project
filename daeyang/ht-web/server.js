/**
 * homeik.co.kr — MariaDB 운영형 서버
 * 실행: npm install 후 npm start
 */
require("dotenv").config();
const express = require("express");
const session = require("express-session");
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const crypto = require("crypto");
const mysql = require("mysql2/promise");
const bcrypt = require("bcryptjs");
const XLSX = require("xlsx");

const BCRYPT_ROUNDS = 10;
const {
  parseWorkbookBuffer,
  normalizeBizNoKey,
  normalizeResidentKey,
  formatBizNoDisplay,
} = require("./lib/excelImport");
const { submitIssueRecordToHometax, checkHometaxIssueStatus } = require("./lib/hometaxSubmit");

const app = express();
const BASE_PATH = process.env.BASE_PATH || '';
const router = express.Router();
const PORT = Number(process.env.PORT || 3000);
const SITE_DOMAIN = process.env.SITE_DOMAIN || "https://homeik.co.kr";

// MariaDB 접속 정보
const DB_HOST = process.env.MARIADB_HOST || "";
const DB_PORT = Number(process.env.MARIADB_PORT || 3306);
const DB_USER = process.env.MARIADB_USER || "";
const DB_PASSWORD = process.env.MARIADB_PASSWORD || "";
const DB_NAME = process.env.MARIADB_DATABASE || "";

let dbPool = null;
const RECIPIENT_CERT_REL_DIR = path.join("uploads", "recipient-certs");
const RECIPIENT_CERT_ABS_DIR = path.join(__dirname, "public", RECIPIENT_CERT_REL_DIR);
const SUPPLIER_CERT_REL_DIR = path.join("uploads", "supplier-certs");
const SUPPLIER_CERT_ABS_DIR = path.join(__dirname, "public", SUPPLIER_CERT_REL_DIR);

// 구버전 Node에서도 동작하도록 (?? 대신 사용)
function nz(a, b) {
  return a == null ? b : a;
}

const TABLE_PREFIX = "ti_";
const BASE_TABLES = [
  "issue_matrix_notes",
  "issue_records",
  "monitoring_options",
  "recipient_items",
  "recipients",
  "suppliers",
  "users",
];

function applyTablePrefix(sql) {
  let out = String(sql || "");
  for (let i = 0; i < BASE_TABLES.length; i++) {
    const base = BASE_TABLES[i];
    const prefixed = TABLE_PREFIX + base;
    const re = new RegExp("\\b" + base + "\\b", "g");
    out = out.replace(re, prefixed);
  }
  return out;
}

const uploadExcel = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 15 * 1024 * 1024 },
  fileFilter: function (req, file, cb) {
    const ok =
      file.mimetype ===
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" ||
      file.mimetype === "application/vnd.ms-excel" ||
      (file.originalname && /\.xlsx?$/i.test(file.originalname));
    if (ok) cb(null, true);
    else cb(new Error("엑셀 파일(.xlsx, .xls)만 업로드할 수 있습니다."));
  },
});

const uploadRecipientCert = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 },
  fileFilter: function (req, file, cb) {
    const type = String(file.mimetype || "").toLowerCase();
    const byType = type === "application/pdf";
    const byName = !!(file.originalname && /\.pdf$/i.test(file.originalname));
    if (byType || byName) cb(null, true);
    else cb(new Error("PDF 파일만 업로드할 수 있습니다."));
  },
});

async function ensureRecipientCertDir() {
  await fs.promises.mkdir(RECIPIENT_CERT_ABS_DIR, { recursive: true });
}

async function ensureSupplierCertDir() {
  await fs.promises.mkdir(SUPPLIER_CERT_ABS_DIR, { recursive: true });
}

function recipientCertUrl(fileName) {
  const name = String(fileName || "").trim();
  if (!name) return "";
  return BASE_PATH + "/" + RECIPIENT_CERT_REL_DIR.replace(/\\/g, "/") + "/" + name;
}

function supplierCertUrl(fileName) {
  const name = String(fileName || "").trim();
  if (!name) return "";
  return BASE_PATH + "/" + SUPPLIER_CERT_REL_DIR.replace(/\\/g, "/") + "/" + name;
}

function cleanUploadName(fileName) {
  const base = path.basename(String(fileName || "").trim());
  return base.replace(/[^\w.\-()\uAC00-\uD7A3 ]/g, "").slice(0, 255);
}

async function removeRecipientCertFile(fileName) {
  const name = String(fileName || "").trim();
  if (!name || name.indexOf("/") >= 0 || name.indexOf("\\") >= 0) return;
  const abs = path.join(RECIPIENT_CERT_ABS_DIR, name);
  try { await fs.promises.unlink(abs); } catch (e) { if (e && e.code !== "ENOENT") throw e; }
}

async function removeSupplierCertFile(fileName) {
  const name = String(fileName || "").trim();
  if (!name || name.indexOf("/") >= 0 || name.indexOf("\\") >= 0) return;
  const abs = path.join(SUPPLIER_CERT_ABS_DIR, name);
  try { await fs.promises.unlink(abs); } catch (e) { if (e && e.code !== "ENOENT") throw e; }
}

function kstYearMonthDay() {
  const fmt = new Intl.DateTimeFormat("en-CA", {
    timeZone: "Asia/Seoul",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  });
  const s = fmt.format(new Date());
  const yearMonth = s.slice(0, 7);
  return { dateStr: s, yearMonth };
}

function prevYearMonth(ym) {
  const parts = ym.split("-");
  let y = Number(parts[0]);
  let m = Number(parts[1]);
  m -= 1;
  if (m < 1) {
    m = 12;
    y -= 1;
  }
  return y + "-" + String(m).padStart(2, "0");
}

function calcFixedTax(supply) {
  return Math.floor((Number(supply) || 0) * 0.1);
}

function formatBizNoForBusiness(v) {
  const digits = normalizeBizNoKey(v);
  if (digits.length === 10) return formatBizNoDisplay(digits);
  return String(v || "");
}

function formatResidentNoForIndividual(v) {
  const digits = normalizeResidentKey(v);
  if (digits.length === 13) return digits.slice(0, 6) + "-" + digits.slice(6);
  return String(v || "");
}

function formatRecipientNoByKind(kind, value) {
  if (kind === "business") return formatBizNoForBusiness(value);
  if (kind === "individual") return formatResidentNoForIndividual(value);
  return String(value || "");
}

function sumIssueRecords(list) {
  let supply = 0;
  let tax = 0;
  let transmitted = 0;
  let pendingTransmit = 0;
  let transmitFailed = 0;
  for (let i = 0; i < list.length; i++) {
    const r = list[i];
    supply += Number(r.totalSupply) || 0;
    tax += Number(r.totalTax) || 0;
    if (r.transmitStatus === "transmitted_practice") transmitted += 1;
    else if (r.transmitStatus === "transmit_failed") transmitFailed += 1;
    else pendingTransmit += 1;
  }
  return {
    supply,
    tax,
    total: supply + tax,
    issueCount: list.length,
    transmitted,
    pendingTransmit,
    transmitFailed,
    notTransmitted: pendingTransmit + transmitFailed,
  };
}

function mapSupplierRow(row) {
  return {
    id: Number(row.id),
    bizNo: String(row.biz_no || ""),
    corpName: String(row.corp_name || ""),
    ceoName: String(row.ceo_name || ""),
    phone: String(row.phone || ""),
    address: String(row.address || ""),
    bizType: String(row.biz_type || ""),
    bizItem: String(row.biz_item || ""),
    email: String(row.email || ""),
    contactDept: String(row.contact_dept || ""),
    contactName: String(row.contact_name || ""),
    contactPhone: String(row.contact_phone || ""),
    contactExtension: String(row.contact_extension || ""),
    contactEmail: String(row.contact_email || ""),
    bizCertFile: String(row.biz_cert_file || ""),
    bizCertName: String(row.biz_cert_name || ""),
    bizCertUrl: supplierCertUrl(row.biz_cert_file || ""),
  };
}

function mapRecipientRow(row) {
  return {
    id: Number(row.id),
    userId: Number(row.user_id),
    kind: String(row.kind || "individual"),
    bizSubtype: row.biz_subtype == null ? null : String(row.biz_subtype),
    displayName: String(row.display_name || ""),
    bizNo: String(row.biz_no || ""),
    ceoName: String(row.ceo_name || ""),
    address: String(row.address || ""),
    email: String(row.email || ""),
    bizType: String(row.biz_type || ""),
    bizItem: String(row.biz_item || ""),
    internalMemo: String(row.internal_memo || ""),
    svcSafety:     !!row.svc_safety,
    svcTax:        !!row.svc_tax,
    svcBilling:    !!row.svc_billing,
    svcMonitoring:  !!row.svc_monitoring,
    monitoringType: String(row.monitoring_type || ""),
    paymentMethod:      String(row.payment_method  || ""),
    capacity:           Number(row.capacity) || 0,
    receptionCapacity:  Number(row.reception_capacity) || 0,
    generationCapacity: Number(row.generation_capacity) || 0,
    contactName: String(row.contact_name || ""),
    contactPhone: String(row.contact_phone || ""),
    contactEmail: String(row.contact_email || ""),
    bizCertFile: String(row.biz_cert_file || ""),
    bizCertName: String(row.biz_cert_name || ""),
    bizCertUrl: recipientCertUrl(row.biz_cert_file || ""),
    items: [],
  };
}

function mapItemRow(row) {
  return {
    id: Number(row.id),
    plantName: String(row.plant_name || ""),
    fixedItemName: String(row.fixed_item_name || ""),
    monthlySupply: Number(row.monthly_supply) || 0,
    monthlyTax: Number(row.monthly_tax) || 0,
    quantity: Number(row.quantity) || 0,
    unitPrice: Number(row.unit_price) || 0,
    note: String(row.note || ""),
  };
}

function mapIssueRecordRow(row) {
  return {
    id: Number(row.id),
    userId: Number(row.user_id),
    createdAt: new Date(row.created_at).toISOString(),
    yearMonth: String(row.year_month_key || ""),
    issueDate: String(row.issue_date || ""),
    recipientId: Number(row.recipient_id) || 0,
    recipientName: String(row.recipient_name || ""),
    totalSupply: Number(row.total_supply) || 0,
    totalTax: Number(row.total_tax) || 0,
    itemJson: String(row.item_json || ""),
    transmitStatus: String(row.transmit_status || "not_sent"),
    status: String(row.status || "issued"),
    lastHometaxError: String(row.last_hometax_error || ""),
    mockSeed: !!row.mock_seed,
  };
}

async function q(sql, params) {
  const [rows] = await dbPool.query(applyTablePrefix(sql), params || []);
  return rows;
}

async function withTx(fn) {
  const conn = await dbPool.getConnection();
  try {
    const rawQuery = conn.query.bind(conn);
    conn.query = function (sql, params) {
      return rawQuery(applyTablePrefix(sql), params || []);
    };
    await conn.beginTransaction();
    const out = await fn(conn);
    await conn.commit();
    return out;
  } catch (e) {
    await conn.rollback();
    throw e;
  } finally {
    conn.release();
  }
}

async function addColumnIfMissing(tableBase, columnName, columnDef) {
  const physical = TABLE_PREFIX + tableBase;
  const rows = await q(
    "SELECT COUNT(*) AS n FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?",
    [physical, columnName]
  );
  if (Number(rows[0].n) > 0) return;
  await q(
    "ALTER TABLE " + tableBase + " ADD COLUMN `" + columnName + "` " + columnDef
  );
}

/** MariaDB 10.3.2 이하·일부 MySQL 호환 모드는 ADD COLUMN IF NOT EXISTS 미지원 → 스키마 조회 후 추가 */
async function addColumnToRecipientsIfMissing(columnName, columnDef) {
  await addColumnIfMissing("recipients", columnName, columnDef);
}

async function dropAllTables() {
  await q("SET FOREIGN_KEY_CHECKS = 0");
  const drops = [
    "issue_matrix_notes",
    "issue_records",
    "monitoring_options",
    "recipient_items",
    "recipients",
    "suppliers",
    "users",
  ];
  for (let i = 0; i < drops.length; i++) {
    await q("DROP TABLE IF EXISTS " + drops[i]);
    console.log("[DB_RESET] DROP TABLE " + TABLE_PREFIX + drops[i]);
  }
  await q("SET FOREIGN_KEY_CHECKS = 1");
  console.log("[DB_RESET] 모든 테이블 삭제 완료 — 재생성합니다.");
}

async function ensureSchema() {
  await q(
    "CREATE TABLE IF NOT EXISTS users (" +
      "id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY," +
      "username VARCHAR(120) NOT NULL UNIQUE," +
      "password VARCHAR(255) NOT NULL," +
      "name VARCHAR(100) NOT NULL DEFAULT ''," +
      "role VARCHAR(20) NOT NULL DEFAULT 'user'," +
      "active_supplier_id INT UNSIGNED NULL," +
      "notice_text VARCHAR(1000) NOT NULL DEFAULT ''," +
      "login_fail_count INT NOT NULL DEFAULT 0," +
      "is_locked TINYINT(1) NOT NULL DEFAULT 0," +
      "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP," +
      "updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
      ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
  );
  await addColumnIfMissing("users", "name",             "VARCHAR(100) NOT NULL DEFAULT ''");
  await addColumnIfMissing("users", "notice_text",      "VARCHAR(1000) NOT NULL DEFAULT ''");
  await addColumnIfMissing("users", "role",             "VARCHAR(20) NOT NULL DEFAULT 'user'");
  await addColumnIfMissing("users", "updated_at",       "TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP");
  await addColumnIfMissing("users", "login_fail_count", "INT NOT NULL DEFAULT 0");
  await addColumnIfMissing("users", "is_locked",        "TINYINT(1) NOT NULL DEFAULT 0");
  await q(
    "CREATE TABLE IF NOT EXISTS suppliers (" +
      "id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY," +
      "user_id INT UNSIGNED NOT NULL," +
      "biz_no VARCHAR(40) NOT NULL DEFAULT ''," +
      "corp_name VARCHAR(200) NOT NULL DEFAULT ''," +
      "ceo_name VARCHAR(100) NOT NULL DEFAULT ''," +
      "address VARCHAR(255) NOT NULL DEFAULT ''," +
      "biz_type VARCHAR(120) NOT NULL DEFAULT ''," +
      "biz_item VARCHAR(120) NOT NULL DEFAULT ''," +
      "email VARCHAR(120) NOT NULL DEFAULT ''," +
      "phone VARCHAR(60) NOT NULL DEFAULT ''," +
      "contact_dept VARCHAR(120) NOT NULL DEFAULT ''," +
      "contact_name VARCHAR(120) NOT NULL DEFAULT ''," +
      "contact_phone VARCHAR(60) NOT NULL DEFAULT ''," +
      "contact_extension VARCHAR(30) NOT NULL DEFAULT ''," +
      "contact_email VARCHAR(120) NOT NULL DEFAULT ''," +
      "biz_cert_file VARCHAR(255) NOT NULL DEFAULT ''," +
      "biz_cert_name VARCHAR(255) NOT NULL DEFAULT ''," +
      "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP," +
      "updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
      "INDEX idx_suppliers_user (user_id)," +
      "CONSTRAINT fk_suppliers_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
      ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
  );
  await addColumnIfMissing("suppliers", "phone",          "VARCHAR(60) NOT NULL DEFAULT ''");
  await addColumnIfMissing("suppliers", "biz_cert_file", "VARCHAR(255) NOT NULL DEFAULT ''");
  await addColumnIfMissing("suppliers", "biz_cert_name", "VARCHAR(255) NOT NULL DEFAULT ''");
  await q(
    "CREATE TABLE IF NOT EXISTS recipients (" +
      "id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY," +
      "user_id INT UNSIGNED NOT NULL," +
      "kind VARCHAR(20) NOT NULL DEFAULT 'individual'," +
      "biz_subtype VARCHAR(20) NULL," +
      "display_name VARCHAR(200) NOT NULL DEFAULT ''," +
      "biz_no VARCHAR(40) NOT NULL DEFAULT ''," +
      "ceo_name VARCHAR(120) NOT NULL DEFAULT ''," +
      "address VARCHAR(255) NOT NULL DEFAULT ''," +
      "email VARCHAR(120) NOT NULL DEFAULT ''," +
      "biz_type VARCHAR(120) NOT NULL DEFAULT ''," +
      "biz_item VARCHAR(120) NOT NULL DEFAULT ''," +
      "internal_memo VARCHAR(500) NOT NULL DEFAULT ''," +
      "svc_safety TINYINT(1) NOT NULL DEFAULT 0," +
      "svc_tax TINYINT(1) NOT NULL DEFAULT 0," +
      "svc_billing TINYINT(1) NOT NULL DEFAULT 0," +
      "svc_monitoring TINYINT(1) NOT NULL DEFAULT 0," +
      "monitoring_type VARCHAR(100) NOT NULL DEFAULT ''," +
      "payment_method VARCHAR(50) NOT NULL DEFAULT ''," +
      "capacity DECIMAL(10,3) NOT NULL DEFAULT 0," +
      "reception_capacity DECIMAL(10,3) NOT NULL DEFAULT 0," +
      "generation_capacity DECIMAL(10,3) NOT NULL DEFAULT 0," +
      "contact_name VARCHAR(100) NOT NULL DEFAULT ''," +
      "contact_phone VARCHAR(60) NOT NULL DEFAULT ''," +
      "contact_email VARCHAR(120) NOT NULL DEFAULT ''," +
      "biz_cert_file VARCHAR(255) NOT NULL DEFAULT ''," +
      "biz_cert_name VARCHAR(255) NOT NULL DEFAULT ''," +
      "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP," +
      "updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
      "INDEX idx_recipients_user (user_id)," +
      "CONSTRAINT fk_recipients_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
      ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
  );
  await addColumnToRecipientsIfMissing("biz_type", "VARCHAR(120) NOT NULL DEFAULT ''");
  await addColumnToRecipientsIfMissing("biz_item", "VARCHAR(120) NOT NULL DEFAULT ''");
  await addColumnToRecipientsIfMissing("internal_memo", "VARCHAR(500) NOT NULL DEFAULT ''");
  await addColumnToRecipientsIfMissing("svc_safety", "TINYINT(1) NOT NULL DEFAULT 0");
  await addColumnToRecipientsIfMissing("svc_tax", "TINYINT(1) NOT NULL DEFAULT 0");
  await addColumnToRecipientsIfMissing("svc_billing", "TINYINT(1) NOT NULL DEFAULT 0");
  await addColumnToRecipientsIfMissing("svc_monitoring", "TINYINT(1) NOT NULL DEFAULT 0");
  await addColumnToRecipientsIfMissing("monitoring_type", "VARCHAR(100) NOT NULL DEFAULT ''");
  await addColumnToRecipientsIfMissing("payment_method", "VARCHAR(50) NOT NULL DEFAULT ''");
  await addColumnToRecipientsIfMissing("capacity",            "DECIMAL(10,3) NOT NULL DEFAULT 0");
  await addColumnToRecipientsIfMissing("reception_capacity",  "DECIMAL(10,3) NOT NULL DEFAULT 0");
  await addColumnToRecipientsIfMissing("generation_capacity", "DECIMAL(10,3) NOT NULL DEFAULT 0");
  // 기존에 DECIMAL(10,2)로 생성된 경우 소수점 3자리로 확장
  for (const col of ["capacity", "reception_capacity", "generation_capacity"]) {
    const scaleRows = await q(
      "SELECT NUMERIC_SCALE FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=? AND COLUMN_NAME=?",
      [TABLE_PREFIX + "recipients", col]
    );
    if (scaleRows.length > 0 && Number(scaleRows[0].NUMERIC_SCALE) < 3) {
      await q("ALTER TABLE `" + TABLE_PREFIX + "recipients` MODIFY COLUMN `" + col + "` DECIMAL(10,3) NOT NULL DEFAULT 0");
    }
  }
  await addColumnToRecipientsIfMissing("contact_name",  "VARCHAR(100) NOT NULL DEFAULT ''");
  await addColumnToRecipientsIfMissing("contact_phone", "VARCHAR(60) NOT NULL DEFAULT ''");
  await addColumnToRecipientsIfMissing("contact_email", "VARCHAR(120) NOT NULL DEFAULT ''");
  await addColumnToRecipientsIfMissing("biz_cert_file", "VARCHAR(255) NOT NULL DEFAULT ''");
  await addColumnToRecipientsIfMissing("biz_cert_name", "VARCHAR(255) NOT NULL DEFAULT ''");
  await q(
    "CREATE TABLE IF NOT EXISTS recipient_items (" +
      "id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY," +
      "recipient_id INT UNSIGNED NOT NULL," +
      "plant_name VARCHAR(200) NOT NULL DEFAULT ''," +
      "fixed_item_name VARCHAR(200) NOT NULL DEFAULT ''," +
      "monthly_supply DECIMAL(15,2) NOT NULL DEFAULT 0," +
      "monthly_tax DECIMAL(15,2) NOT NULL DEFAULT 0," +
      "quantity DECIMAL(18,2) NOT NULL DEFAULT 0," +
      "unit_price DECIMAL(18,2) NOT NULL DEFAULT 0," +
      "note VARCHAR(500) NOT NULL DEFAULT ''," +
      "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP," +
      "updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
      "INDEX idx_items_recipient (recipient_id)," +
      "CONSTRAINT fk_items_recipient FOREIGN KEY (recipient_id) REFERENCES recipients(id) ON DELETE CASCADE" +
      ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
  );
  await q(
    "CREATE TABLE IF NOT EXISTS issue_records (" +
      "id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY," +
      "user_id INT UNSIGNED NOT NULL," +
      "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP," +
      "year_month_key CHAR(7) NOT NULL," +
      "issue_date CHAR(10) NOT NULL DEFAULT ''," +
      "recipient_id INT UNSIGNED NOT NULL DEFAULT 0," +
      "recipient_name VARCHAR(200) NOT NULL DEFAULT ''," +
      "total_supply DECIMAL(15,2) NOT NULL DEFAULT 0," +
      "total_tax DECIMAL(15,2) NOT NULL DEFAULT 0," +
      "item_json TEXT," +
      "transmit_status VARCHAR(30) NOT NULL DEFAULT 'not_sent'," +
      "status VARCHAR(30) NOT NULL DEFAULT 'issued'," +
      "last_hometax_error VARCHAR(500) NOT NULL DEFAULT ''," +
      "mock_seed TINYINT(1) NOT NULL DEFAULT 0," +
      "INDEX idx_issue_user_created (user_id, created_at)," +
      "INDEX idx_issue_user_ym (user_id, year_month_key)," +
      "CONSTRAINT fk_issue_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
      ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
  );
  try { await q("ALTER TABLE issue_records DROP INDEX uq_issue_user_ym_rec"); } catch (_) {}
  try { await q("ALTER TABLE issue_records ADD COLUMN issue_date CHAR(10) NOT NULL DEFAULT '' AFTER year_month_key"); } catch (_) {}
  try { await q("ALTER TABLE issue_records ADD COLUMN item_json TEXT AFTER total_tax"); } catch (_) {}
  try { await q("ALTER TABLE recipient_items ADD COLUMN quantity DECIMAL(18,2) NOT NULL DEFAULT 0 AFTER monthly_tax"); } catch (_) {}
  try { await q("ALTER TABLE recipient_items ADD COLUMN unit_price DECIMAL(18,2) NOT NULL DEFAULT 0 AFTER quantity"); } catch (_) {}
  await q(
    "CREATE TABLE IF NOT EXISTS monitoring_options (" +
      "id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY," +
      "user_id INT UNSIGNED NOT NULL," +
      "name VARCHAR(100) NOT NULL," +
      "created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP," +
      "UNIQUE KEY uq_mon_opt (user_id, name)," +
      "INDEX idx_mon_opt_user (user_id)," +
      "CONSTRAINT fk_mon_opt_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
      ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
  );
  await q(
    "CREATE TABLE IF NOT EXISTS issue_matrix_notes (" +
      "id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY," +
      "user_id INT UNSIGNED NOT NULL," +
      "year_no INT NOT NULL," +
      "recipient_id INT UNSIGNED NOT NULL," +
      "note VARCHAR(500) NOT NULL DEFAULT ''," +
      "updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
      "UNIQUE KEY uq_matrix_note (user_id, year_no, recipient_id)," +
      "INDEX idx_matrix_note_user_year (user_id, year_no)," +
      "CONSTRAINT fk_matrix_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE," +
      "CONSTRAINT fk_matrix_recipient FOREIGN KEY (recipient_id) REFERENCES recipients(id) ON DELETE CASCADE" +
      ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
  );
}

async function ensureDemoUser() {
  const rows = await q("SELECT id FROM users LIMIT 1");
  if (rows.length) return;
  const hashedDemo = await bcrypt.hash("admin", BCRYPT_ROUNDS);
  const out = await q(
    "INSERT INTO users (username, password, role) VALUES (?, ?, 'admin')",
    ["admin", hashedDemo]
  );
  const userId = Number(out.insertId);
  const supplierOut = await q(
    "INSERT INTO suppliers (" +
      "user_id, biz_no, corp_name, ceo_name, address, biz_type, biz_item, email, " +
      "contact_dept, contact_name, contact_phone, contact_extension, contact_email" +
      ") VALUES (?, '', '', '', '', '', '', '', '', '', '', '', '')",
    [userId]
  );
  const supplierId = Number(supplierOut.insertId);
  await q("UPDATE users SET active_supplier_id = ? WHERE id = ?", [supplierId, userId]);
}

async function getUserFullById(userId) {
  const users = await q(
    "SELECT id, username, password, role, active_supplier_id, notice_text FROM users WHERE id = ? LIMIT 1",
    [userId]
  );
  if (!users.length) return null;
  const user = users[0];
  let supplierRows = await q(
    "SELECT * FROM suppliers WHERE user_id = ? ORDER BY id ASC",
    [userId]
  );
  if (!supplierRows.length) {
    await q(
      "INSERT INTO suppliers (" +
        "user_id, biz_no, corp_name, ceo_name, address, biz_type, biz_item, email, " +
        "contact_dept, contact_name, contact_phone, contact_extension, contact_email" +
        ") VALUES (?, '', '', '', '', '', '', '', '', '', '', '', '')",
      [userId]
    );
    supplierRows = await q("SELECT * FROM suppliers WHERE user_id = ? ORDER BY id ASC", [userId]);
  }
  if (!supplierRows.length) return null;
  const suppliers = supplierRows.map(mapSupplierRow);
  let activeSupplierId = Number(user.active_supplier_id) || suppliers[0].id;
  let active = suppliers.find(function (s) {
    return s.id === activeSupplierId;
  });
  if (!active) {
    activeSupplierId = suppliers[0].id;
    active = suppliers[0];
    await q("UPDATE users SET active_supplier_id = ? WHERE id = ?", [
      activeSupplierId,
      userId,
    ]);
  }
  return {
    id: Number(user.id),
    username: String(user.username),
    password: String(user.password),
    role: String(user.role || "user"),
    activeSupplierId,
    noticeText: String(user.notice_text || ""),
    suppliers,
    supplier: active,
  };
}

async function getUserSafeById(userId) {
  const u = await getUserFullById(userId);
  if (!u) return null;
  const safe = Object.assign({}, u);
  delete safe.password;
  return safe;
}

async function getRecipientsByUserId(userId) {
  const recipientRows = await q(
    "SELECT * FROM recipients WHERE user_id = ? ORDER BY display_name ASC, id ASC",
    [userId]
  );
  if (!recipientRows.length) return [];
  const list = recipientRows.map(mapRecipientRow);
  const idMap = {};
  for (let i = 0; i < list.length; i++) {
    idMap[list[i].id] = list[i];
  }
  const itemRows = await q(
    "SELECT i.* FROM recipient_items i " +
      "JOIN recipients r ON r.id = i.recipient_id " +
      "WHERE r.user_id = ? ORDER BY i.id ASC",
    [userId]
  );
  for (let i = 0; i < itemRows.length; i++) {
    const row = itemRows[i];
    const target = idMap[Number(row.recipient_id)];
    if (target) target.items.push(mapItemRow(row));
  }
  return list;
}

async function getRecipientById(userId, recipientId) {
  const rows = await q(
    "SELECT * FROM recipients WHERE id = ? AND user_id = ? LIMIT 1",
    [recipientId, userId]
  );
  if (!rows.length) return null;
  const rec = mapRecipientRow(rows[0]);
  const items = await q(
    "SELECT * FROM recipient_items WHERE recipient_id = ? ORDER BY id ASC",
    [recipientId]
  );
  rec.items = items.map(mapItemRow);
  return rec;
}

async function upsertIssueRecordsFromEntries(userId, yearMonth, entries) {
  if (!/^\d{4}-\d{2}$/.test(yearMonth)) {
    return { error: "귀속 연·월(YYYY-MM)을 올바르게 입력하세요." };
  }
  if (!Array.isArray(entries) || entries.length === 0) {
    return { error: "저장할 공급받는자를 선택하세요." };
  }

  return withTx(async function (conn) {
    let saved = 0;
    const records = [];
    const recordIds = [];

    for (let i = 0; i < entries.length; i++) {
      const e = entries[i];
      const rid = Number(e.recipientId);
      if (!rid) continue;

      const recRows = await conn.query(
        "SELECT * FROM recipients WHERE id = ? AND user_id = ? LIMIT 1",
        [rid, userId]
      );
      const recList = recRows[0] || [];
      if (!recList.length) continue;
      const rec = recList[0];

      // 공급가액·세액: 전달받은 값 우선, 없으면 품목에서 합산
      let supply = Number(e.totalSupply);
      let tax = Number(e.totalTax);
      if (!Number.isFinite(supply) || !Number.isFinite(tax)) {
        supply = 0;
        tax = 0;
        if (Array.isArray(e.items) && e.items.length > 0) {
          for (let j = 0; j < e.items.length; j++) {
            supply += Number(e.items[j].monthlySupply) || 0;
            tax += Number(e.items[j].monthlyTax) || 0;
          }
        } else {
          const itemRowsOut = await conn.query(
            "SELECT monthly_supply, monthly_tax FROM recipient_items WHERE recipient_id = ?",
            [rid]
          );
          const itemRows = itemRowsOut[0] || [];
          for (let j = 0; j < itemRows.length; j++) {
            supply += Number(itemRows[j].monthly_supply) || 0;
            tax += Number(itemRows[j].monthly_tax) || 0;
          }
        }
      }

      const rawTs = e.transmitStatus;
      const ts = rawTs === "transmitted_practice" ? "transmitted_practice"
               : rawTs === "transmit_failed" ? "transmit_failed"
               : "not_sent";

      const issueDate = String(e.issueDate || "").trim();
      const itemJson = Array.isArray(e.items) && e.items.length > 0
        ? JSON.stringify(e.items) : "";

      const existingId = Number(e.id) || 0;
      let id;

      if (existingId) {
        // 기존 레코드 UPDATE (소유권 확인)
        const checkOut = await conn.query(
          "SELECT id FROM issue_records WHERE id = ? AND user_id = ? AND year_month_key = ? LIMIT 1",
          [existingId, userId, yearMonth]
        );
        const checkList = checkOut[0] || [];
        if (!checkList.length) continue;

        await conn.query(
          "UPDATE issue_records SET recipient_name=?, total_supply=?, total_tax=?, transmit_status=?, issue_date=?, item_json=? WHERE id=? AND user_id=?",
          [String(rec.display_name || ""), supply, tax, ts, issueDate, itemJson, existingId, userId]
        );
        id = existingId;
      } else {
        // 새 레코드 INSERT
        const ins = await conn.query(
          "INSERT INTO issue_records (user_id, year_month_key, recipient_id, recipient_name, total_supply, total_tax, transmit_status, status, issue_date, item_json) VALUES (?, ?, ?, ?, ?, ?, ?, 'issued', ?, ?)",
          [userId, yearMonth, rid, String(rec.display_name || ""), supply, tax, ts, issueDate, itemJson]
        );
        const result = ins[0] || {};
        id = Number(result.insertId);
      }

      const createdRowOut = await conn.query(
        "SELECT * FROM issue_records WHERE id = ? LIMIT 1",
        [id]
      );
      const createdRows = createdRowOut[0] || [];
      if (createdRows.length) records.push(mapIssueRecordRow(createdRows[0]));
      recordIds.push(id);
      saved += 1;
    }

    return { saved, records, recordIds };
  });
}


router.use(express.json({ limit: "2mb" }));
router.use(
  session({
    secret: process.env.SESSION_SECRET || "homeik-dev-secret-change-me",
    resave: false,
    saveUninitialized: false,
    cookie: {
      maxAge: 7 * 24 * 60 * 60 * 1000,
      httpOnly: true,
      sameSite: "strict",
      path: BASE_PATH || '/',
    },
  })
);
router.use((req, res, next) => {
  res.locals.siteDomain = SITE_DOMAIN;
  next();
});
router.use(express.static(path.join(__dirname, "public")));

function needLogin(req, res, next) {
  if (!req.session.userId) {
    return res.status(401).json({ error: "로그인이 필요합니다." });
  }
  next();
}

async function needAdmin(req, res, next) {
  if (!req.session.userId) {
    return res.status(401).json({ error: "로그인이 필요합니다." });
  }
  const rows = await q("SELECT role FROM users WHERE id = ? LIMIT 1", [req.session.userId]);
  if (!rows.length || rows[0].role !== "admin") {
    return res.status(403).json({ error: "관리자 권한이 필요합니다." });
  }
  next();
}

router.get("/api/config", function (req, res) {
  res.json({ siteDomain: SITE_DOMAIN });
});

router.post("/api/login", async function (req, res) {
  try {
    const username = String((req.body || {}).username || "");
    const password = String((req.body || {}).password || "");
    const rows = await q(
      "SELECT id, password, role, is_locked, login_fail_count FROM users WHERE username = ? LIMIT 1",
      [username]
    );
    if (!rows.length) {
      return res.status(400).json({ error: "아이디 또는 비밀번호가 올바르지 않습니다." });
    }
    if (rows[0].is_locked) {
      return res.status(403).json({ error: "계정이 잠겨있습니다. 관리자에게 문의하세요." });
    }
    const stored = String(rows[0].password);
    let match = false;
    if (stored.startsWith("$2")) {
      match = await bcrypt.compare(password, stored);
    } else {
      // 구버전 평문 패스워드 — 일치하면 bcrypt 해시로 투명하게 업그레이드
      if (stored === password) {
        match = true;
        const hashed = await bcrypt.hash(password, BCRYPT_ROUNDS);
        await q("UPDATE users SET password = ? WHERE id = ?", [hashed, rows[0].id]);
      }
    }
    if (!match) {
      const newFailCount = (Number(rows[0].login_fail_count) || 0) + 1;
      if (newFailCount >= 5) {
        await q("UPDATE users SET login_fail_count = ?, is_locked = 1 WHERE id = ?", [newFailCount, rows[0].id]);
        return res.status(403).json({ error: "비밀번호를 5회 틀려 계정이 잠겼습니다. 관리자에게 문의하세요." });
      }
      await q("UPDATE users SET login_fail_count = ? WHERE id = ?", [newFailCount, rows[0].id]);
      return res.status(400).json({ error: "아이디 또는 비밀번호가 올바르지 않습니다. (" + newFailCount + "/5회 실패)" });
    }
    if (rows[0].role === "pending") {
      return res.status(403).json({ error: "pending" });
    }
    await q("UPDATE users SET login_fail_count = 0 WHERE id = ?", [rows[0].id]);
    req.session.userId = Number(rows[0].id);
    const user = await getUserSafeById(req.session.userId);
    res.json({ user });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: "로그인 처리 중 오류" });
  }
});

router.post("/api/logout", function (req, res) {
  req.session.destroy(function () {
    res.json({ ok: true });
  });
});

router.post("/api/register", async function (req, res) {
  try {
    const username = String((req.body || {}).username || "").trim();
    const password = String((req.body || {}).password || "");
    const confirm  = String((req.body || {}).confirm  || "");
    if (!username) return res.status(400).json({ error: "아이디를 입력하세요." });
    if (username.length < 3 || username.length > 50) {
      return res.status(400).json({ error: "아이디는 3~50자여야 합니다." });
    }
    if (!/^[a-zA-Z0-9_\-]+$/.test(username)) {
      return res.status(400).json({ error: "아이디는 영문·숫자·_·- 만 사용할 수 있습니다." });
    }
    if (password.length < 4) return res.status(400).json({ error: "비밀번호는 4자 이상이어야 합니다." });
    if (password !== confirm) return res.status(400).json({ error: "비밀번호가 일치하지 않습니다." });
    const name = String((req.body || {}).name || "").trim().slice(0, 100);
    const exist = await q("SELECT id FROM users WHERE username = ? LIMIT 1", [username]);
    if (exist.length) return res.status(400).json({ error: "이미 사용 중인 아이디입니다." });
    const hashed = await bcrypt.hash(password, BCRYPT_ROUNDS);
    const out = await q(
      "INSERT INTO users (username, password, role, name) VALUES (?, ?, 'pending', ?)",
      [username, hashed, name]
    );
    const userId = Number(out.insertId);
    const supplierOut = await q(
      "INSERT INTO suppliers (user_id, biz_no, corp_name, ceo_name, address, biz_type, biz_item, email, " +
        "contact_dept, contact_name, contact_phone, contact_extension, contact_email) " +
        "VALUES (?, '', '', '', '', '', '', '', '', '', '', '', '')",
      [userId]
    );
    await q("UPDATE users SET active_supplier_id = ? WHERE id = ?", [Number(supplierOut.insertId), userId]);
    res.json({ ok: true });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: "회원가입 처리 중 오류" });
  }
});

router.get("/api/me", async function (req, res) {
  if (!req.session.userId) {
    return res.status(401).json({ error: "로그인이 필요합니다." });
  }
  const user = await getUserSafeById(req.session.userId);
  if (!user) {
    return res.status(401).json({ error: "사용자를 찾을 수 없습니다." });
  }
  res.json({ user });
});

router.put("/api/me/password", needLogin, async function (req, res) {
  const user = await getUserFullById(req.session.userId);
  if (!user) return res.status(404).json({ error: "없음" });
  const b = req.body || {};
  const currentPassword = String(b.currentPassword || "");
  const newPassword = String(b.newPassword || "");
  if (!currentPassword || !newPassword) {
    return res.status(400).json({ error: "현재 비밀번호와 새 비밀번호를 입력하세요." });
  }
  const stored = String(user.password);
  let currentMatch = false;
  if (stored.startsWith("$2")) {
    currentMatch = await bcrypt.compare(currentPassword, stored);
  } else {
    currentMatch = stored === currentPassword;
  }
  if (!currentMatch) {
    return res.status(400).json({ error: "현재 비밀번호가 올바르지 않습니다." });
  }
  if (newPassword.length < 4) {
    return res.status(400).json({ error: "새 비밀번호는 4자 이상으로 입력하세요." });
  }
  const hashedNew = await bcrypt.hash(newPassword, BCRYPT_ROUNDS);
  await q("UPDATE users SET password = ? WHERE id = ?", [hashedNew, user.id]);
  res.json({ ok: true });
});

router.put("/api/me/notice", needLogin, async function (req, res) {
  const b = req.body || {};
  const noticeText = String(b.noticeText || "").slice(0, 1000);
  await q("UPDATE users SET notice_text = ? WHERE id = ?", [
    noticeText,
    req.session.userId,
  ]);
  const user = await getUserSafeById(req.session.userId);
  res.json({ user });
});

router.put("/api/me/supplier", needLogin, async function (req, res) {
  const user = await getUserSafeById(req.session.userId);
  if (!user) return res.status(404).json({ error: "없음" });
  const activeId = Number(user.activeSupplierId);
  const s = req.body || {};
  await q(
    "UPDATE suppliers SET " +
      "biz_no=?, corp_name=?, ceo_name=?, phone=?, address=?, biz_type=?, biz_item=?, email=?, " +
      "contact_dept=?, contact_name=?, contact_phone=?, contact_extension=?, contact_email=? " +
      "WHERE id = ? AND user_id = ?",
    [
      formatBizNoForBusiness(s.bizNo),
      String(s.corpName || ""),
      String(s.ceoName || ""),
      String(s.phone || ""),
      String(s.address || ""),
      String(s.bizType || ""),
      String(s.bizItem || ""),
      String(s.email || ""),
      String(s.contactDept || ""),
      String(s.contactName || ""),
      String(s.contactPhone || ""),
      String(s.contactExtension || ""),
      String(s.contactEmail || ""),
      activeId,
      req.session.userId,
    ]
  );
  const nextUser = await getUserSafeById(req.session.userId);
  res.json({ user: nextUser });
});

router.put("/api/me/suppliers/:sid", needLogin, async function (req, res) {
  const sid = Number(req.params.sid);
  const found = await q(
    "SELECT id FROM suppliers WHERE id = ? AND user_id = ? LIMIT 1",
    [sid, req.session.userId]
  );
  if (!found.length) return res.status(404).json({ error: "없음" });
  const s = req.body || {};
  const currentRows = await q("SELECT * FROM suppliers WHERE id = ? LIMIT 1", [sid]);
  const cur = currentRows[0];
  await q(
    "UPDATE suppliers SET " +
      "biz_no=?, corp_name=?, ceo_name=?, phone=?, address=?, biz_type=?, biz_item=?, email=?, " +
      "contact_dept=?, contact_name=?, contact_phone=?, contact_extension=?, contact_email=? " +
      "WHERE id = ?",
    [
      formatBizNoForBusiness(nz(s.bizNo, cur.biz_no)),
      String(nz(s.corpName, cur.corp_name)),
      String(nz(s.ceoName, cur.ceo_name)),
      String(nz(s.phone, cur.phone)),
      String(nz(s.address, cur.address)),
      String(nz(s.bizType, cur.biz_type)),
      String(nz(s.bizItem, cur.biz_item)),
      String(nz(s.email, cur.email)),
      String(nz(s.contactDept, cur.contact_dept)),
      String(nz(s.contactName, cur.contact_name)),
      String(nz(s.contactPhone, cur.contact_phone)),
      String(nz(s.contactExtension, cur.contact_extension)),
      String(nz(s.contactEmail, cur.contact_email)),
      sid,
    ]
  );
  const user = await getUserSafeById(req.session.userId);
  res.json({ user });
});

router.post("/api/me/suppliers", needLogin, async function (req, res) {
  const s = req.body || {};
  const out = await q(
    "INSERT INTO suppliers (" +
      "user_id, biz_no, corp_name, ceo_name, address, biz_type, biz_item, email, " +
      "contact_dept, contact_name, contact_phone, contact_extension, contact_email" +
      ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
    [
      req.session.userId,
      formatBizNoForBusiness(s.bizNo),
      String(s.corpName || ""),
      String(s.ceoName || ""),
      String(s.address || ""),
      String(s.bizType || ""),
      String(s.bizItem || ""),
      String(s.email || ""),
      String(s.contactDept || ""),
      String(s.contactName || ""),
      String(s.contactPhone || ""),
      String(s.contactExtension || ""),
      String(s.contactEmail || ""),
    ]
  );
  const supplierRows = await q("SELECT * FROM suppliers WHERE id = ? LIMIT 1", [out.insertId]);
  const supplier = mapSupplierRow(supplierRows[0]);
  const user = await getUserSafeById(req.session.userId);
  res.json({ supplier, user });
});

router.post(
  "/api/me/suppliers/:sid/biz-cert",
  needLogin,
  function (req, res, next) {
    uploadRecipientCert.single("file")(req, res, function (err) {
      if (err) return res.status(400).json({ error: err.message || "파일 업로드 오류" });
      next();
    });
  },
  async function (req, res) {
    const sid = Number(req.params.sid);
    const found = await q("SELECT * FROM suppliers WHERE id = ? AND user_id = ? LIMIT 1", [sid, req.session.userId]);
    if (!found.length) return res.status(404).json({ error: "공급자를 찾을 수 없습니다." });
    if (!req.file || !req.file.buffer) return res.status(400).json({ error: "PDF 파일을 선택하세요." });
    await ensureSupplierCertDir();
    const newFile = "supplier-" + sid + "-" + Date.now() + "-" + crypto.randomBytes(6).toString("hex") + ".pdf";
    await fs.promises.writeFile(path.join(SUPPLIER_CERT_ABS_DIR, newFile), req.file.buffer);
    const originalName = cleanUploadName(Buffer.from(req.file.originalname || "", "latin1").toString("utf8") || "사업자등록증.pdf");
    const oldFile = String(found[0].biz_cert_file || "").trim();
    await q("UPDATE suppliers SET biz_cert_file=?, biz_cert_name=? WHERE id = ? AND user_id = ?", [newFile, originalName, sid, req.session.userId]);
    if (oldFile && oldFile !== newFile) await removeSupplierCertFile(oldFile);
    const user = await getUserSafeById(req.session.userId);
    res.json({ user });
  }
);

router.delete("/api/me/suppliers/:sid/biz-cert", needLogin, async function (req, res) {
  const sid = Number(req.params.sid);
  const found = await q("SELECT * FROM suppliers WHERE id = ? AND user_id = ? LIMIT 1", [sid, req.session.userId]);
  if (!found.length) return res.status(404).json({ error: "공급자를 찾을 수 없습니다." });
  const oldFile = String(found[0].biz_cert_file || "").trim();
  await q("UPDATE suppliers SET biz_cert_file='', biz_cert_name='' WHERE id = ? AND user_id = ?", [sid, req.session.userId]);
  if (oldFile) await removeSupplierCertFile(oldFile);
  const user = await getUserSafeById(req.session.userId);
  res.json({ user });
});

router.delete("/api/me/suppliers/:sid", needLogin, async function (req, res) {
  const sid = Number(req.params.sid);
  const certRow = await q("SELECT biz_cert_file FROM suppliers WHERE id = ? AND user_id = ? LIMIT 1", [sid, req.session.userId]);
  const all = await q("SELECT id FROM suppliers WHERE user_id = ? ORDER BY id ASC", [
    req.session.userId,
  ]);
  if (all.length <= 1) {
    return res.status(400).json({ error: "마지막 공급자는 삭제할 수 없습니다." });
  }
  if (certRow.length && certRow[0].biz_cert_file) await removeSupplierCertFile(certRow[0].biz_cert_file);
  await q("DELETE FROM suppliers WHERE id = ? AND user_id = ?", [
    sid,
    req.session.userId,
  ]);
  const userAfter = await getUserSafeById(req.session.userId);
  if (!userAfter) return res.status(404).json({ error: "없음" });
  const ok = userAfter.suppliers.some(function (s) {
    return s.id === userAfter.activeSupplierId;
  });
  if (!ok) {
    await q("UPDATE users SET active_supplier_id = ? WHERE id = ?", [
      userAfter.suppliers[0].id,
      req.session.userId,
    ]);
  }
  const finalUser = await getUserSafeById(req.session.userId);
  res.json({ user: finalUser });
});

router.put("/api/me/supplier/active", needLogin, async function (req, res) {
  const sid = Number((req.body || {}).id);
  const rows = await q(
    "SELECT id FROM suppliers WHERE id = ? AND user_id = ? LIMIT 1",
    [sid, req.session.userId]
  );
  if (!rows.length) return res.status(404).json({ error: "공급자를 찾을 수 없습니다." });
  await q("UPDATE users SET active_supplier_id = ? WHERE id = ?", [sid, req.session.userId]);
  const user = await getUserSafeById(req.session.userId);
  res.json({ user });
});

const BUILTIN_MONITORING_OPTIONS = ["솔라링", "DY"];

router.get("/api/monitoring-options", needLogin, async function (req, res) {
  const rows = await q(
    "SELECT id, name FROM monitoring_options WHERE user_id = ? ORDER BY created_at",
    [req.session.userId]
  );
  const custom = rows.map(function (r) {
    return { id: Number(r.id), name: String(r.name), builtin: false };
  });
  const builtin = BUILTIN_MONITORING_OPTIONS.map(function (n) {
    return { id: null, name: n, builtin: true };
  });
  res.json({ options: builtin.concat(custom) });
});

router.post("/api/monitoring-options", needLogin, async function (req, res) {
  const name = String((req.body || {}).name || "").trim();
  if (!name) return res.status(400).json({ error: "이름을 입력하세요." });
  if (BUILTIN_MONITORING_OPTIONS.includes(name)) {
    return res.status(400).json({ error: "이미 기본 목록에 있는 이름입니다." });
  }
  try {
    const out = await q(
      "INSERT INTO monitoring_options (user_id, name) VALUES (?, ?)",
      [req.session.userId, name]
    );
    res.json({ option: { id: Number(out.insertId), name, builtin: false } });
  } catch (e) {
    if (e.code === "ER_DUP_ENTRY") {
      return res.status(400).json({ error: "이미 존재하는 이름입니다." });
    }
    throw e;
  }
});

router.delete("/api/monitoring-options/:id", needLogin, async function (req, res) {
  const id = Number(req.params.id);
  await q("DELETE FROM monitoring_options WHERE id = ? AND user_id = ?", [id, req.session.userId]);
  res.json({ ok: true });
});

router.get("/api/recipients", needLogin, async function (req, res) {
  const list = await getRecipientsByUserId(req.session.userId);
  res.json({ recipients: list });
});

router.get("/api/recipients/export-excel", needLogin, async function (req, res) {
  try {
    const list = await getRecipientsByUserId(req.session.userId);

    function memberTypeLabel(kind, bizSubtype) {
      if (kind === "individual") return "개인";
      if (kind === "foreign") return "외국인";
      if (kind === "business") {
        if (bizSubtype === "corp") return "법인";
        if (bizSubtype === "nonprofit") return "비영리";
        return "개인사업자";
      }
      return "개인";
    }

    function monitoringExportVal(svcMonitoring, monitoringType) {
      if (!svcMonitoring) return "";
      if (!monitoringType || monitoringType === "DY") return "O";
      return monitoringType;
    }

    // import 인식 헤더 그대로 사용 — 재가져오기 시 자동 매핑됨
    const headers = [
      "상호명", "회원유형", "사업자등록번호", "대표자",
      "사업장소재지", "휴대전화", "이메일", "업태", "종목",
      "수전용량(kW)", "태양광용량(kW)",
      "발전소명", "품목명", "공급가액", "세액",
      "안전관리", "세무", "청구", "모니터링",
      "결제방식", "메모",
    ];

    const rows = [];
    for (var i = 0; i < list.length; i++) {
      var r = list[i];
      var items = r.items && r.items.length ? r.items : [null];
      for (var j = 0; j < items.length; j++) {
        var it = items[j];
        rows.push([
          r.displayName,
          memberTypeLabel(r.kind, r.bizSubtype),
          r.bizNo,
          r.ceoName,
          r.address,
          r.contactPhone,
          r.email,
          r.bizType,
          r.bizItem,
          r.receptionCapacity || "",
          r.generationCapacity || "",
          it ? (it.plantName || "") : "",
          it ? (it.fixedItemName || "") : "",
          it ? (it.monthlySupply || 0) : "",
          it ? (it.monthlyTax || 0) : "",
          r.svcSafety ? "O" : "",
          r.svcTax ? "O" : "",
          r.svcBilling ? "O" : "",
          monitoringExportVal(r.svcMonitoring, r.monitoringType),
          r.paymentMethod,
          r.internalMemo,
        ]);
      }
    }

    const wb = XLSX.utils.book_new();
    const ws = XLSX.utils.aoa_to_sheet([headers, ...rows]);
    XLSX.utils.book_append_sheet(wb, ws, "공급받는자");
    const buf = XLSX.write(wb, { type: "buffer", bookType: "xlsx" });

    const today = new Date();
    const dateStr =
      today.getFullYear() +
      String(today.getMonth() + 1).padStart(2, "0") +
      String(today.getDate()).padStart(2, "0");
    const filename = encodeURIComponent("공급받는자_" + dateStr + ".xlsx");

    res.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + filename);
    res.setHeader("Content-Type", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
    res.send(buf);
  } catch (err) {
    console.error("recipients export-excel error:", err);
    res.status(500).json({ error: "엑셀 내보내기 실패" });
  }
});

router.post("/api/recipients", needLogin, async function (req, res) {
  const b = req.body || {};
  const kind = String(b.kind || "individual");
  const normalizedBizNo = formatRecipientNoByKind(kind, b.bizNo);
  const out = await q(
    "INSERT INTO recipients (user_id, kind, biz_subtype, display_name, biz_no, ceo_name, address, email, capacity, reception_capacity, generation_capacity, biz_type, biz_item, internal_memo, contact_name, contact_phone, contact_email, svc_safety, svc_tax, svc_billing, svc_monitoring, monitoring_type, payment_method) " +
      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
    [
      req.session.userId,
      kind,
      b.bizSubtype == null ? null : String(b.bizSubtype),
      String(b.displayName || ""),
      normalizedBizNo,
      String(b.ceoName || ""),
      String(b.address || ""),
      String(b.email || ""),
      Number(b.capacity) || 0,
      Number(b.receptionCapacity) || 0,
      Number(b.generationCapacity) || 0,
      String(b.bizType || ""),
      String(b.bizItem || ""),
      String(b.internalMemo || ""),
      String(b.contactName || ""),
      String(b.contactPhone || ""),
      String(b.contactEmail || ""),
      b.svcSafety     ? 1 : 0,
      b.svcTax        ? 1 : 0,
      b.svcBilling    ? 1 : 0,
      b.svcMonitoring ? 1 : 0,
      String(b.monitoringType || ""),
      String(b.paymentMethod  || ""),
    ]
  );
  const rec = await getRecipientById(req.session.userId, Number(out.insertId));
  res.json({ recipient: rec });
});

router.put("/api/recipients/:id", needLogin, async function (req, res) {
  const id = Number(req.params.id);
  const rec = await getRecipientById(req.session.userId, id);
  if (!rec) return res.status(404).json({ error: "없음" });
  const b = req.body || {};
  const nextKind = String(b.kind || rec.kind);
  const nextBizNoRaw = b.bizNo === undefined ? rec.bizNo : b.bizNo;
  const nextBizNo = formatRecipientNoByKind(nextKind, nz(nextBizNoRaw, ""));
  await q(
    "UPDATE recipients SET kind=?, biz_subtype=?, display_name=?, biz_no=?, ceo_name=?, address=?, email=?, capacity=?, reception_capacity=?, generation_capacity=?, biz_type=?, biz_item=?, internal_memo=?, contact_name=?, contact_phone=?, contact_email=?, svc_safety=?, svc_tax=?, svc_billing=?, svc_monitoring=?, monitoring_type=?, payment_method=? " +
      "WHERE id = ? AND user_id = ?",
    [
      nextKind,
      b.bizSubtype === undefined ? rec.bizSubtype : b.bizSubtype == null ? null : String(b.bizSubtype),
      String(nz(b.displayName, rec.displayName)),
      nextBizNo,
      String(nz(b.ceoName, rec.ceoName)),
      String(nz(b.address, rec.address)),
      String(nz(b.email, rec.email)),
      b.capacity !== undefined ? (Number(b.capacity) || 0) : (Number(rec.capacity) || 0),
      b.receptionCapacity  !== undefined ? (Number(b.receptionCapacity)  || 0) : (Number(rec.receptionCapacity)  || 0),
      b.generationCapacity !== undefined ? (Number(b.generationCapacity) || 0) : (Number(rec.generationCapacity) || 0),
      String(nz(b.bizType, rec.bizType)),
      String(nz(b.bizItem, rec.bizItem)),
      String(nz(b.internalMemo, rec.internalMemo)),
      b.contactName  !== undefined ? String(b.contactName  || "") : String(rec.contactName  || ""),
      b.contactPhone !== undefined ? String(b.contactPhone || "") : String(rec.contactPhone || ""),
      b.contactEmail !== undefined ? String(b.contactEmail || "") : String(rec.contactEmail || ""),
      b.svcSafety     !== undefined ? (b.svcSafety     ? 1 : 0) : (rec.svcSafety     ? 1 : 0),
      b.svcTax        !== undefined ? (b.svcTax        ? 1 : 0) : (rec.svcTax        ? 1 : 0),
      b.svcBilling    !== undefined ? (b.svcBilling    ? 1 : 0) : (rec.svcBilling    ? 1 : 0),
      b.svcMonitoring !== undefined ? (b.svcMonitoring ? 1 : 0) : (rec.svcMonitoring ? 1 : 0),
      (b.svcMonitoring !== undefined ? b.svcMonitoring : rec.svcMonitoring) ? (b.monitoringType !== undefined ? String(b.monitoringType || "") : String(rec.monitoringType || "")) : "",
      b.paymentMethod  !== undefined ? String(b.paymentMethod  || "") : String(rec.paymentMethod  || ""),
      id,
      req.session.userId,
    ]
  );
  const next = await getRecipientById(req.session.userId, id);
  res.json({ recipient: next });
});

router.delete("/api/recipients/:id", needLogin, async function (req, res) {
  const id = Number(req.params.id);
  const rec = await getRecipientById(req.session.userId, id);
  await q("DELETE FROM recipients WHERE id = ? AND user_id = ?", [id, req.session.userId]);
  if (rec && rec.bizCertFile) await removeRecipientCertFile(rec.bizCertFile);
  res.json({ ok: true });
});

router.post(
  "/api/recipients/:id/biz-cert",
  needLogin,
  function (req, res, next) {
    uploadRecipientCert.single("file")(req, res, function (err) {
      if (err) return res.status(400).json({ error: err.message || "파일 업로드 오류" });
      next();
    });
  },
  async function (req, res) {
    const id = Number(req.params.id);
    const rec = await getRecipientById(req.session.userId, id);
    if (!rec) return res.status(404).json({ error: "공급받는자를 찾을 수 없습니다." });
    if (!req.file || !req.file.buffer) {
      return res.status(400).json({ error: "PDF 파일을 선택하세요." });
    }
    await ensureRecipientCertDir();
    const newFile =
      "recipient-" +
      id +
      "-" +
      Date.now() +
      "-" +
      crypto.randomBytes(6).toString("hex") +
      ".pdf";
    await fs.promises.writeFile(path.join(RECIPIENT_CERT_ABS_DIR, newFile), req.file.buffer);
    const originalName = cleanUploadName(Buffer.from(req.file.originalname || "", "latin1").toString("utf8") || "사업자등록증.pdf");
    await q(
      "UPDATE recipients SET biz_cert_file=?, biz_cert_name=? WHERE id = ? AND user_id = ?",
      [newFile, originalName, id, req.session.userId]
    );
    if (rec.bizCertFile && rec.bizCertFile !== newFile) {
      await removeRecipientCertFile(rec.bizCertFile);
    }
    const next = await getRecipientById(req.session.userId, id);
    res.json({ recipient: next });
  }
);

router.delete("/api/recipients/:id/biz-cert", needLogin, async function (req, res) {
  const id = Number(req.params.id);
  const rec = await getRecipientById(req.session.userId, id);
  if (!rec) return res.status(404).json({ error: "공급받는자를 찾을 수 없습니다." });
  await q(
    "UPDATE recipients SET biz_cert_file='', biz_cert_name='' WHERE id = ? AND user_id = ?",
    [id, req.session.userId]
  );
  if (rec.bizCertFile) await removeRecipientCertFile(rec.bizCertFile);
  const next = await getRecipientById(req.session.userId, id);
  res.json({ recipient: next });
});

router.post("/api/recipients/:id/items", needLogin, async function (req, res) {
  const id = Number(req.params.id);
  const rec = await getRecipientById(req.session.userId, id);
  if (!rec) return res.status(404).json({ error: "없음" });
  const b = req.body || {};
  const supply = Number(b.monthlySupply) || 0;
  await q(
    "INSERT INTO recipient_items (recipient_id, plant_name, fixed_item_name, monthly_supply, monthly_tax, quantity, unit_price, note) " +
      "VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
    [
      id,
      String(b.plantName != null ? b.plantName : ""),
      String(b.fixedItemName != null ? b.fixedItemName : ""),
      supply,
      calcFixedTax(supply),
      Number(b.quantity) || 0,
      Number(b.unitPrice) || 0,
      String(b.note || ""),
    ]
  );
  const next = await getRecipientById(req.session.userId, id);
  res.json({ recipient: next });
});

router.put("/api/recipients/:rid/items/:iid", needLogin, async function (req, res) {
  const rid = Number(req.params.rid);
  const iid = Number(req.params.iid);
  const rec = await getRecipientById(req.session.userId, rid);
  if (!rec) return res.status(404).json({ error: "없음" });
  const old = rec.items.find(function (x) {
    return x.id === iid;
  });
  if (!old) return res.status(404).json({ error: "품목 없음" });
  const b = req.body || {};
  const supply = Number(nz(b.monthlySupply, old.monthlySupply)) || 0;
  await q(
    "UPDATE recipient_items SET plant_name=?, fixed_item_name=?, monthly_supply=?, monthly_tax=?, quantity=?, unit_price=?, note=? " +
      "WHERE id = ? AND recipient_id = ?",
    [
      String(nz(b.plantName, old.plantName)),
      b.fixedItemName !== undefined ? String(b.fixedItemName) : old.fixedItemName,
      supply,
      calcFixedTax(supply),
      b.quantity !== undefined ? Number(b.quantity) || 0 : old.quantity,
      b.unitPrice !== undefined ? Number(b.unitPrice) || 0 : old.unitPrice,
      String(nz(b.note, old.note)),
      iid,
      rid,
    ]
  );
  const next = await getRecipientById(req.session.userId, rid);
  res.json({ recipient: next });
});

router.delete("/api/recipients/:rid/items/:iid", needLogin, async function (req, res) {
  const rid = Number(req.params.rid);
  const iid = Number(req.params.iid);
  const rec = await getRecipientById(req.session.userId, rid);
  if (!rec) return res.status(404).json({ error: "없음" });
  await q("DELETE FROM recipient_items WHERE id = ? AND recipient_id = ?", [iid, rid]);
  const next = await getRecipientById(req.session.userId, rid);
  res.json({ recipient: next });
});

router.post(
  "/api/recipients/import-excel/preview",
  needLogin,
  function (req, res, next) {
    uploadExcel.single("file")(req, res, function (err) {
      if (err) return res.status(400).json({ error: err.message || "파일 업로드 오류" });
      next();
    });
  },
  async function (req, res) {
    if (!req.file || !req.file.buffer) {
      return res.status(400).json({ error: "엑셀 파일을 선택하세요." });
    }
    let parsed;
    try {
      parsed = parseWorkbookBuffer(req.file.buffer);
    } catch (e) {
      return res.status(400).json({ error: "엑셀을 읽는 중 오류: " + e.message });
    }
    if (parsed.error) return res.status(400).json({ error: parsed.error });
    const multiItem = (parsed.recipients || [])
      .filter(function (r) { return r.items.length > 1; })
      .map(function (r) {
        return {
          key: r.key,
          displayName: r.displayName || r.bizDisplay || "",
          bizDisplay: r.bizDisplay || "",
          items: r.items.map(function (it) {
            return { plantName: it.plantName || "", fixedItemName: it.fixedItemName || "" };
          }),
        };
      });
    res.json({ total: (parsed.recipients || []).length, multiItem });
  }
);

router.post(
  "/api/recipients/import-excel",
  needLogin,
  function (req, res, next) {
    uploadExcel.single("file")(req, res, function (err) {
      if (err) return res.status(400).json({ error: err.message || "파일 업로드 오류" });
      next();
    });
  },
  async function (req, res) {
    if (!req.file || !req.file.buffer) {
      return res.status(400).json({ error: "엑셀 파일을 선택하세요." });
    }
    const mode = String(req.body.mode || "reset");
    let recipientChoices = {};
    try {
      if (req.body.recipientChoices) recipientChoices = JSON.parse(req.body.recipientChoices);
    } catch (e) {}
    let parsed;
    try {
      parsed = parseWorkbookBuffer(req.file.buffer);
    } catch (e) {
      return res.status(400).json({ error: "엑셀을 읽는 중 오류: " + e.message });
    }
    if (parsed.error) return res.status(400).json({ error: parsed.error });
    if (!parsed.recipients || parsed.recipients.length === 0) {
      return res.status(400).json({
        error:
          "가져올 데이터가 없습니다. 열 이름에 공급받는자·품목·공급가액 등이 있는지 확인하세요.",
        debug: { sheetName: parsed.sheetName, headerRow: parsed.headerRow },
      });
    }

    const recipientsToProcess = [];
    for (let i = 0; i < parsed.recipients.length; i++) {
      const r = parsed.recipients[i];
      const choice = recipientChoices[r.key] || "merge";
      if (choice === "split" && r.items.length > 1) {
        for (let j = 0; j < r.items.length; j++) {
          const it = r.items[j];
          recipientsToProcess.push(Object.assign({}, r, {
            items: [it],
            _noMergeByBiz: true,
            receptionCapacity:  it.receptionCapacity  != null ? it.receptionCapacity  : (r.receptionCapacity  || 0),
            generationCapacity: it.generationCapacity != null ? it.generationCapacity : (r.generationCapacity || 0),
            internalMemo:   it.internalMemo   != null ? it.internalMemo   : "",
            svcSafety:      it.svcSafety      != null ? it.svcSafety      : (r.svcSafety      || false),
            svcTax:         it.svcTax         != null ? it.svcTax         : (r.svcTax         || false),
            svcBilling:     it.svcBilling     != null ? it.svcBilling     : (r.svcBilling     || false),
            svcMonitoring:  it.svcMonitoring  != null ? it.svcMonitoring  : (r.svcMonitoring  || false),
            monitoringType: it.monitoringType != null ? it.monitoringType : "",
            paymentMethod:  it.paymentMethod  != null ? it.paymentMethod  : "",
          }));
        }
      } else {
        recipientsToProcess.push(r);
      }
    }

    const uid = req.session.userId;
    let created = 0;
    let updated = 0;
    let itemsAdded = 0;

    await withTx(async function (conn) {
      if (mode === "reset") {
        await conn.query("DELETE FROM recipients WHERE user_id = ?", [uid]);
      }

      for (let i = 0; i < recipientsToProcess.length; i++) {
        const g = recipientsToProcess[i];
        const hasBiz10 = g.bizDigits && g.bizDigits.length === 10;
        const hasRes13 = g.residentDigits && g.residentDigits.length === 13;
        const bizNo = hasBiz10
          ? formatBizNoDisplay(g.bizDigits)
          : String(g.residentDisplay || g.bizDisplay || "");
        const displayName = String(g.displayName || g.bizDisplay || "이름없음");
        const kind = g.kind === "business" ? "business" : "individual";
        const bizSubtype = kind === "business" ? String(g.bizSubtype || "sole") : null;

        let recId = null;
        if (mode === "merge" && !g._noMergeByBiz) {
          const recRows = await conn.query(
            "SELECT id, display_name, biz_no FROM recipients WHERE user_id = ?",
            [uid]
          );
          const existing = recRows[0] || [];
          for (let j = 0; j < existing.length; j++) {
            const row = existing[j];
            const rowBiz = normalizeBizNoKey(row.biz_no);
            const rowRes = normalizeResidentKey(row.biz_no);
            if (hasBiz10 && rowBiz === g.bizDigits) {
              recId = Number(row.id);
              break;
            }
            if (hasRes13 && rowRes === g.residentDigits) {
              recId = Number(row.id);
              break;
            }
            if (
              !hasBiz10 &&
              !hasRes13 &&
              rowBiz === "" &&
              rowRes === "" &&
              String(row.display_name || "") === displayName
            ) {
              recId = Number(row.id);
              break;
            }
          }
        }

        if (recId) {
          // 새 값이 있을 때만 덮어씀 — 빈 값으로 기존 데이터가 지워지지 않도록
          await conn.query(
            "UPDATE recipients SET kind=?, biz_subtype=?," +
              " display_name=IF(? != '', ?, display_name)," +
              " biz_no=IF(? != '', ?, biz_no)," +
              " ceo_name=IF(? != '', ?, ceo_name)," +
              " address=IF(? != '', ?, address)," +
              " email=IF(? != '', ?, email)," +
              " contact_phone=IF(? != '', ?, contact_phone)," +
              " reception_capacity=IF(? > 0, ?, reception_capacity)," +
              " generation_capacity=IF(? > 0, ?, generation_capacity)," +
              " biz_type=IF(? != '', ?, biz_type)," +
              " biz_item=IF(? != '', ?, biz_item)," +
              " internal_memo=IF(? != '', ?, internal_memo)," +
              " svc_safety=?, svc_tax=?, svc_billing=?, svc_monitoring=?," +
              " monitoring_type=IF(? != '', ?, monitoring_type)," +
              " payment_method=IF(? != '', ?, payment_method)" +
              " WHERE id = ? AND user_id = ?",
            [
              kind, bizSubtype,
              displayName, displayName,
              bizNo || "", bizNo || "",
              String(g.ceoName || ""), String(g.ceoName || ""),
              String(g.address || ""), String(g.address || ""),
              String(g.email || ""), String(g.email || ""),
              String(g.contactPhone || ""), String(g.contactPhone || ""),
              Number(g.receptionCapacity) || 0, Number(g.receptionCapacity) || 0,
              Number(g.generationCapacity) || 0, Number(g.generationCapacity) || 0,
              String(g.bizType || ""), String(g.bizType || ""),
              String(g.bizItem || ""), String(g.bizItem || ""),
              String(g.internalMemo || ""), String(g.internalMemo || ""),
              g.svcSafety     ? 1 : 0,
              g.svcTax        ? 1 : 0,
              g.svcBilling    ? 1 : 0,
              g.svcMonitoring ? 1 : 0,
              String(g.monitoringType || ""), String(g.monitoringType || ""),
              String(g.paymentMethod  || ""), String(g.paymentMethod  || ""),
              recId, uid,
            ]
          );
          // 품목 upsert — plant_name + fixed_item_name 기준으로 기존 항목 있으면 업데이트, 없으면 삽입
          for (let j = 0; j < g.items.length; j++) {
            const it = g.items[j];
            const plantName = String(it.plantName != null ? it.plantName : "");
            const fixedItemName = String(it.fixedItemName != null ? it.fixedItemName : "");
            const supply = Number(it.monthlySupply) || 0;
            const note = String(it.note || "");
            const existRes = await conn.query(
              "SELECT id, monthly_supply, note FROM recipient_items WHERE recipient_id = ? AND plant_name = ? AND fixed_item_name = ? LIMIT 1",
              [recId, plantName, fixedItemName]
            );
            const existItem = (existRes[0] || [])[0];
            if (existItem) {
              const newSupply = supply !== 0 ? supply : Number(existItem.monthly_supply);
              const newNote = note !== "" ? note : String(existItem.note || "");
              await conn.query(
                "UPDATE recipient_items SET monthly_supply=?, monthly_tax=?, note=? WHERE id=?",
                [newSupply, calcFixedTax(newSupply), newNote, existItem.id]
              );
            } else {
              await conn.query(
                "INSERT INTO recipient_items (recipient_id, plant_name, fixed_item_name, monthly_supply, monthly_tax, note) VALUES (?, ?, ?, ?, ?, ?)",
                [recId, plantName, fixedItemName, supply, calcFixedTax(supply), note]
              );
              itemsAdded += 1;
            }
          }
          updated += 1;
        } else {
          const recOut = await conn.query(
            "INSERT INTO recipients (user_id, kind, biz_subtype, display_name, biz_no, ceo_name, address, email, contact_phone, reception_capacity, generation_capacity, biz_type, biz_item, internal_memo, svc_safety, svc_tax, svc_billing, svc_monitoring, monitoring_type, payment_method) " +
              "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            [
              uid,
              kind,
              bizSubtype,
              displayName,
              bizNo || "",
              String(g.ceoName || ""),
              String(g.address || ""),
              String(g.email || ""),
              String(g.contactPhone || ""),
              Number(g.receptionCapacity) || 0,
              Number(g.generationCapacity) || 0,
              String(g.bizType || ""),
              String(g.bizItem || ""),
              String(g.internalMemo || ""),
              g.svcSafety     ? 1 : 0,
              g.svcTax        ? 1 : 0,
              g.svcBilling    ? 1 : 0,
              g.svcMonitoring ? 1 : 0,
              String(g.monitoringType || ""),
              String(g.paymentMethod  || ""),
            ]
          );
          const newRecId = Number((recOut[0] || {}).insertId);
          for (let j = 0; j < g.items.length; j++) {
            const it = g.items[j];
            const supply = Number(it.monthlySupply) || 0;
            await conn.query(
              "INSERT INTO recipient_items (recipient_id, plant_name, fixed_item_name, monthly_supply, monthly_tax, note) " +
                "VALUES (?, ?, ?, ?, ?, ?)",
              [
                newRecId,
                String(it.plantName != null ? it.plantName : ""),
                String(it.fixedItemName != null ? it.fixedItemName : ""),
                supply,
                calcFixedTax(supply),
                String(it.note || ""),
              ]
            );
            itemsAdded += 1;
          }
          created += 1;
        }
      }
    });

    const colSummary = {};
    const cm = parsed.colMap || {};
    Object.keys(cm).forEach(function (k) {
      colSummary[k] = cm[k];
    });
    res.json({
      ok: true,
      created,
      updated,
      itemsAdded,
      recipientCount: parsed.recipients.length,
      sheetName: parsed.sheetName,
      headerRow: parsed.headerRow,
      colMap: colSummary,
    });
  }
);

router.get("/api/server-time", needLogin, function (req, res) {
  res.json(kstYearMonthDay());
});

router.post("/api/dashboard/mock-seed", needLogin, async function (req, res) {
  const uid = req.session.userId;
  const thisYm = kstYearMonthDay().yearMonth;
  const samples = [
    { name: "목업 태양광 A", supply: 500000, tax: 50000, ts: "transmitted_practice" },
    { name: "목업 태양광 B", supply: 320000, tax: 32000, ts: "not_sent" },
    { name: "목업 태양광 C", supply: 180000, tax: 18000, ts: "not_sent" },
  ];
  for (let i = 0; i < samples.length; i++) {
    const s = samples[i];
    await q(
      "INSERT INTO issue_records (" +
        "user_id, year_month_key, recipient_id, recipient_name, total_supply, total_tax, transmit_status, status, mock_seed" +
        ") VALUES (?, ?, 0, ?, ?, ?, ?, 'issued', 1)",
      [uid, thisYm, s.name, s.supply, s.tax, s.ts]
    );
  }
  res.json({ ok: true, added: samples.length });
});

router.get("/api/dashboard/stats", needLogin, async function (req, res) {
  const uid = req.session.userId;
  const issueRows = await q(
    "SELECT * FROM issue_records WHERE user_id = ? ORDER BY created_at DESC LIMIT 2000",
    [uid]
  );
  const all = issueRows.map(mapIssueRecordRow);
  const thisYm = kstYearMonthDay().yearMonth;
  const lastYm = prevYearMonth(thisYm);
  const thisY = thisYm.slice(0, 4);
  const lastY = String(Number(thisY) - 1);

  function byYm(ym) {
    return all.filter(function (r) {
      return r.yearMonth === ym;
    });
  }
  function byYear(y) {
    return all.filter(function (r) {
      return r.yearMonth.startsWith(y + "-");
    });
  }

  const recipients = await getRecipientsByUserId(uid);
  const eligible = recipients.filter(function (r) {
    return r.items.length > 0;
  });
  const issuedThisMonth = new Set(
    byYm(thisYm).map(function (r) {
      return r.recipientId;
    })
  );
  const pendingIssue = eligible.filter(function (r) {
    return !issuedThisMonth.has(r.id);
  }).length;

  let regSupply = 0;
  let regTax = 0;
  for (let i = 0; i < recipients.length; i++) {
    for (let j = 0; j < recipients[i].items.length; j++) {
      regSupply += Number(recipients[i].items[j].monthlySupply) || 0;
      regTax += Number(recipients[i].items[j].monthlyTax) || 0;
    }
  }

  const recent = all
    .slice()
    .sort(function (a, b) {
      return new Date(b.createdAt) - new Date(a.createdAt);
    })
    .slice(0, 30);

  const tmSum = sumIssueRecords(byYm(thisYm));
  tmSum.pendingIssueCount = pendingIssue;
  const tmTransmitted = byYm(thisYm).filter(function (r) {
    return r.transmitStatus === "transmitted_practice";
  });
  const tmTransmittedSum = sumIssueRecords(tmTransmitted);

  const recipientInfoMap = {};
  for (let i = 0; i < recipients.length; i++) {
    const r = recipients[i];
    recipientInfoMap[r.id] = {
      ceoName: r.ceoName || "",
      plantNames: (r.items || []).map(function (it) { return it.plantName || ""; }).filter(Boolean),
    };
  }
  const thisMonthRecords = byYm(thisYm).map(function (r) {
    const info = recipientInfoMap[r.recipientId] || {};
    return {
      recipientName: r.recipientName,
      ceoName: info.ceoName || "",
      plantNames: info.plantNames || [],
      transmitStatus: r.transmitStatus,
      totalSupply: r.totalSupply,
      totalTax: r.totalTax,
    };
  });

  res.json({
    kstYearMonth: thisYm,
    periods: {
      thisMonth: Object.assign({ yearMonth: thisYm, label: "이번 달" }, tmSum),
      lastMonth: Object.assign({ yearMonth: lastYm, label: "지난 달" }, sumIssueRecords(byYm(lastYm))),
      thisYear: Object.assign({ year: thisY, label: "올해" }, sumIssueRecords(byYear(thisY))),
      lastYear: Object.assign({ year: lastY, label: "작년" }, sumIssueRecords(byYear(lastY))),
    },
    pendingIssueThisMonth: pendingIssue,
    eligibleRecipientCount: eligible.length,
    transmittedThisMonth: {
      count: tmTransmittedSum.issueCount,
      supply: tmTransmittedSum.supply,
      tax: tmTransmittedSum.tax,
      total: tmTransmittedSum.total,
    },
    registeredMonthly: {
      supply: regSupply,
      tax: regTax,
      total: regSupply + regTax,
      lineCount: recipients.reduce(function (n, r) {
        return n + r.items.length;
      }, 0),
    },
    recent,
    thisMonthRecords,
  });
});

router.post("/api/issue-records", needLogin, async function (req, res) {
  const yearMonth = String((req.body || {}).yearMonth || "").trim();
  const entries = (req.body || {}).entries || [];
  const out = await upsertIssueRecordsFromEntries(req.session.userId, yearMonth, entries);
  if (out.error) return res.status(400).json({ error: out.error });
  res.json({ ok: true, saved: out.saved, recordIds: out.recordIds });
});

router.get("/api/issue-records", needLogin, async function (req, res) {
  const uid = req.session.userId;
  const qYm = String(req.query.yearMonth || "").trim();
  const qTs = String(req.query.transmitStatus || "").trim();
  const qRaw = String(req.query.q || "").trim().toLowerCase();

  const cond = ["user_id = ?"];
  const params = [uid];
  if (qYm) {
    cond.push("year_month_key = ?");
    params.push(qYm);
  }
  if (qTs) {
    cond.push("transmit_status = ?");
    params.push(qTs);
  }
  const rows = await q(
    "SELECT * FROM issue_records WHERE " +
      cond.join(" AND ") +
      " ORDER BY created_at DESC LIMIT 500",
    params
  );
  let list = rows.map(mapIssueRecordRow);
  if (qRaw) {
    const qn = qRaw.replace(/\s/g, "");
    list = list.filter(function (r) {
      const hay = (String(r.recipientName || "") + " " + String(r.yearMonth || "") + " " + String(r.id || ""))
        .toLowerCase()
        .replace(/\s/g, "");
      return hay.indexOf(qn) >= 0;
    });
  }
  res.json({ records: list });
});

router.get("/api/issue-records/year-matrix", needLogin, async function (req, res) {
  const uid = req.session.userId;
  const nowYear = new Date().getFullYear();
  const qYear = Number(req.query.year);
  const year = Number.isFinite(qYear) && qYear >= 2000 && qYear <= 3000 ? qYear : nowYear;
  const yearPrefix = String(year) + "-";

  const recipientRows = await q(
    "SELECT r.id, r.display_name, COALESCE(SUM(i.monthly_supply), 0) AS supply, " +
      "COALESCE(SUM(i.monthly_supply + i.monthly_tax), 0) AS total " +
      "FROM recipients r " +
      "LEFT JOIN recipient_items i ON i.recipient_id = r.id " +
      "WHERE r.user_id = ? " +
      "GROUP BY r.id, r.display_name " +
      "ORDER BY r.display_name ASC, r.id ASC",
    [uid]
  );
  const noteRows = await q(
    "SELECT recipient_id, note FROM issue_matrix_notes WHERE user_id = ? AND year_no = ?",
    [uid, year]
  );
  const noteMap = {};
  for (let i = 0; i < noteRows.length; i++) {
    noteMap[Number(noteRows[i].recipient_id)] = String(noteRows[i].note || "");
  }

  const recMap = {};
  for (let i = 0; i < recipientRows.length; i++) {
    const r = recipientRows[i];
    recMap[Number(r.id)] = {
      recipientId: Number(r.id),
      recipientName: String(r.display_name || ""),
      supply: Number(r.supply) || 0,
      total: Number(r.total) || 0,
      months: Array(12).fill("none"),
      monthRecords: Array(12).fill(null),
      note: noteMap[Number(r.id)] || "",
    };
  }

  const recordRows = await q(
    "SELECT * FROM issue_records WHERE user_id = ? AND year_month_key LIKE ? ORDER BY created_at ASC",
    [uid, yearPrefix + "%"]
  );
  for (let i = 0; i < recordRows.length; i++) {
    const row = mapIssueRecordRow(recordRows[i]);
    const target = recMap[row.recipientId];
    if (!target) continue;
    const m = Number(String(row.yearMonth).slice(5, 7));
    if (!Number.isFinite(m) || m < 1 || m > 12) continue;
    target.months[m - 1] = row.transmitStatus;
    target.monthRecords[m - 1] = {
      id: row.id,
      yearMonth: row.yearMonth,
      issueDate: row.issueDate,
      recipientId: row.recipientId,
      createdAt: row.createdAt,
      totalSupply: row.totalSupply,
      totalTax: row.totalTax,
      transmitStatus: row.transmitStatus,
      recipientName: row.recipientName,
    };
  }

  res.json({
    year,
    rows: Object.keys(recMap).map(function (k) {
      return recMap[k];
    }),
  });
});

router.put("/api/issue-records/year-matrix/note", needLogin, async function (req, res) {
  const uid = req.session.userId;
  const b = req.body || {};
  const year = Number(b.year);
  const recipientId = Number(b.recipientId);
  const note = String(b.note || "").trim().slice(0, 500);
  if (!Number.isFinite(year) || year < 2000 || year > 3000) {
    return res.status(400).json({ error: "연도를 올바르게 입력하세요." });
  }
  const rec = await q(
    "SELECT id FROM recipients WHERE id = ? AND user_id = ? LIMIT 1",
    [recipientId, uid]
  );
  if (!rec.length) return res.status(404).json({ error: "공급받는자를 찾을 수 없습니다." });

  if (!note) {
    await q(
      "DELETE FROM issue_matrix_notes WHERE user_id = ? AND year_no = ? AND recipient_id = ?",
      [uid, year, recipientId]
    );
  } else {
    await q(
      "INSERT INTO issue_matrix_notes (user_id, year_no, recipient_id, note) VALUES (?, ?, ?, ?) " +
        "ON DUPLICATE KEY UPDATE note = VALUES(note)",
      [uid, year, recipientId, note]
    );
  }
  res.json({ ok: true, note });
});

// homemunseo_id 재생성 (hometaxSubmit.js와 동일한 규칙)
function buildHomemunseoId(issueDate, recipientId, recordId) {
  const d = String(issueDate || "").replace(/\D/g, "").slice(0, 8);
  return (d + "-" + String(recipientId || 0).padStart(4, "0") + String(recordId).padStart(6, "0")).slice(0, 30);
}

// 전송 접수 후 국세청 실제 발급 결과를 백그라운드에서 폴링
function pollHometaxStatus(recordId, userId, homemunseoId, attempt) {
  if ((attempt || 1) > 20) return; // 최대 20분
  setTimeout(async function () {
    try {
      const result = await checkHometaxIssueStatus({ homemunseoId });
      if (!result.ok) {
        pollHometaxStatus(recordId, userId, homemunseoId, (attempt || 1) + 1);
        return;
      }
      const ds = result.declarestatus;
      if (ds === "08") {
        await q(
          "UPDATE issue_records SET transmit_status = 'issued', last_hometax_error = '' WHERE id = ? AND user_id = ?",
          [recordId, userId]
        );
        console.log("[pollHometaxStatus] 발급완료 recordId=" + recordId);
      } else if (ds === "09" || ds === "99") {
        const errMsg = (result.msg2 || result.msg || "발급실패").slice(0, 400);
        await q(
          "UPDATE issue_records SET transmit_status = 'issue_failed', last_hometax_error = ? WHERE id = ? AND user_id = ?",
          [errMsg, recordId, userId]
        );
        console.log("[pollHometaxStatus] 발급실패 recordId=" + recordId + " msg=" + errMsg);
      } else {
        // 아직 처리중 (10/03/04/05/06) → 재시도
        pollHometaxStatus(recordId, userId, homemunseoId, (attempt || 1) + 1);
      }
    } catch (e) {
      console.error("[pollHometaxStatus] 오류:", e);
      pollHometaxStatus(recordId, userId, homemunseoId, (attempt || 1) + 1);
    }
  }, 60000); // 60초 간격
}

router.delete("/api/issue-records/:id", needLogin, async function (req, res) {
  const id = Number(req.params.id);
  const uid = req.session.userId;
  if (!id) return res.status(400).json({ error: "잘못된 ID입니다." });
  await q("DELETE FROM issue_records WHERE id = ? AND user_id = ?", [id, uid]);
  res.json({ ok: true });
});

router.post("/api/issue-records/issue-and-transmit", needLogin, async function (req, res) {
  try {
    const yearMonth = String((req.body || {}).yearMonth || "").trim();
    const entries = (req.body || {}).entries || [];
    const uid = req.session.userId;
    const out = await upsertIssueRecordsFromEntries(uid, yearMonth, entries);
    if (out.error) return res.status(400).json({ error: out.error });
    if (!out.saved) return res.status(400).json({ error: "저장할 수 있는 발행 건이 없습니다." });

    const user = await getUserSafeById(uid);
    const supplier = (user && user.supplier) || {};
    const results = [];
    let anyMock = false;

    for (let i = 0; i < out.records.length; i++) {
      const iss = out.records[i];
      const rec = await getRecipientById(uid, iss.recipientId);
      let ht;
      try {
        let parsedItems = null;
        if (iss.itemJson) {
          try { parsedItems = JSON.parse(iss.itemJson); } catch (_) {}
        }
        ht = await submitIssueRecordToHometax({
          issueRecord: iss,
          recipient: rec || {},
          supplier,
          yearMonth,
          issueDate: iss.issueDate || "",
          items: parsedItems,
        });
      } catch (e) {
        ht = { ok: false, message: String((e && e.message) || e) };
      }
      if (ht.mock) anyMock = true;
      if (ht.ok) {
        await q(
          "UPDATE issue_records SET transmit_status = 'transmitted_practice', last_hometax_error = '' WHERE id = ? AND user_id = ?",
          [iss.id, uid]
        );
        if (!ht.mock) {
          pollHometaxStatus(iss.id, uid, buildHomemunseoId(iss.issueDate || "", iss.recipientId, iss.id), 1);
        }
      } else {
        await q(
          "UPDATE issue_records SET transmit_status = 'transmit_failed', last_hometax_error = ? WHERE id = ? AND user_id = ?",
          [String(ht.message || "").slice(0, 400), iss.id, uid]
        );
      }
      results.push({
        recordId: iss.id,
        recipientId: iss.recipientId,
        success: !!ht.ok,
        message: ht.message || (ht.ok ? "접수 완료" : "전송 실패"),
        mock: !!ht.mock,
      });
    }

    res.json({
      ok: true,
      saved: out.saved,
      recordIds: out.recordIds,
      results,
      hometaxMode: anyMock ? "mock" : "live",
    });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: String((e && e.message) || e) });
  }
});


// ── 어드민 API ──────────────────────────────────────────────────────────────

router.get("/api/admin/users", needAdmin, async function (req, res) {
  const rows = await q(
    "SELECT id, username, name, role, is_locked, login_fail_count, created_at, updated_at FROM users ORDER BY created_at ASC"
  );
  const users = rows.map(function (r) {
    return {
      id: Number(r.id),
      username: String(r.username),
      name: String(r.name || ""),
      role: String(r.role || "user"),
      isLocked: !!r.is_locked,
      loginFailCount: Number(r.login_fail_count) || 0,
      createdAt: new Date(r.created_at).toISOString(),
      updatedAt: r.updated_at ? new Date(r.updated_at).toISOString() : null,
    };
  });
  res.json({ users });
});

router.post("/api/admin/users", needAdmin, async function (req, res) {
  try {
    const b = req.body || {};
    const username = String(b.username || "").trim();
    const name     = String(b.name     || "").trim().slice(0, 100);
    const password = String(b.password || "");
    const confirm  = String(b.confirm  || "");
    const role     = b.role === "admin" ? "admin" : "user";

    if (!username) return res.status(400).json({ error: "아이디를 입력하세요." });
    if (username.length < 3 || username.length > 50) return res.status(400).json({ error: "아이디는 3~50자여야 합니다." });
    if (!/^[a-zA-Z0-9_\-]+$/.test(username)) return res.status(400).json({ error: "아이디는 영문·숫자·_·- 만 사용할 수 있습니다." });
    if (password.length < 4) return res.status(400).json({ error: "비밀번호는 4자 이상이어야 합니다." });
    if (password !== confirm) return res.status(400).json({ error: "비밀번호가 일치하지 않습니다." });

    const exist = await q("SELECT id FROM users WHERE username = ? LIMIT 1", [username]);
    if (exist.length) return res.status(400).json({ error: "이미 사용 중인 아이디입니다." });

    const hashed = await bcrypt.hash(password, BCRYPT_ROUNDS);
    const out = await q(
      "INSERT INTO users (username, password, role, name) VALUES (?, ?, ?, ?)",
      [username, hashed, role, name]
    );
    const userId = Number(out.insertId);
    const supplierOut = await q(
      "INSERT INTO suppliers (user_id, biz_no, corp_name, ceo_name, address, biz_type, biz_item, email, " +
        "contact_dept, contact_name, contact_phone, contact_extension, contact_email) " +
        "VALUES (?, '', '', '', '', '', '', '', '', '', '', '', '')",
      [userId]
    );
    await q("UPDATE users SET active_supplier_id = ? WHERE id = ?", [Number(supplierOut.insertId), userId]);
    res.json({ ok: true });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: "사용자 생성 중 오류" });
  }
});

router.put("/api/admin/users/:id", needAdmin, async function (req, res) {
  const id = Number(req.params.id);
  const rows = await q("SELECT id FROM users WHERE id = ? LIMIT 1", [id]);
  if (!rows.length) return res.status(404).json({ error: "사용자를 찾을 수 없습니다." });
  const b = req.body || {};
  const name = String(b.name || "").trim().slice(0, 100);
  await q("UPDATE users SET name = ? WHERE id = ?", [name, id]);
  if (b.newPassword) {
    const pw = String(b.newPassword);
    if (pw.length < 4) return res.status(400).json({ error: "비밀번호는 4자 이상이어야 합니다." });
    const hashed = await bcrypt.hash(pw, BCRYPT_ROUNDS);
    await q("UPDATE users SET password = ? WHERE id = ?", [hashed, id]);
  }
  if (b.role !== undefined && id !== req.session.userId) {
    const newRole = String(b.role);
    if (!["admin", "user", "pending"].includes(newRole)) {
      return res.status(400).json({ error: "유효하지 않은 권한입니다." });
    }
    await q("UPDATE users SET role = ? WHERE id = ?", [newRole, id]);
  }
  if (b.isLocked !== undefined && id !== req.session.userId) {
    const locked = b.isLocked ? 1 : 0;
    await q("UPDATE users SET is_locked = ?, login_fail_count = 0 WHERE id = ?", [locked, id]);
  }
  res.json({ ok: true });
});

router.put("/api/admin/users/:id/role", needAdmin, async function (req, res) {
  const id = Number(req.params.id);
  if (id === req.session.userId) {
    return res.status(400).json({ error: "자신의 권한은 변경할 수 없습니다." });
  }
  const role = String((req.body || {}).role || "user");
  if (role !== "admin" && role !== "user" && role !== "pending") {
    return res.status(400).json({ error: "유효하지 않은 권한입니다." });
  }
  const rows = await q("SELECT id FROM users WHERE id = ? LIMIT 1", [id]);
  if (!rows.length) return res.status(404).json({ error: "사용자를 찾을 수 없습니다." });
  await q("UPDATE users SET role = ? WHERE id = ?", [role, id]);
  res.json({ ok: true });
});

router.put("/api/admin/users/:id/password", needAdmin, async function (req, res) {
  const id = Number(req.params.id);
  const newPassword = String((req.body || {}).newPassword || "");
  if (newPassword.length < 4) {
    return res.status(400).json({ error: "비밀번호는 4자 이상이어야 합니다." });
  }
  const rows = await q("SELECT id FROM users WHERE id = ? LIMIT 1", [id]);
  if (!rows.length) return res.status(404).json({ error: "사용자를 찾을 수 없습니다." });
  const hashed = await bcrypt.hash(newPassword, BCRYPT_ROUNDS);
  await q("UPDATE users SET password = ? WHERE id = ?", [hashed, id]);
  res.json({ ok: true });
});

router.put("/api/admin/users/:id/lock", needAdmin, async function (req, res) {
  const id = Number(req.params.id);
  if (id === req.session.userId) {
    return res.status(400).json({ error: "자신의 계정은 잠글 수 없습니다." });
  }
  const locked = !!(req.body || {}).locked;
  const rows = await q("SELECT id FROM users WHERE id = ? LIMIT 1", [id]);
  if (!rows.length) return res.status(404).json({ error: "사용자를 찾을 수 없습니다." });
  await q("UPDATE users SET is_locked = ?, login_fail_count = 0 WHERE id = ?", [locked ? 1 : 0, id]);
  res.json({ ok: true, locked });
});

router.delete("/api/admin/users/:id", needAdmin, async function (req, res) {
  const id = Number(req.params.id);
  if (id === req.session.userId) {
    return res.status(400).json({ error: "자신의 계정은 삭제할 수 없습니다." });
  }
  const rows = await q("SELECT id FROM users WHERE id = ? LIMIT 1", [id]);
  if (!rows.length) return res.status(404).json({ error: "사용자를 찾을 수 없습니다." });
  await q("DELETE FROM users WHERE id = ?", [id]);
  res.json({ ok: true });
});

// ── 관리자: 공급자 관리 ────────────────────────────────────────────────────────

router.get("/api/admin/users/:id/suppliers", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const rows = await q(
    "SELECT id, biz_no, corp_name, ceo_name, address, biz_type, biz_item, email, phone, contact_dept, contact_name, contact_phone, contact_extension, contact_email, created_at FROM suppliers WHERE user_id = ? ORDER BY created_at ASC",
    [uid]
  );
  res.json({ suppliers: rows });
});

router.put("/api/admin/users/:id/suppliers/:supId", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const supId = Number(req.params.supId);
  const b = req.body || {};
  await q(
    "UPDATE suppliers SET biz_no=?, corp_name=?, ceo_name=?, address=?, biz_type=?, biz_item=?, email=?, phone=?, contact_dept=?, contact_name=?, contact_phone=?, contact_extension=?, contact_email=? WHERE id = ? AND user_id = ?",
    [
      String(b.bizNo || ""), String(b.corpName || ""), String(b.ceoName || ""),
      String(b.address || ""), String(b.bizType || ""), String(b.bizItem || ""),
      String(b.email || ""), String(b.phone || ""), String(b.contactDept || ""),
      String(b.contactName || ""), String(b.contactPhone || ""),
      String(b.contactExtension || ""), String(b.contactEmail || ""),
      supId, uid,
    ]
  );
  res.json({ ok: true });
});

router.delete("/api/admin/users/:id/suppliers/:supId", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const supId = Number(req.params.supId);
  await q("DELETE FROM suppliers WHERE id = ? AND user_id = ?", [supId, uid]);
  res.json({ ok: true });
});

// ── 관리자: 공급받는자 관리 ──────────────────────────────────────────────────────

router.get("/api/admin/users/:id/recipients", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const recs = await q(
    "SELECT id, kind, biz_subtype, display_name, biz_no, ceo_name, address, email, contact_name, contact_phone, contact_email, svc_safety, svc_tax, svc_billing, svc_monitoring, monitoring_type, payment_method, capacity, reception_capacity, generation_capacity, biz_type, biz_item, internal_memo, created_at FROM recipients WHERE user_id = ? ORDER BY created_at ASC",
    [uid]
  );
  if (!recs.length) return res.json({ recipients: [] });
  const ids = recs.map(function (r) { return r.id; });
  const items = await q(
    "SELECT id, recipient_id, plant_name, fixed_item_name, monthly_supply, monthly_tax, note FROM recipient_items WHERE recipient_id IN (" + ids.map(function () { return "?"; }).join(",") + ") ORDER BY id ASC",
    ids
  );
  const recMap = {};
  recs.forEach(function (r) { r.items = []; recMap[r.id] = r; });
  items.forEach(function (it) { if (recMap[it.recipient_id]) recMap[it.recipient_id].items.push(it); });
  res.json({ recipients: recs });
});

router.put("/api/admin/users/:id/recipients/:recId", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const recId = Number(req.params.recId);
  const b = req.body || {};
  const kind = String(b.kind || "individual");
  const normalizedBizNo = formatRecipientNoByKind(kind, b.bizNo);
  await q(
    "UPDATE recipients SET kind=?, biz_subtype=?, display_name=?, biz_no=?, ceo_name=?, address=?, email=?, reception_capacity=?, generation_capacity=?, biz_type=?, biz_item=?, internal_memo=?, contact_name=?, contact_phone=?, contact_email=?, svc_safety=?, svc_tax=?, svc_billing=?, svc_monitoring=?, monitoring_type=?, payment_method=? WHERE id = ? AND user_id = ?",
    [
      kind,
      b.bizSubtype == null ? null : String(b.bizSubtype),
      String(b.displayName || ""),
      normalizedBizNo,
      String(b.ceoName || ""),
      String(b.address || ""),
      String(b.email || ""),
      Number(b.receptionCapacity) || 0,
      Number(b.generationCapacity) || 0,
      String(b.bizType || ""),
      String(b.bizItem || ""),
      String(b.internalMemo || ""),
      String(b.contactName || ""),
      String(b.contactPhone || ""),
      String(b.contactEmail || ""),
      b.svcSafety     ? 1 : 0,
      b.svcTax        ? 1 : 0,
      b.svcBilling    ? 1 : 0,
      b.svcMonitoring ? 1 : 0,
      String(b.monitoringType || ""),
      String(b.paymentMethod  || ""),
      recId, uid,
    ]
  );
  res.json({ ok: true });
});

router.delete("/api/admin/users/:id/recipients/:recId", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const recId = Number(req.params.recId);
  await q("DELETE FROM recipients WHERE id = ? AND user_id = ?", [recId, uid]);
  res.json({ ok: true });
});

router.put("/api/admin/users/:id/recipients/:recId/items/:itemId", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const recId = Number(req.params.recId);
  const itemId = Number(req.params.itemId);
  const rec = await q("SELECT id FROM recipients WHERE id = ? AND user_id = ? LIMIT 1", [recId, uid]);
  if (!rec.length) return res.status(404).json({ error: "없음" });
  const b = req.body || {};
  const supply = Number(b.monthlySupply) || 0;
  await q(
    "UPDATE recipient_items SET plant_name=?, fixed_item_name=?, monthly_supply=?, monthly_tax=?, note=? WHERE id = ? AND recipient_id = ?",
    [String(b.plantName || ""), String(b.fixedItemName || ""), supply, calcFixedTax(supply), String(b.note || ""), itemId, recId]
  );
  res.json({ ok: true });
});

router.delete("/api/admin/users/:id/recipients/:recId/items/:itemId", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const recId = Number(req.params.recId);
  const itemId = Number(req.params.itemId);
  const rec = await q("SELECT id FROM recipients WHERE id = ? AND user_id = ? LIMIT 1", [recId, uid]);
  if (!rec.length) return res.status(404).json({ error: "없음" });
  await q("DELETE FROM recipient_items WHERE id = ? AND recipient_id = ?", [itemId, recId]);
  res.json({ ok: true });
});

router.post("/api/admin/users/:id/recipients", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const b = req.body || {};
  const kind = String(b.kind || "individual");
  const normalizedBizNo = formatRecipientNoByKind(kind, b.bizNo);
  const out = await q(
    "INSERT INTO recipients (user_id, kind, biz_subtype, display_name, biz_no, ceo_name, address, email, capacity, reception_capacity, generation_capacity, biz_type, biz_item, internal_memo, contact_name, contact_phone, contact_email, svc_safety, svc_tax, svc_billing, svc_monitoring, monitoring_type, payment_method) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
    [uid, kind, b.bizSubtype == null ? null : String(b.bizSubtype), String(b.displayName || ""), normalizedBizNo, String(b.ceoName || ""), String(b.address || ""), String(b.email || ""), Number(b.capacity) || 0, Number(b.receptionCapacity) || 0, Number(b.generationCapacity) || 0, String(b.bizType || ""), String(b.bizItem || ""), String(b.internalMemo || ""), String(b.contactName || ""), String(b.contactPhone || ""), String(b.contactEmail || ""), b.svcSafety ? 1 : 0, b.svcTax ? 1 : 0, b.svcBilling ? 1 : 0, b.svcMonitoring ? 1 : 0, String(b.monitoringType || ""), String(b.paymentMethod || "")]
  );
  const rec = await getRecipientById(uid, Number(out.insertId));
  res.json({ recipient: rec });
});

router.post("/api/admin/users/:id/recipients/:recId/items", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const recId = Number(req.params.recId);
  const check = await q("SELECT id FROM recipients WHERE id = ? AND user_id = ? LIMIT 1", [recId, uid]);
  if (!check.length) return res.status(404).json({ error: "없음" });
  const b = req.body || {};
  const supply = Number(b.monthlySupply) || 0;
  await q(
    "INSERT INTO recipient_items (recipient_id, plant_name, fixed_item_name, monthly_supply, monthly_tax, note) VALUES (?, ?, ?, ?, ?, ?)",
    [recId, String(b.plantName != null ? b.plantName : ""), String(b.fixedItemName != null ? b.fixedItemName : ""), supply, calcFixedTax(supply), String(b.note || "")]
  );
  const next = await getRecipientById(uid, recId);
  res.json({ recipient: next });
});

router.post("/api/admin/users/:id/suppliers", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const s = req.body || {};
  const out = await q(
    "INSERT INTO suppliers (user_id, biz_no, corp_name, ceo_name, address, biz_type, biz_item, email, contact_dept, contact_name, contact_phone, contact_extension, contact_email) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
    [uid, formatBizNoForBusiness(s.bizNo), String(s.corpName || ""), String(s.ceoName || ""), String(s.address || ""), String(s.bizType || ""), String(s.bizItem || ""), String(s.email || ""), String(s.contactDept || ""), String(s.contactName || ""), String(s.contactPhone || ""), String(s.contactExtension || ""), String(s.contactEmail || "")]
  );
  const supplierRows = await q("SELECT * FROM suppliers WHERE id = ? LIMIT 1", [out.insertId]);
  const supplier = mapSupplierRow(supplierRows[0]);
  res.json({ supplier });
});

// ── 관리자: 발행기록 조회 ─────────────────────────────────────────────────────

router.get("/api/admin/users/:id/issue-records", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const qYm = String(req.query.yearMonth || "").trim();
  const cond = ["user_id = ?"];
  const params = [uid];
  if (qYm) {
    cond.push("year_month_key = ?");
    params.push(qYm);
  }
  const rows = await q(
    "SELECT * FROM issue_records WHERE " + cond.join(" AND ") + " ORDER BY created_at DESC LIMIT 500",
    params
  );
  res.json({ records: rows.map(mapIssueRecordRow) });
});

router.get("/api/admin/users/:id/issue-records/year-matrix", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const nowYear = new Date().getFullYear();
  const qYear = Number(req.query.year);
  const year = Number.isFinite(qYear) && qYear >= 2000 && qYear <= 3000 ? qYear : nowYear;
  const yearPrefix = String(year) + "-";

  const recipientRows = await q(
    "SELECT r.id, r.display_name, COALESCE(SUM(i.monthly_supply), 0) AS supply, " +
    "COALESCE(SUM(i.monthly_supply + i.monthly_tax), 0) AS total " +
    "FROM recipients r LEFT JOIN recipient_items i ON i.recipient_id = r.id " +
    "WHERE r.user_id = ? GROUP BY r.id, r.display_name ORDER BY r.display_name ASC, r.id ASC",
    [uid]
  );
  const noteRows = await q(
    "SELECT recipient_id, note FROM issue_matrix_notes WHERE user_id = ? AND year_no = ?",
    [uid, year]
  );
  const noteMap = {};
  for (let i = 0; i < noteRows.length; i++) {
    noteMap[Number(noteRows[i].recipient_id)] = String(noteRows[i].note || "");
  }
  const recMap = {};
  for (let i = 0; i < recipientRows.length; i++) {
    const r = recipientRows[i];
    recMap[Number(r.id)] = {
      recipientId: Number(r.id),
      recipientName: String(r.display_name || ""),
      supply: Number(r.supply) || 0,
      total: Number(r.total) || 0,
      months: Array(12).fill("none"),
      monthRecords: Array(12).fill(null),
      note: noteMap[Number(r.id)] || "",
    };
  }
  const recordRows = await q(
    "SELECT * FROM issue_records WHERE user_id = ? AND year_month_key LIKE ? ORDER BY created_at ASC",
    [uid, yearPrefix + "%"]
  );
  for (let i = 0; i < recordRows.length; i++) {
    const row = mapIssueRecordRow(recordRows[i]);
    const target = recMap[row.recipientId];
    if (!target) continue;
    const m = Number(String(row.yearMonth).slice(5, 7));
    if (!Number.isFinite(m) || m < 1 || m > 12) continue;
    target.months[m - 1] = row.transmitStatus;
    target.monthRecords[m - 1] = {
      id: row.id,
      yearMonth: row.yearMonth,
      createdAt: row.createdAt,
      totalSupply: row.totalSupply,
      totalTax: row.totalTax,
      transmitStatus: row.transmitStatus,
      recipientName: row.recipientName,
    };
  }
  res.json({ year, rows: Object.keys(recMap).map(function (k) { return recMap[k]; }) });
});

router.put("/api/admin/users/:id/issue-records/year-matrix/note", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const b = req.body || {};
  const year = Number(b.year);
  const recipientId = Number(b.recipientId);
  const note = String(b.note || "").trim().slice(0, 500);
  if (!Number.isFinite(year) || year < 2000 || year > 3000) {
    return res.status(400).json({ error: "연도를 올바르게 입력하세요." });
  }
  const rec = await q("SELECT id FROM recipients WHERE id = ? AND user_id = ? LIMIT 1", [recipientId, uid]);
  if (!rec.length) return res.status(404).json({ error: "공급받는자를 찾을 수 없습니다." });
  if (!note) {
    await q("DELETE FROM issue_matrix_notes WHERE user_id = ? AND year_no = ? AND recipient_id = ?", [uid, year, recipientId]);
  } else {
    await q(
      "INSERT INTO issue_matrix_notes (user_id, year_no, recipient_id, note) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE note = VALUES(note)",
      [uid, year, recipientId, note]
    );
  }
  res.json({ ok: true, note });
});

router.get("/api/admin/users/:id/dashboard/stats", needAdmin, async function (req, res) {
  const uid = Number(req.params.id);
  const issueRows = await q(
    "SELECT * FROM issue_records WHERE user_id = ? ORDER BY created_at DESC LIMIT 2000",
    [uid]
  );
  const all = issueRows.map(mapIssueRecordRow);
  const thisYm = kstYearMonthDay().yearMonth;
  const lastYm = prevYearMonth(thisYm);
  const thisY = thisYm.slice(0, 4);
  const lastY = String(Number(thisY) - 1);

  function byYm(ym) { return all.filter(function (r) { return r.yearMonth === ym; }); }
  function byYear(y) { return all.filter(function (r) { return r.yearMonth.startsWith(y + "-"); }); }

  const recipients = await getRecipientsByUserId(uid);
  const eligible = recipients.filter(function (r) { return r.items.length > 0; });
  const issuedThisMonth = new Set(byYm(thisYm).map(function (r) { return r.recipientId; }));
  const pendingIssue = eligible.filter(function (r) { return !issuedThisMonth.has(r.id); }).length;

  const recent = all.slice().sort(function (a, b) { return new Date(b.createdAt) - new Date(a.createdAt); }).slice(0, 30);
  const tmSum = sumIssueRecords(byYm(thisYm));
  tmSum.pendingIssueCount = pendingIssue;
  const tmTransmitted = byYm(thisYm).filter(function (r) { return r.transmitStatus === "transmitted_practice"; });
  const tmTransmittedSum = sumIssueRecords(tmTransmitted);

  res.json({
    kstYearMonth: thisYm,
    periods: {
      thisMonth: Object.assign({ yearMonth: thisYm, label: "이번 달" }, tmSum),
      lastMonth: Object.assign({ yearMonth: lastYm, label: "지난 달" }, sumIssueRecords(byYm(lastYm))),
      thisYear: Object.assign({ year: thisY, label: "올해" }, sumIssueRecords(byYear(thisY))),
      lastYear: Object.assign({ year: lastY, label: "작년" }, sumIssueRecords(byYear(lastY))),
    },
    pendingIssueThisMonth: pendingIssue,
    eligibleRecipientCount: eligible.length,
    transmittedThisMonth: {
      count: tmTransmittedSum.issueCount,
      supply: tmTransmittedSum.supply,
      tax: tmTransmittedSum.tax,
      total: tmTransmittedSum.total,
    },
    recent,
  });
});

// ─────────────────────────────────────────────────────────────────────────────

router.use(function (req, res) {
  if (req.path.startsWith("/api")) {
    return res.status(404).json({ error: "API 없음" });
  }
  res.status(404).type("text/plain").send("페이지를 찾을 수 없습니다.");
});

async function bootstrapAndListen() {
  if (!DB_HOST || !DB_USER || !DB_NAME) {
    console.error(
      "MariaDB 환경변수가 필요합니다: MARIADB_HOST, MARIADB_USER, MARIADB_DATABASE"
    );
    process.exit(1);
  }
  dbPool = mysql.createPool({
    host: DB_HOST,
    port: DB_PORT,
    user: DB_USER,
    password: DB_PASSWORD,
    database: DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
    timezone: "+09:00",
    charset: "utf8mb4",
  });
  await ensureRecipientCertDir();
  await ensureSupplierCertDir();
  if (process.env.DB_RESET === "true") {
    await dropAllTables();
  }
  await ensureSchema();
  await ensureDemoUser();

  app.listen(PORT, function () {
    console.log("서버 주소: http://localhost:" + PORT);
    console.log("설정 도메인: " + SITE_DOMAIN);
    console.log("DB 연결: " + DB_HOST + ":" + DB_PORT + " / " + DB_NAME);
  });
}

app.use(BASE_PATH, router);

bootstrapAndListen().catch(function (e) {
  console.error("[부팅 실패]", e);
  process.exit(1);
});
