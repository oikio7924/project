'use strict';

const fs = require('fs');
const path = require('path');
const bcryptjs = require('bcryptjs');
const pool = require('../db');

async function initDb() {
  const isReset = process.env.DB_RESET === 'true';

  if (isReset) {
    const reset = fs.readFileSync(path.join(__dirname, '../db/schema_reset.sql'), 'utf8');
    await pool.query(reset);
  }

  // schema.sql은 CREATE TABLE/INDEX IF NOT EXISTS로만 구성되어 있어
  // DB_RESET 값과 무관하게 항상 실행해도 기존 데이터를 보존한 채 없는 테이블만 새로 생성됨
  const schema = fs.readFileSync(path.join(__dirname, '../db/schema.sql'), 'utf8');
  await pool.query(schema);

  const adminUsername = process.env.ADMIN_USERNAME || 'admin';
  const adminPassword = process.env.ADMIN_PASSWORD || 'Admin1234!';
  const hashedPw = await bcryptjs.hash(adminPassword, 10);

  await pool.query(
    `INSERT INTO users (username, password, name, company_name, role, status, is_owner)
     VALUES ($1, $2, $3, $4, 'admin', 'active', true)
     ON CONFLICT (username) DO NOTHING`,
    [adminUsername, hashedPw, '관리자', 'AT Global']
  );

  if (isReset) {
    const seed = fs.readFileSync(path.join(__dirname, '../db/seed.sql'), 'utf8');
    await pool.query(seed);
  }
}

module.exports = initDb;
