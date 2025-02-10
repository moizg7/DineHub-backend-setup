const OrderServices = require('../services/order.services');

exports.placeOrder = async (req, res, next) => {
    try {
        const { userId, sellerId, address, paymentType, approximateTime } = req.body;
        const response = await OrderServices.placeOrder(userId, sellerId, address, paymentType, approximateTime);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.updateOrderStatus = async (req, res, next) => {
    try {
        const { orderId, status } = req.body;
        const response = await OrderServices.updateOrderStatus(orderId, status);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.getOrder = async (req, res, next) => {
    try {
        const { orderId } = req.params;
        const response = await OrderServices.getOrder(orderId);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.getRecentOrders = async (req, res, next) => {
    try {
        const { userId } = req.params;
        const response = await OrderServices.getRecentOrders(userId);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.cancelOrder = async (req, res, next) => {
    try {
        const { orderId } = req.body;
        const response = await OrderServices.cancelOrder(orderId);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.getOrderDetails = async (req, res, next) => {
    try {
        const { orderId } = req.params;
        const response = await OrderServices.getOrderDetails(orderId);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}