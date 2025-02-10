// controllers/sellerController.js
const SellerService = require('../services/sellerService');

class SellerController {
  static async register(req, res) {
    try {
      const { name, email, password, phone, address } = req.body;
      const photoUrl = req.file ? `${req.protocol}://${req.get('host')}/uploads/sellers/${req.file.filename}` : null; // Get the full URL if a file was uploaded

      const result = await SellerService.registerSeller(name, email, password, phone, address, photoUrl);
      res.status(201).json(result);
    } catch (err) {
      res.status(500).json({ status: false, message: err.message });
    }
  }

  static async login(req, res) {
    try {
      const { email, password } = req.body;
      const result = await SellerService.loginSeller(email, password);
      res.status(200).json(result);
    } catch (err) {
      res.status(500).json({ status: false, message: err.message });
    }
  }

  static async getAllSellers(req, res) {
    try {
      const sellers = await SellerService.getAllSellers();
      res.status(200).json(sellers);
    } catch (err) {
      res.status(500).json({ status: false, message: err.message });
    }
  }

  static async deleteSeller(req, res) {
    try {
      const { email } = req.body;
      const result = await SellerService.deleteSeller(email);
      res.status(200).json(result);
    } catch (err) {
      res.status(500).json({ status: false, message: err.message });
    }
  }

  static async findSeller(req, res) {
    try {
      const { searchTerm } = req.body;
      const sellers = await SellerService.findSellersByName(searchTerm);
      res.status(200).json(sellers);
    } catch (err) {
      res.status(500).json({ status: false, message: err.message });
    }
  }
}

module.exports = SellerController;