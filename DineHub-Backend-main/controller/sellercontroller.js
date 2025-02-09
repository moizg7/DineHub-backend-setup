// controllers/sellerController.js
const SellerService = require('../services/sellerService');

exports.register = async (req, res, next) => {
  try {
    const { name, email, password, phone, address } = req.body;
    const photoUrl = req.file ? `${req.protocol}://${req.get('host')}/uploads/sellers/${req.file.filename}` : undefined; // Get the full URL if a file was uploaded

    // Register the seller with name, email, password, phone, address, and photoUrl
    const successRes = await SellerService.registerSeller(name, email, password, phone, address, photoUrl);

    res.json({ status: true, success: 'Seller registered successfully', seller: successRes.seller });
  } catch (error) {
    res.status(400).json({ status: false, message: error.message });
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    const response = await SellerService.loginSeller(email, password);
    res.json(response);
  } catch (error) {
    res.status(400).json({ status: false, message: error.message });
  }
};

exports.getAllSellers = async (req, res, next) => {
  try {
    const sellers = await SellerService.getAllSellers();
    res.json(sellers);
  } catch (error) {
    res.status(500).json({ status: false, message: error.message });
  }
};

exports.deleteSeller = async (req, res, next) => {
  try {
    const { email } = req.body;
    const response = await SellerService.deleteSeller(email);
    res.json(response);
  } catch (error) {
    res.status(400).json({ status: false, message: error.message });
  }
};

exports.findSeller = async (req, res, next) => {
  try {
    const { searchTerm } = req.body;
    const sellers = await SellerService.findSellersByName(searchTerm);
    res.json(sellers);
  } catch (error) {
    res.status(400).json({ status: false, message: error.message });
  }
};