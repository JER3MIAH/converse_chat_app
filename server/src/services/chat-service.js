import Chat from "../models/Chat.js";
import Message from "../models/Message.js";
import mongoose from "mongoose";
import { areArraysEqual } from "../utils/helper_funcs.js";

export const getChats = async (userId) => {
    const userObjId = new mongoose.Types.ObjectId(`${userId}`);
    return await Chat.find({
        participants: { $in: [userObjId] },
        deletedBy: { $ne: userId }
    });
};

export const getChat = async (chatId, userId) => {
    // await Chat.updateOne(
    //     { id: chatId, deletedBy: userId },
    //     { $pull: { deletedBy: userId } }
    // );
    return await Chat.findOne({ id: chatId });
};

export const archiveChat = async (chatId) => {
    const chat = await getChat(chatId);
    const value = chat.isArchived;
    return await Chat.findByIdAndUpdate(chat._id, { isArchived: !value });
}

export const deleteChat = async (chatId, userId) => {
    const chat = await getChat(chatId);
    if (!chat) {
        throw new Error("Chat not found");
    }

    if (chat.deletedBy.includes(userId)) {
        return;
    }
    await Chat.updateOne(
        { id: chatId },
        { $addToSet: { deletedBy: userId } }
    );

    if (areArraysEqual(chat.deletedBy, chat.participants.map(user => user.toString()))) {
        await Message.deleteMany({ chatId: chatId });
        await Chat.findOneAndDelete({ id: chatId });
    }

    //* Update the deletedBy field for all messages in the chat
    await Message.updateMany(
        { chatId: chatId },
        { $addToSet: { deletedBy: userId } }
    );
};

export const getChatsByIds = async (chatIds) => {
    return await Chat.find({ id: { $in: chatIds } });
};

export const getMessagesByIds = async (messageIds) => {
    const messageObjIds = messageIds.map(m => new mongoose.Types.ObjectId(`${m}`));
    return await Message.find({ _id: { $in: messageObjIds } });
};

export const createChat = async (chatData) => {
    const chat = new Chat(chatData);
    return await chat.save();
};

export const getMessages = async (chatId, userId) => {
    return await Message.find({
        chatId: chatId,
        deletedBy: { $ne: userId }
    });
};

export const createMessage = async (messageData) => {
    const message = new Message(messageData);
    return await message.save();
};

export const deleteMessage = async (messageId, userId, deleteForEveryone) => {
    const messageObjId = new mongoose.Types.ObjectId(`${messageId}`);
    const message = await Message.findById(messageObjId);
    const chat = await getChat(message.chatId);

    if (message.deletedBy.includes(userId)) {
        return;
    }
    await Message.findByIdAndUpdate(
        messageObjId,
        { $addToSet: { deletedBy: userId } }
    );

    if (deleteForEveryone === true || areArraysEqual(message.deletedBy, chat.participants.map(user => user.toString()))) {
        await Message.findByIdAndDelete(messageObjId);
    }

};

export const updateMessage = async (messageId, newMessage) => {
    const messageObjId = new mongoose.Types.ObjectId(`${messageId}`);
    return await Message.findByIdAndUpdate(messageObjId, newMessage, { new: true });
};