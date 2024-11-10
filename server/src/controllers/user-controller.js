import User from "../models/User.js";
import bcrypt from "bcrypt";
import { generateToken } from "../utils/jwt.js"
import { trimUserModel } from "../utils/trimmer.js";

import * as userService from "../services/user-service.js";

export const register = async (req, res) => {
    const { username, email, avatar, password } = req.body;
    const saltRounds = 10;

    if (!username || !email || !password) {
        return res.status(404).json({ message: "username, email and password are required" });
    }

    const existingEmail = await User.findOne({ email: email });
    const existingUsername = await User.findOne({ username: username });
    if (existingEmail) {
        return res.status(400).json({ message: "A user with this email already eists" });
    }

    if (existingUsername) {
        return res.status(400).json({ message: "A user with this username already eists" });
    }

    try {
        bcrypt.hash(password, saltRounds, async (err, hash) => {
            if (err) {
                console.error("Error hashing password:", err);
                return res.status(500).json({ message: "Error signing up" });
            }
            const newUser = new User({
                username: username,
                email: email,
                avatar: avatar,
                password: hash,
                fcmToken: null,
            });
            await newUser.save();
            const token = generateToken(newUser);
            const responseData = {
                data: trimUserModel(newUser),
                accessToken: token,
                message: "Sign up successfull",
            };
            res.json(responseData);
        });
    } catch (error) {
        console.error("Error saving user:", error);
        res.status(500).json({ message: "Error signing up" });
    }
}

export const login = async (req, res) => {
    console.log("Login called");

    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(404).json({ message: "Email and password is required" });
    }

    try {
        const existingUSer = await User.findOne({ email: email });
        if (!existingUSer) {
            return res.status(404).json({ message: "You do not have an account" });
        }

        bcrypt.compare(password, existingUSer.password, (err, result) => {
            if (err) {
                console.error("Error hashing password:", err);
                return res.status(500).json("Error logging up");
            }
            if (result === true) {
                const token = generateToken(existingUSer);
                const responseData = {
                    data: trimUserModel(existingUSer),
                    accessToken: token,
                    message: "Logged in successfully",
                };
                return res.json(responseData);
            }
            return res.status(404).json({ message: "Incorrect password" });
        });

    } catch (error) {
        console.error(`Error during login: ${error}`);
        res.sendStatus(500).json("Error logging in");
    }
}

export const getAllUsers = async (req, res) => {
    const userId = req.userId;

    const users = await userService.getAllUsers(userId);

    try {
        const responseData = {
            data: users.map(trimUserModel),
            message: "Users fetched successfully",
        };
        res.json(responseData);
    } catch (error) {
        console.error(`Error fetching users: ${error}`);
        res.status(500).json({ message: "An Error occured while fetching users." });
    }
}
export const getProfile = async (req, res) => {
    const userId = req.userId;

    const user = await userService.getUser(userId);

    if (!user) {
        return res.status(404).json({ message: "User not found" });
    }

    try {
        const responseData = {
            data: trimUserModel(user),
            message: "User profile fetched successfully",
        };
        res.json(responseData);
    } catch (error) {
        console.error(`Error fetching profile: ${error}`);
        res.status(500).json({ message: "An Error occured while fetching profile." });
    }
}

export const updateProfile = async (req, res) => {
    const { username, email, avatar } = req.body;
    const userId = req.userId;


    if (!username && !email && !avatar) {
        return res.status(400).json({ message: "At least one of 'username' or 'email' or 'avatar' must be provided." });
    }

    try {
        const updateData = {};
        if (username) updateData.username = username;
        if (email) updateData.email = email;
        if (avatar) updateData.avatar = avatar;


        const updatedUser = await userService.updateUser(userId, updateData);

        if (!updatedUser) {
            return res.status(404).json({ message: "User not found." });
        }

        const responseData = {
            data: trimUserModel(updatedUser),
            message: "Profile updated successfull",
        };
        res.json(responseData);
    } catch (error) {
        console.error(`Error updating profile: ${error}`);
        res.status(500).json({ message: "Error updating profile." });
    }
};

export const saveFcmToken = async (req, res) => {
    const { token } = req.body;
    const userId = req.userId;


    if (!token) {
        return res.status(400).json({ message: "token is required" });
    }

    try {
        const updatedUser = await userService.updateUser(userId, { fcmToken: token });

        if (!updatedUser) {
            return res.status(404).json({ message: "User not found." });
        }

        res.json({
            message: "Fcm token saved successfuly",
        });
    } catch (error) {
        console.error(`Error updating profile: ${error}`);
        res.status(500).json({ message: "Error updating profile." });
    }
};

export const deleteAccount = async (req, res) => {
    const userId = req.userId;

    try {
        const deletedTask = await userService.deleteUser(userId);
        if (!deletedTask) {
            return res.status(404).json({ message: "User not found" });
        }
        res.json({ message: "User Account deleted successfully" });
    } catch (error) {
        console.error(`Error deleting user: ${error}`);
        res.status(500).json({ message: "An error occured" });
    }
}
