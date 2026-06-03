'use strict';

require('dotenv').config();

const path = require('path');
const express = require('express');
const session = require('express-session');
const cors = require('cors');
const pgSession = require('connect-pg-simple')(session);
const pool = require('./db');
const initDb = require('./lib/initDb');

const app = express();
const port = Number(process.env.PORT || 4000);
const isProduction = process.env.NODE_ENV === 'production';

app.use(cors({
  origin: isProduction ? process.env.SITE_DOMAIN : ['http://localhost:5173', 'http://127.0.0.1:5173'],
  credentials: true
}));
app.use(express.json());
app.use(session({
  store: new pgSession({
    pool,
    tableName: 'user_sessions',
    createTableIfMissing: true
  }),
  name: 'atglobal.sid',
  secret: process.env.SESSION_SECRET || 'local_atglobal_secret',
  resave: false,
  saveUninitialized: false,
  cookie: {
    httpOnly: true,
    sameSite: isProduction ? 'lax' : 'lax',
    secure: false,
    maxAge: 1000 * 60 * 60 * 8
  }
}));

app.get('/api/health', (_req, res) => res.json({ ok: true, name: 'AT Global API' }));
app.use('/api/auth', require('./routes/auth'));
app.use('/api/users', require('./routes/users'));
app.use('/api/products', require('./routes/products'));
app.use('/api/inventory', require('./routes/inventory'));
app.use('/api/orders', require('./routes/orders'));
app.use('/api/shipments', require('./routes/shipments'));
app.use('/api/sales', require('./routes/sales'));
app.use('/api/dashboard', require('./routes/dashboard'));

if (isProduction) {
  const dist = path.join(__dirname, '../client/dist');
  app.use(express.static(dist));
  app.get('*', (_req, res) => res.sendFile(path.join(dist, 'index.html')));
}

app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(500).json({ message: '서버 오류가 발생했습니다.' });
});

initDb()
  .then(() => app.listen(port, () => console.log(`AT Global API listening on ${port}`)))
  .catch((error) => {
    console.error('DB initialization failed:', error.message);
    process.exit(1);
  });
