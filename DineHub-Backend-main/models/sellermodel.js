// models/sellerModel.js
const mongoose = require('mongoose');
const bcrypt = require("bcrypt");
const db = require('../config/db');

const { Schema } = mongoose;

// Define the seller schema
const sellerSchema = new Schema({
  name: { type: String, required: true }, // Required name field
  email: { type: String, lowercase: true, required: true, unique: true }, // Unique and lowercase email
  password: { type: String, required: true }, // Required password
  phone: { type: String, required: true }, // Required phone number
  address: { type: String, required: true }, // Required address
  photoUrl: { type: String }, // Path to the profile image
});

// Middleware: Encrypting seller password before saving
sellerSchema.pre("save", async function () {
  const seller = this; // Use 'const' instead of 'var'
  if (!seller.isModified("password")) {
    return; // Only hash if the password is modified
  }
  try {
    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(seller.password, salt);
    seller.password = hash; // Save the hashed password
  } catch (err) {
    throw err; // Throw error for handling in the controller
  }
});

// Compare password method for login
sellerSchema.methods.comparePassword = async function (inputPassword) {
  return await bcrypt.compare(inputPassword, this.password); // Compare input password with hashed password
};

// Create the model
const SellerModel = db.model('seller', sellerSchema);

module.exports = SellerModel;