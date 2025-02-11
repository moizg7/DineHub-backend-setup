const ItemModel = require("../models/item.model");

class ItemServices {
    
    static async createItem(menuId, sellerUID, title, shortInfo, longDescription, price, thumbnailUrl, status) {
        try {
            const createItem = new ItemModel({
                menuId,
                sellerUID,
                title,
                shortInfo,
                longDescription,
                price,
                thumbnailUrl,
                status
            });
            await createItem.save();
            
            return { status: true, message: 'Item created successfully', item: createItem };
        } catch (err) {
            throw err;
        }
    }

    static async getItems(menuId) {
        try {
            const items = await ItemModel.find({ menuId }).lean();
            return { status: true, items };
        } catch (err) {
            throw err;
        }
    }

    static async deleteItem(itemId) {
        try {
            await ItemModel.findByIdAndDelete(itemId);
            return { status: true, message: 'Item deleted successfully' };
        } catch (err) {
            throw err;
        }
    }

    // Add this method to handle fetching items by their IDs
    static async getItemsByIds(itemIds) {
        try {
            const items = await ItemModel.find({ _id: { $in: itemIds } }).lean();
            return { status: true, items };
        } catch (err) {
            throw err;
        }
    }
}

module.exports = ItemServices;