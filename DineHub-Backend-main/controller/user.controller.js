const UserServices = require('../services/user.services');

exports.register = async (req, res, next) => {
    try {
        const { name, email, password, phone } = req.body;

        // Register the user with name, email, password, and phone
        const successRes = await UserServices.registerUser(name, email, password, phone);

        if (successRes.status) {
            res.json({
                status: true,
                success: 'User registered successfully',
                user: successRes.user // Include user data in the response
            });
        } else {
            res.status(400).json({
                status: false,
                message: successRes.message
            });
        }
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        const response = await UserServices.loginUser(email, password);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.deleteUser = async (req, res, next) => {
    try {
        const { email } = req.body;
        const response = await UserServices.deleteUser(email);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.addMoneyToWallet = async (req, res, next) => {
    try {
        const { userId, amount } = req.body;
        const response = await UserServices.addMoneyToWallet(userId, amount);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

exports.useWalletForPayment = async (req, res, next) => {
    try {
        const { userId, amount } = req.body;
        const response = await UserServices.useWalletForPayment(userId, amount);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}

// New method to get user address by user ID and address ID
exports.getAddressById = async (req, res, next) => {
    try {
        const { userId, addressId } = req.params;
        const response = await UserServices.getAddressById(userId, addressId);
        res.json(response);
    } catch (error) {
        res.status(400).json({ status: false, message: error.message });
    }
}