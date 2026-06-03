'use strict';

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

module.exports = { publicUser, toNumber, requireFields };
