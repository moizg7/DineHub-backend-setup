const router = require("express").Router();
const CartController = require('../controller/cart.controller');

router.post("/cart/add", CartController.addItemToCart);
router.get("/cart/:userId", CartController.getCart);
router.post("/cart/remove", CartController.removeItemFromCart);
router.post("/cart/clear", CartController.clearCart);

module.exports = router;