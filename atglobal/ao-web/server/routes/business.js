'use strict';

const express = require('express');
const { checkStatus, validateBusiness } = require('../lib/businessApi');

const router = express.Router();

router.post('/status', async (req, res) => {
  try {
    const result = await checkStatus(req.body.business_number);
    if (!result.ok) return res.status(400).json({ message: result.message });
    res.json(result);
  } catch (error) {
    res.status(502).json({ message: error.message });
  }
});

router.post('/validate', async (req, res) => {
  try {
    const result = await validateBusiness(req.body);
    if (!result.ok) return res.status(400).json({ message: result.message });
    res.json(result);
  } catch (error) {
    res.status(502).json({ message: error.message });
  }
});

module.exports = router;
