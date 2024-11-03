import User from "../models/User.js";
import mongoose from "mongoose";

export const getAllUsers = async (userId) => {
    const userObjId = new mongoose.Types.ObjectId(`${userId}`);
    return await User.find({ _id: { $ne: userObjId } });
};

export const getUser = async (userId) => {
    const userObjId = new mongoose.Types.ObjectId(`${userId}`);
    return await User.findById(userObjId);
};

export const updateUser = async (userId, updateData) => {
    const userObjId = new mongoose.Types.ObjectId(`${userId}`);
    return await User.findByIdAndUpdate(userObjId, updateData, { new: true });
};

export const deleteUser = async (userId) => {
    const userObjId = new mongoose.Types.ObjectId(`${userId}`);
    return await User.findByIdAndDelete(userObjId);
};
