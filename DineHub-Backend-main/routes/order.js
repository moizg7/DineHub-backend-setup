const express = require('express');
const auth = require('../middleware/auth');
const Order = require('../models/Order');

const router = express.Router();

// Place a new order
router.post('/', auth, async (req, res) => {
  const { items, totalPrice } = req.body;
  try {
    const newOrder = new Order({
      user: req.user.id,
      items,
      totalPrice,
    });
    const order = await newOrder.save();
    res.json(order);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }
});

// Get all orders for a user
router.get('/', auth, async (req, res) => {
  try {
    const orders = await Order.find({ user: req.user.id }).sort({ date: -1 });
    res.json(orders);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server error');
  }const express = require('express');
  const auth = require('../middleware/auth');
  const Order = require('../models/Order');
  
  const router = express.Router();
  
  // Place a new order
  router.post('/', auth, async (req, res) => {
    const { items, totalPrice } = req.body;
    try {
      const newOrder = new Order({
        user: req.user.id,
        items,
        totalPrice,
      });
      const order = await newOrder.save();
      res.json(order);
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Server error');
    }
  });
  
  // Get all orders for a user
  router.get('/', auth, async (req, res) => {
    try {
      const orders = await Order.find({ user: req.user.id }).sort({ createdAt: -1 });
      res.json(orders);
    } catch (err) {
      console.error(err.message);
      res.status(500).send('Server error');
    }
  });
  
  module.exports = router;
  
});

module.exports = router;
