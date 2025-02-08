const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

// Define the menu schema
const menuSchema = new Schema({
  sellerUID: { type: String, required: true }, // Required seller UID
  menuTitle: { type: String, required: true }, // Required menu title
  menuInfo: { type: String, required: true }, // Required menu info
  thumbnailUrl: { type: String }, // Path to the thumbnail image
  status: { type: String, required: true } // Required status
});

// Create the model
const MenuModel = db.model('menu', menuSchema);

module.exports = MenuModel;