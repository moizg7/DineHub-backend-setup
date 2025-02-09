const router = require("express").Router();
const multer = require('multer');
const SellerController = require('../controller/sellercontroller');

// Configure Multer for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/sellers'); // Folder where images will be saved
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + '-' + file.originalname);
  }
});
const upload = multer({ storage: storage });

// Use Multer middleware in the register route to handle file upload
router.post("/seller/register", upload.single('photo'), SellerController.register);

router.post("/seller/login", SellerController.login); // New login route added

router.get('/seller/getsellers', SellerController.getAllSellers);

router.post("/seller/delete", SellerController.deleteSeller);

router.post("/seller/find", SellerController.findSeller);

module.exports = router;