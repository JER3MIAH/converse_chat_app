import Chat from "../models/Chat.js";
import Message from "../models/Message.js";
import mongoose from "mongoose";

export const getChats = async (userId) => {
    const userObjId = new mongoose.Types.ObjectId(`${userId}`);
    return await Chat.find({ participants: { $in: [userObjId] } });
};

export const getChat = async (chatId) => {
    return await Chat.findOne({ id: chatId });
};

export const createChat = async (chatData) => {
    const chat = new Chat(chatData);
    return await chat.save();
};

export const getMessages = async (chatId) => {
    return await Message.find({ chatId: chatId });
};

export const createMessage = async (messageData) => {
    const message = new Message(messageData);
    return await message.save();
};

export const deleteMessage = async (messageId) => {
    const messageObjId = new mongoose.Types.ObjectId(`${messageId}`);
    return await Message.findByIdAndDelete(messageObjId);
};

export const updateMessage = async (messageId, newMessage) => {
    const messageObjId = new mongoose.Types.ObjectId(`${messageId}`);
    return await Message.findByIdAndUpdate(messageObjId, newMessage, { new: true });
};