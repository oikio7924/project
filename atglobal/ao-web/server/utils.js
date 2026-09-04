'use strict';

const crypto = require('crypto');
const bcryptjs = require('bcryptjs');

function publicUser(user) {
  if (!user) return null;
  const { password, ...safe } = user;
  return safe;
}

function toNumber(value) {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : 0;
}

function requireFields(body, fields) {
  return fields.filter((field) => body[field] === undefined || body[field] === null || body[field] === '');
}

// 총판 직원 계정은 세션 id가 회사(루트 계정) id와 다르므로, 발주/재고/판매/단가 등
// "총판 회사" 단위로 스코프해야 하는 조회·기록에는 반드시 이 함수로 구한 회사 id를 써야 한다.
function companyId(user) {
  return user.role === 'distributor' ? (user.distributor_id || user.id) : user.id;
}

// actor가 target 회원을 관리(승인/거부/수정/삭제/담당자 지정 등)할 수 있는지 판정.
// 제조사는 전부 관리 가능, 총판은 자기 회사 소속 총판 직원만 관리 가능.
function canManageTarget(actor, target) {
  if (actor.role === 'admin') return true;
  if (actor.role === 'distributor') {
    const root = companyId(actor);
    return target.role === 'distributor' && (target.id === root || target.distributor_id === root);
  }
  return false;
}

// [회원 삭제]/[모든 데이터 삭제-총판] 공통 익명화: 개인정보보호법상 개인정보가 아닌 상호명(company_name)만
// 남기고 로그인 정보를 포함한 나머지 개인정보는 전부 지운다. 발주/출고/판매 등 이력 테이블은 건드리지 않는다.
async function anonymizeUser(pool, id) {
  const hashedPw = await bcryptjs.hash(crypto.randomUUID(), 10);
  const { rows } = await pool.query(
    `UPDATE users SET
       username = $2,
       password = $3,
       status = 'deleted',
       name = '',
       phone = NULL,
       company_phone = NULL,
       fax = NULL,
       business_number = NULL,
       ceo_name = NULL,
       open_date = NULL,
       business_type = NULL,
       business_item = NULL,
       address = NULL,
       address_detail = NULL,
       distributor_id = NULL,
       manager_name = NULL,
       manager_department = NULL,
       manager_position = NULL,
       manager_phone = NULL,
       manager_email = NULL,
       manager_memo = NULL,
       updated_at = NOW()
     WHERE id = $1
     RETURNING *`,
    [id, `deleted_${id}`, hashedPw]
  );
  return rows[0];
}

// 총판 관리자(회사 자체) 삭제 시 재배정 게이트에 쓰는 소속 대리점 조회.
// 소속 대리점이 있으면 판매가·재고 정보를 잃어 발주가 막히므로 먼저 다른 총판으로 옮겨야 한다.
async function getActiveDependentDealers(pool, distributorId) {
  const { rows } = await pool.query(
    `SELECT id, username, name, company_name FROM users
     WHERE role = 'dealer' AND distributor_id = $1 AND status != 'deleted'`,
    [distributorId]
  );
  return rows;
}

// 총판 관리자(회사 자체)가 삭제되면 그 회사와의 거래 관계 자체가 끝난 것이므로,
// 소속 직원 계정도 더 이상 로그인해 활동할 근거가 없어 함께 익명화한다.
async function anonymizeDistributorStaff(pool, distributorId) {
  const { rows } = await pool.query(
    `SELECT id FROM users WHERE role = 'distributor' AND distributor_id = $1 AND status != 'deleted'`,
    [distributorId]
  );
  for (const row of rows) {
    await anonymizeUser(pool, row.id);
  }
}

module.exports = {
  publicUser, toNumber, requireFields, companyId, canManageTarget, anonymizeUser,
  getActiveDependentDealers, anonymizeDistributorStaff
};
