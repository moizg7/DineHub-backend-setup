const router = require("express").Router();
const AddressController = require('../controller/address.controller');

router.post("/address/add", AddressController.addAddress);
router.get("/address/:userId", AddressController.getAddresses);
router.post("/address/remove", AddressController.removeAddress);

module.exports = router;