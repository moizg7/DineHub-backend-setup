const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

// Define the order schema
const orderSchema = new Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'user', required: true },
  cart: { type: Array, required: true },
  address: { type: Object, required: true },
  paymentType: { type: String, required: true },
  orderStatus: { type: String, default: 'pending' },
  totalAmount: { type: Number, required: true },
  approximateTime: { type: String, required: true },
  createdAt: { type: Date, default: Date.now } // Add createdAt field
});

// Create the model
const OrderModel = db.model('order', orderSchema);

module.exports = OrderModel;