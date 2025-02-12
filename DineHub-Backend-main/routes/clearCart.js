// routes/userRoutes.js
const express = require('express');
const User = require('../models/user.model');

const router = express.Router();

router.post('/clearCart', async (req, res) => {
  const { _id, userCart } = req.body;
  try {
    await User.findByIdAndUpdate(_id, { userCart });
    res.status(200).json({ message: 'Cart cleared successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;