const UserModel = require("../models/user.model");

class UserServices {
    
    static async registerUser(name, email, password, phone) {
        try {
            // Check if email is already in use
            const existingUser = await UserModel.findOne({ email });
            if (existingUser) {
                return { status: false, message: "Email is already in use" };
            }

            // Create user (password will be hashed by the pre-save middleware)
            const createUser = new UserModel({
                name,
                email,
                password, // Plain text password (will be hashed by middleware)
                phone
            });
            await createUser.save();
            
            return { 
                status: true, 
                message: 'User registered successfully', 
                user: {
                    id: createUser._id,
                    name: createUser.name,
                    email: createUser.email,
                    phone: createUser.phone,
                    userCart: createUser.userCart
                }
            };
        } catch (err) {
            return { status: false, message: err.message };
        }
    }

    static async loginUser(email, password) {
        try {
            // Find user by email
            const user = await UserModel.findOne({ email });
            if (!user) {
                return { status: false, message: "User not found" };
            }

            // Debug print statements to log the passwords being compared
            console.log("Plain text password:", password);
            console.log("Stored password:", user.password);

            // Compare password using the comparePassword method from the model
            const isMatch = await user.comparePassword(password);
            console.log("Password match result:", isMatch); // Debug print statement

            if (!isMatch) {
                return { status: false, message: "Invalid password" };
            }

            // Return user data (excluding password)
            return {
                status: true,
                message: "Login successful",
                user: {
                    id: user._id,
                    name: user.name,
                    email: user.email,
                    phone: user.phone,
                    userCart: user.userCart
                }
            };
        } catch (err) {
            return { status: false, message: err.message };
        }
    }

    static async deleteUser(email) {
        try {
            const result = await UserModel.findOneAndDelete({ email });
            if (!result) {
                return { status: false, message: "User not found" };
            }
            return { status: true, message: 'User deleted successfully' };
        } catch (err) {
            return { status: false, message: err.message };
        }
    }
    

}

module.exports = UserServices;