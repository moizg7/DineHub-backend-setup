const MenuServices = require('../services/menu.services');

exports.createMenu = async (req, res, next) => {
    try {
        const { sellerUID, menuTitle, menuInfo, status } = req.body;
        const thumbnailUrl = req.file ? `${req.protocol}://${req.get('host')}/uploads/menu/${req.file.filename}` : null; // Get the full URL if a file was uploaded

        // Create the menu with the provided details
        const successRes = await MenuServices.createMenu(sellerUID, menuTitle, menuInfo, thumbnailUrl, status);

        res.json({ status: true, success: 'Menu created successfully', menu: successRes.menu });

    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.getMenus = async (req, res, next) => {
    try {
        const { sellerUID } = req.params;
        const menus = await MenuServices.getMenus(sellerUID);
        res.json(menus);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.deleteMenu = async (req, res, next) => {
    try {
        const { menuId } = req.body;
        const deleteMenu = await MenuServices.deleteMenu(menuId);
        res.json(deleteMenu);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}