const MenuModel = require("../models/menu.model");

class MenuServices {
    
    static async createMenu(sellerUID, menuTitle, menuInfo, thumbnailUrl, status) {
        try {
            const createMenu = new MenuModel({
                sellerUID,
                menuTitle,
                menuInfo,
                thumbnailUrl,
                status
            });
            await createMenu.save();
            
            return { status: true, message: 'Menu created successfully', menu: createMenu };
        } catch (err) {
            throw err;
        }
    }

    static async getMenus(sellerUID) {
        try {
            const menus = await MenuModel.find({ sellerUID }).lean();
            // Map the menus to include menuId
            const mappedMenus = menus.map(menu => ({
                ...menu,
                menuId: menu._id
            }));
            return { status: true, menus: mappedMenus };
        } catch (err) {
            throw err;
        }
    }

    static async deleteMenu(menuId) {
        try {
            await MenuModel.findByIdAndDelete(menuId);
            return { status: true, message: 'Menu deleted successfully' };
        } catch (err) {
            throw err;
        }
    }
}

module.exports = MenuServices;