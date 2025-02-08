const CartServices = require('../services/cart.services');

exports.addItemToCart = async (req, res, next) => {
    try {
        const { userId, itemId, quantity } = req.body;
        const response = await CartServices.addItemToCart(userId, itemId, quantity);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.getCart = async (req, res, next) => {
    try {
        const { userId } = req.params;
        const response = await CartServices.getCart(userId);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.removeItemFromCart = async (req, res, next) => {
    try {
        const { userId, itemId } = req.body;
        const response = await CartServices.removeItemFromCart(userId, itemId);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.clearCart = async (req, res, next) => {
    try {
        const { userId } = req.body;
        const response = await CartServices.clearCart(userId);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}