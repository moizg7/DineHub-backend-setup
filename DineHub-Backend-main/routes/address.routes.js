const router = require("express").Router();
const AddressController = require('../controller/address.controller');

router.post("/address/add", AddressController.addAddress);
router.get("/address/:userId", AddressController.getAddresses);
router.get("/address/details/:addressId", AddressController.getAddressById); // New route for fetching address details by addressId
router.post("/address/remove", AddressController.removeAddress);

module.exports = router;