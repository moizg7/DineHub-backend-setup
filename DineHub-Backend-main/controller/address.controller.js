const AddressServices = require('../services/address.services');

exports.addAddress = async (req, res, next) => {
    try {
        const { userId, address } = req.body;
        const response = await AddressServices.addAddress(userId, address);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.getAddresses = async (req, res, next) => {
    try {
        const { userId } = req.params;
        const response = await AddressServices.getAddresses(userId);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.removeAddress = async (req, res, next) => {
    try {
        const { userId, addressId } = req.body;
        const response = await AddressServices.removeAddress(userId, addressId);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}