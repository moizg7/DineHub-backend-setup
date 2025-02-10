const router = require("express").Router();
const OrderController = require('../controller/order.controller');

router.post("/order/place", OrderController.placeOrder);
router.post("/order/updateStatus", OrderController.updateOrderStatus);
router.get("/order/:orderId", OrderController.getOrder);
router.get("/order/recent/:userId", OrderController.getRecentOrders); // New route for recent orders
router.post("/order/cancel", OrderController.cancelOrder); // New route for canceling orders
router.get("/order/details/:orderId", OrderController.getOrderDetails); // New route for fetching order details by orderId

module.exports = router;