const ItemServices = require('../services/item.services');

exports.createItem = async (req, res, next) => {
    try {
        const { menuId, sellerUID, title, shortInfo, longDescription, price, status } = req.body;
        const thumbnailUrl = req.file ? `${req.protocol}://${req.get('host')}/uploads/items/${req.file.filename}` : null;

        const successRes = await ItemServices.createItem(menuId, sellerUID, title, shortInfo, longDescription, price, thumbnailUrl, status);

        res.json({ status: true, success: 'Item created successfully', item: successRes.item });

    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.getItems = async (req, res, next) => {
    try {
        const { menuId } = req.params;
        const items = await ItemServices.getItems(menuId);
        res.json(items);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.deleteItem = async (req, res, next) => {
    try {
        const { itemId } = req.body;
        const deleteItem = await ItemServices.deleteItem(itemId);
        res.json(deleteItem);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

// Add this method to handle fetching items by their IDs
exports.getItemsByIds = async (req, res, next) => {
    try {
        const { itemIds } = req.body;
        const items = await ItemServices.getItemsByIds(itemIds);
        res.json(items);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}