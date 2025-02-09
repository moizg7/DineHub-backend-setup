const UserModel = require("../models/user.model");
const ItemModel = require("../models/item.model"); // Import the Item model

class CartServices {
    
    static async addItemToCart(userId, itemId, quantity) {
        try {
            const user = await UserModel.findById(userId);
            if (!user) {
                throw new Error("User not found");
            }

            const cartItem = user.cart.find(item => item.itemId === itemId);
            if (cartItem) {
                cartItem.quantity += quantity;
                if (cartItem.quantity > 99) {
                    cartItem.quantity = 99;
                }
            } else {
                if (user.cart.length >= 99) {
                    throw new Error("Cart cannot have more than 99 items");
                }
                user.cart.push({ itemId, quantity });
            }

            await user.save();
            return { status: true, message: 'Item added to cart successfully', cart: user.cart };
        } catch (err) {
            throw err;
        }
    }

    static async getCart(userId) {
        try {
            const user = await UserModel.findById(userId).lean();
            if (!user) {
                throw new Error("User not found");
            }

            // Fetch item details including price
            const cartItems = await Promise.all(user.cart.map(async (cartItem) => {
                const item = await ItemModel.findById(cartItem.itemId).lean();
                return {
                    ...cartItem,
                    price: item.price,
                    title: item.title,
                    thumbnailUrl: item.thumbnailUrl,
                    longDescription: item.longDescription,
                };
            }));

            return { status: true, cart: cartItems };
        } catch (err) {
            throw err;
        }
    }

    static async removeItemFromCart(userId, itemId) {
        try {
            const user = await UserModel.findById(userId);
            if (!user) {
                throw new Error("User not found");
            }

            user.cart = user.cart.filter(item => item.itemId !== itemId);
            await user.save();
            return { status: true, message: 'Item removed from cart successfully', cart: user.cart };
        } catch (err) {
            throw err;
        }
    }

    static async clearCart(userId) {
        try {
            const user = await UserModel.findById(userId);
            if (!user) {
                throw new Error("User not found");
            }

            user.cart = [];
            await user.save();
            return { status: true, message: 'Cart cleared successfully', cart: user.cart };
        } catch (err) {
            throw err;
        }
    }
}

module.exports = CartServices;