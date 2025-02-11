const router = require("express").Router();
const multer = require('multer');
const UserController = require('../controller/user.controller');

// Configure Multer for file uploads
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/'); // Folder where images will be saved
    },
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, file.fieldname + '-' + uniqueSuffix + '-' + file.originalname);
    }
});
const upload = multer({ storage: storage });

// Use Multer middleware in the register route to handle file upload
router.post("/register", upload.single('photo'), UserController.register);

router.post("/login", UserController.login); // New login route added

router.post("/delete", UserController.deleteUser);

router.post("/wallet/add", UserController.addMoneyToWallet); // Add money to wallet route
router.post("/wallet/use", UserController.useWalletForPayment); // Use wallet for payment route

module.exports = router;