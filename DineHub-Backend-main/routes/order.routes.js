const router = require("express").Router();
const OrderController = require('../controller/order.controller');

router.post("/order/place", OrderController.placeOrder);
router.post("/order/updateStatus", OrderController.updateOrderStatus);
router.get("/order/:orderId", OrderController.getOrder);
router.get("/order/recent/:userId", OrderController.getRecentOrders);
router.post("/order/cancel", OrderController.cancelOrder);
router.get("/order/details/:orderId", OrderController.getOrderDetails);
router.get("/order/new/:sellerId", OrderController.getNewOrders); // Add this line

// New route to get delivered orders
router.get("/order/delivered/:userId", OrderController.getDeliveredOrders);

router.get("/order/earnings/:sellerId", OrderController.getTotalEarningsBySeller);

module.exports = router;