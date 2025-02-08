const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

// Define the item schema
const itemSchema = new Schema({
  menuId: { type: String, required: true },
  sellerUID: { type: String, required: true },
  title: { type: String, required: true },
  shortInfo: { type: String, required: true },
  longDescription: { type: String, required: true },
  price: { type: Number, required: true },
  thumbnailUrl: { type: String},
  status: { type: String, required: true }
});

// Create the model
const ItemModel = db.model('item', itemSchema);

module.exports = ItemModel;