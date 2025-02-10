const UserModel = require("../models/user.model");

class AddressServices {
    static async addAddress(userId, address) {
        try {
            const user = await UserModel.findById(userId);
            if (!user) {
                throw new Error("User not found");
            }

            if (user.addresses.length >= 5) {
                throw new Error("Cannot add more than 5 addresses");
            }

            user.addresses.push(address);
            await user.save();
            return { status: true, message: 'Address added successfully', addresses: user.addresses };
        } catch (err) {
            throw err;
        }
    }

    static async getAddresses(userId) {
        try {
            const user = await UserModel.findById(userId).lean();
            if (!user) {
                throw new Error("User not found");
            }
            return { status: true, addresses: user.addresses };
        } catch (err) {
            throw err;
        }
    }

    static async getAddressById(addressId) {
        try {
            const user = await UserModel.findOne({ "addresses._id": addressId }, { "addresses.$": 1 }).lean();
            if (!user || !user.addresses || user.addresses.length === 0) {
                throw new Error("Address not found");
            }
            return { status: true, address: user.addresses[0] };
        } catch (err) {
            throw err;
        }
    }

    static async removeAddress(userId, addressId) {
        try {
            const user = await UserModel.findById(userId);
            if (!user) {
                throw new Error("User not found");
            }

            user.addresses = user.addresses.filter(address => address._id.toString() !== addressId);
            await user.save();
            return { status: true, message: 'Address removed successfully', addresses: user.addresses };
        } catch (err) {
            throw err;
        }
    }
}

module.exports = AddressServices;