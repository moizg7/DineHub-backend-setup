// services/sellerService.js
const SellerModel = require('../models/sellermodel');
const MenuModel = require('../models/menu.model');
const ItemModel = require('../models/item.model');
const bcrypt = require("bcrypt");

class SellerService {
  static async registerSeller(name, email, password, phone, address, photoUrl) {
    try {
      // Check if email is already in use
      const existingSeller = await SellerModel.findOne({ email });
      if (existingSeller) {
        throw new Error("Email is already in use");
      }

      // Validate phone number (only digits)
      if (!/^\d+$/.test(phone)) {
        throw new Error("Phone number is not valid");
      }

      const sellerData = {
        name,
        email,
        password,
        phone,
        address
      };

      if (photoUrl) {
        sellerData.photoUrl = photoUrl;
      }

      const createSeller = new SellerModel(sellerData);
      await createSeller.save();
      return { status: true, message: 'Seller registered successfully', seller: createSeller };
    } catch (err) {
      throw err;
    }
  }

  static async loginSeller(email, password) {
    try {
      // Find seller by email
      const seller = await SellerModel.findOne({ email });
      if (!seller) {
        throw new Error("Seller not found");
      }

      // Compare password
      const isMatch = await bcrypt.compare(password, seller.password);
      if (!isMatch) {
        throw new Error("Invalid password");
      }

      // Return seller data (excluding password)
      return {
        status: true,
        message: "Login successful",
        seller: {
          id: seller._id,
          name: seller.name,
          email: seller.email,
          phone: seller.phone,
          address: seller.address,
          photoUrl: seller.photoUrl
        }
      };
    } catch (err) {
      throw err;
    }
  }

  static async getAllSellers() {
    try {
      const sellers = await SellerModel.find({});
      return sellers;
    } catch (err) {
      throw err;
    }
  }

  static async deleteSeller(email) {
    try {
      const seller = await SellerModel.findOneAndDelete({ email });
      if (!seller) {
        throw new Error("Seller not found");
      }

      // Delete associated menus and items
      const menus = await MenuModel.find({ sellerUID: seller._id });
      for (const menu of menus) {
        await ItemModel.deleteMany({ menuId: menu._id });
      }
      await MenuModel.deleteMany({ sellerUID: seller._id });

      return { status: true, message: 'Seller and associated data deleted successfully' };
    } catch (err) {
      throw err;
    }
  }

  static async findSellersByName(searchTerm) {
    try {
      const regex = new RegExp(searchTerm, 'i'); // Case-insensitive search
      const sellers = await SellerModel.find({ name: regex });
      return sellers;
    } catch (error) {
      throw new Error(error.message);
    }
  }
}

module.exports = SellerService;