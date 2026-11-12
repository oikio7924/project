// rtu-web 로그인 계정 관리
//   node scripts/create-user.js <아이디> <이름> [--admin]   새 계정 (기본 비밀번호 = .env 의 DEFAULT_PASSWORD)
//   node scripts/create-user.js --reset <아이디>            비밀번호를 기본값으로 + 잠금 해제
// 기본 비밀번호는 로그인 후 "비밀번호 변경"에서 바꾼다.
//   node scripts/create-user.js --list                      계정 목록
require('dotenv').config({ path: require('path').join(__dirname, '..', '.env'), quiet: true });
const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');

// 새 계정·재설정 때 쓰는 기본 비밀번호 (2026-11-02 사용자 요청) — 공개 저장소에 값을 남기지 않도록 .env 에서 읽음
const DEFAULT_PASSWORD = process.env.DEFAULT_PASSWORD;
if (!DEFAULT_PASSWORD) {
  console.error('.env 에 DEFAULT_PASSWORD=... 를 넣어 주세요 (새 계정·재설정 기본 비밀번호)');
  process.exit(1);
}

(async () => {
  const args = process.argv.slice(2);
  const db = await mysql.createConnection({
    host: process.env.MARIADB_HOST, port: Number(process.env.MARIADB_PORT || 3306),
    user: process.env.MARIADB_USER, password: process.env.MARIADB_PASSWORD, database: process.env.MARIADB_DATABASE,
  });
  try {
    if (args[0] === '--list') {
      const [rows] = await db.query('SELECT username, name, is_admin, is_active, is_locked, last_login FROM rtm_user ORDER BY user_id');
      console.table(rows);
    } else if (args[0] === '--reset' && args[1]) {
      const pw = DEFAULT_PASSWORD;
      const [r] = await db.execute('UPDATE rtm_user SET password = ?, login_fail_count = 0, is_locked = 0 WHERE username = ?',
        [await bcrypt.hash(pw, 10), args[1]]);
      if (!r.affectedRows) throw new Error(`계정 ${args[1]} 없음`);
      console.log(`비밀번호 재설정: ${args[1]} / 기본 비밀번호: ${pw}  (로그인 후 바꾸세요)`);
    } else if (args[0] && args[1] && !args[0].startsWith('--')) {
      const pw = DEFAULT_PASSWORD;
      await db.execute('INSERT INTO rtm_user (username, password, name, is_admin) VALUES (?, ?, ?, ?)',
        [args[0], await bcrypt.hash(pw, 10), args[1], args.includes('--admin') ? 1 : 0]);
      console.log(`계정 생성: ${args[0]} (${args[1]}) / 기본 비밀번호: ${pw}  (로그인 후 바꾸세요)`);
    } else {
      console.log('사용법: node scripts/create-user.js <아이디> <이름> [--admin] | --reset <아이디> | --list');
      process.exitCode = 1;
    }
  } catch (e) {
    console.error('실패:', e.message);
    process.exitCode = 1;
  } finally {
    await db.end();
  }
})();
