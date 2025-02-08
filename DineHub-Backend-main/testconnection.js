require('dotenv').config(); // Ensure this is at the top of your script

const mongoose = require('mongoose');

const testConnection = async () => {
  console.log('MongoDB URI:', process.env.MONGO_URI); // Check the URI
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('MongoDB Connected Successfully');
  } catch (err) {
    console.error('MongoDB Connection Error:', err.message);
  }
};

testConnection();
