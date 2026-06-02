/**
 * s_user_info / dy_power_plant 을 직접 사용하므로 컬럼 마이그레이션 불필요
 */
async function migrateAdminColumns() {
  // no-op
}

function roleLabel(role) {
  if (role === "admin") return "전권한";
  if (role === "site_admin") return "홈페이지 관리자";
  return "일반유저";
}

module.exports = { migrateAdminColumns, roleLabel };
