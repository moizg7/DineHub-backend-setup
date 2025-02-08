const router = require("express").Router();
const multer = require('multer');
const MenuController = require('../controller/menu.controller');

// Configure Multer for file uploads
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/menu'); // Folder where images will be saved
    },
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, file.fieldname + '-' + uniqueSuffix + '-' + file.originalname);
    }
});
const upload = multer({ storage: storage });

// Use Multer middleware in the createMenu route to handle file upload
router.post("/menu/createMenu", upload.single('thumbnailUrl'), MenuController.createMenu);

router.get("/menu/:sellerUID", MenuController.getMenus);

router.post("/menu/delete", MenuController.deleteMenu);

module.exports = router;