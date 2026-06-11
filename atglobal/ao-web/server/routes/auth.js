'use strict';

const express = require('express');
const pool = require('../db');
const { publicUser, requireFields } = require('../utils');

const router = express.Router();

router.get('/me', async (req, res) => {
  if (!req.session.user) return res.json({ user: null });
  const { rows } = await pool.query('SELECT * FROM users WHERE id = $1', [req.session.user.id]);
  const user = publicUser(rows[0]);
  req.session.user = user;
  res.json({ user });
});

router.post('/login', async (req, res) => {
  const missing = requireFields(req.body, ['username', 'password']);
  if (missing.length) return res.status(400).json({ message: '아이디와 비밀번호를 입력해주세요.' });

  const { rows } = await pool.query('SELECT * FROM users WHERE username = $1', [req.body.username]);
  const user = rows[0];
  if (!user || user.password !== req.body.password) {
    return res.status(401).json({ message: '아이디 또는 비밀번호가 올바르지 않습니다.' });
  }
  if (user.status !== 'active') {
    return res.status(403).json({ message: '관리자 승인 후 로그인할 수 있습니다.' });
  }

  req.session.user = publicUser(user);
  res.json({ user: req.session.user });
});

router.post('/logout', (req, res) => {
  req.session.destroy(() => res.json({ ok: true }));
});

router.post('/register', async (req, res) => {
  const missing = requireFields(req.body, ['username', 'password', 'name', 'phone', 'company_name', 'role']);
  if (missing.length) return res.status(400).json({ message: '필수 항목을 입력해주세요.' });
  if (!['distributor', 'dealer'].includes(req.body.role)) {
    return res.status(400).json({ message: '총판 또는 대리점으로만 가입 신청할 수 있습니다.' });
  }

  try {
    const { rows } = await pool.query(
      `INSERT INTO users (username, password, name, phone, company_name, address, role, status)
       VALUES ($1, $2, $3, $4, $5, $6, $7, 'pending')
       RETURNING id, username, name, phone, company_name, address, role, status, created_at`,
      [req.body.username, req.body.password, req.body.name, req.body.phone, req.body.company_name, req.body.address || null, req.body.role]
    );
    res.status(201).json({ user: rows[0] });
  } catch (error) {
    if (error.code === '23505') return res.status(409).json({ message: '이미 사용 중인 아이디입니다.' });
    throw error;
  }
});

module.exports = router;
