const OrderModel = require("../models/order.model");
const UserModel = require("../models/user.model");
const ItemModel = require("../models/item.model");

class OrderServices {
    
    static async placeOrder(userId, address, paymentType, approximateTime) {
        try {
            const user = await UserModel.findById(userId);
            if (!user) {
                throw new Error("User not found");
            }

            // Calculate total amount
            let totalAmount = 0;
            for (const cartItem of user.cart) {
                const item = await ItemModel.findById(cartItem.itemId);
                if (item) {
                    totalAmount += item.price * cartItem.quantity;
                }
            }

            const orderData = {
                userId,
                cart: user.cart,
                address,
                paymentType,
                totalAmount,
                approximateTime,
                createdAt: new Date() // Set the creation date and time
            };

            const createOrder = new OrderModel(orderData);
            await createOrder.save();

            // Clear user's cart after placing the order
            user.cart = [];
            await user.save();

            return { status: true, message: 'Order placed successfully', order: createOrder };
        } catch (err) {
            throw err;
        }
    }

    static async updateOrderStatus(orderId, status) {
        try {
            const order = await OrderModel.findById(orderId);
            if (!order) {
                throw new Error("Order not found");
            }

            order.orderStatus = status;
            await order.save();

            return { status: true, message: 'Order status updated successfully', order };
        } catch (err) {
            throw err;
        }
    }

    static async getOrder(orderId) {
        try {
            const order = await OrderModel.findById(orderId).lean();
            if (!order) {
                throw new Error("Order not found");
            }
            return { status: true, order };
        } catch (err) {
            throw err;
        }
    }

    static async getRecentOrders(userId) {
        try {
            const orders = await OrderModel.find({ userId }).sort({ createdAt: -1 }).limit(5).lean();
            return { status: true, orders };
        } catch (err) {
            throw err;
        }
    }

    static async cancelOrder(orderId) {
        try {
            const order = await OrderModel.findById(orderId);
            if (!order) {
                throw new Error("Order not found");
            }

            if (order.orderStatus === 'dispatched' || order.orderStatus === 'delivered') {
                throw new Error("Order cannot be canceled as it has already been dispatched or delivered");
            }

            order.orderStatus = 'canceled';
            await order.save();

            return { status: true, message: 'Order canceled successfully', order };
        } catch (err) {
            throw err;
        }
    }
}

module.exports = OrderServices;