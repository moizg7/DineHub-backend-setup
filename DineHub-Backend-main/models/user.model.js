const mongoose = require('mongoose');
const bcrypt = require("bcrypt");
const db = require('../config/db');

const { Schema } = mongoose;

// Define the address schema
const addressSchema = new Schema({
  RoomNo: { type: String, required: true },
  Hostel: { type: String, required: true }
});

// Define the cart item schema
const cartItemSchema = new Schema({
  itemId: { type: String, required: true },
  quantity: { type: Number, required: true, min: 1, max: 99 }
});

// Define the user schema
const userSchema = new Schema({
  name: { type: String, required: true }, // Required name field
  email: { type: String, lowercase: true, required: true, unique: true }, // Unique and lowercase email
  password: { type: String, required: true }, // Required password
  phone: { 
    type: String, 
    required: true, 
    validate: {
      validator: function(v) {
        return /^\d+$/.test(v); // Regular expression to validate only numbers
      },
      message: props => `${props.value} is not a valid phone number!`
    }
  }, // Required phone number
  cart: { type: [cartItemSchema], default: [], validate: [cartLimit, '{PATH} exceeds the limit of 99'] }, // Cart with a limit of 99 items
  addresses: { type: [addressSchema], default: [], validate: [addressLimit, '{PATH} exceeds the limit of 5'] } // Addresses with a limit of 5
});

// Custom validator for cart limit
function cartLimit(val) {
  return val.length <= 99;
}

// Custom validator for address limit
function addressLimit(val) {
  return val.length <= 5;
}

// Middleware: Encrypting user password before saving
userSchema.pre("save", async function () {
  const user = this; // Use 'const' instead of 'var'
  if (!user.isModified("password")) {
    return; // Only hash if the password is modified
  }
  try {
    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(user.password, salt);
    user.password = hash; // Save the hashed password
  } catch (err) {
    throw err; // Throw error for handling in the controller
  }
});

// Compare password method for login
userSchema.methods.comparePassword = async function (inputPassword) {
  return await bcrypt.compare(inputPassword, this.password); // Compare input password with hashed password
};

// Create the model
const UserModel = db.model('user', userSchema);

module.exports = UserModel;