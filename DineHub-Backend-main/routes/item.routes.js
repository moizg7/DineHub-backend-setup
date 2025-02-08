const router = require("express").Router();
const multer = require('multer');
const ItemController = require('../controller/item.controller');

// Configure Multer for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/items'); // Folder where images will be saved
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, file.fieldname + '-' + uniqueSuffix + '-' + file.originalname);
  }
});
const upload = multer({ storage: storage });

// Use Multer middleware in the createItem route to handle file upload
router.post("/item/createItem", upload.single('thumbnailUrl'), ItemController.createItem);

router.get("/item/:menuId", ItemController.getItems);

router.post("/item/delete", ItemController.deleteItem);


module.exports = router;