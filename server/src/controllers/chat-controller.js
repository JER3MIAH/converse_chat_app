import { trimChatModel, trimMessageModel, trimUserModel } from "../utils/trimmer.js";
import * as chatService from "../services/chat-service.js";
import User from "../models/User.js";
import mongoose from "mongoose";
import Message from "../models/Message.js";



export const getChats = async (req, res) => {
    const userId = req.userId;

    const chats = await chatService.getChats(userId);

    const populatedChats = await Promise.all(
        chats.map(async (chat) => {
            const populatedParticipants = await Promise.all(
                chat.participants.map(async (participantId) => {
                    const user = await User.findById(participantId);
                    return user;
                })
            );
            const lastMessage = await Message.findOne({ chatId: chat.id })
                .sort({ createdAt: -1 })
                .limit(1);

            return {
                ...chat.toObject(),
                participants: populatedParticipants.map(trimUserModel),
                lastMessage: lastMessage ? trimMessageModel(lastMessage) : null,
            };
        })
    );

    try {
        const responseData = {
            data: populatedChats.map(trimChatModel),
            message: "Chats fetched successfully",
        };
        res.json(responseData);
    } catch (error) {
        console.error(`Error fetching chats: ${error}`);
        res.status(500).json({ message: "An Error occured while fetching chats." });
    }
}

export const createChat = async (req, res) => {
    const userId = req.userId;
    const { id, participants, lastMessage } = req.body;

    const participantsList = participants.map(participant => {
        const userObjId = new mongoose.Types.ObjectId(`${participant.id}`);
        return userObjId;
    });
    console.log(`participants: ${participantsList} with type ${typeof participantsList[0]}`);

    const userDetails = participants.map(participant => ({
        userId: participant.id,
        email: participant.email,
        username: participant.username,
    }));

    const newChatData = {
        id: id,
        participants: participantsList,
        lastMessage: lastMessage,
    };

    const existingChat = await chatService.getChat(id, userId);
    if (existingChat) {
        return res.json({
            data: {
                ...trimChatModel(existingChat),
                participants: userDetails
            },
            message: "Chat already exists",
        });
    }

    try {
        const newChat = await chatService.createChat(newChatData);
        const responseData = {
            data: {
                ...trimChatModel(newChat),
                participants: userDetails  // Include user details in the response
            },
            message: "Chat created successfully",
        };
        res.json(responseData);
    } catch (error) {
        console.error(`Error creating chat: ${error}`);
        res.status(500).json({ message: "An Error occured while creating chat." });
    }
}

export const archiveChats = async (req, res) => {
    const { chatIds } = req.body;

    if (!chatIds || chatIds.length == 0) {
        return res.status(500).json({ message: "chatIds is required" });
    }

    try {
        const selectedChats = await chatService.getChatsByIds(chatIds);
        await Promise.all(selectedChats.map(async (chat) => {
            await chatService.archiveChat(chat.id);
        }));
        const responseData = {
            message: "Chats archived successfully",
        };
        res.json(responseData);
    } catch (error) {
        console.error(`Error archiving chats: ${error}`);
        res.status(500).json({ message: "An Error occured while archiving chats." });
    }
}

export const deleteChats = async (req, res) => {
    const userId = req.userId;
    const { chatIds } = req.body;

    if (!chatIds || chatIds.length == 0) {
        return res.status(500).json({ message: "chatIds is required" });
    }

    try {
        const selectedChats = await chatService.getChatsByIds(chatIds);
        await Promise.all(selectedChats.map(async (chat) => {
            await chatService.deleteChat(chat.id, userId);
        }));
        const responseData = {
            message: "Chats deleted successfully",
        };
        res.json(responseData);
    } catch (error) {
        console.error(`Error fetching chats: ${error}`);
        res.status(500).json({ message: "An Error occured while deleting chats." });
    }
}

export const getMessages = async (req, res) => {
    const userId = req.userId;
    const { chatId } = req.body;

    if (!chatId) {
        return res.status(500).json({ message: "chat id is required" });
    }

    const messages = await chatService.getMessages(chatId, userId);

    try {
        const responseData = {
            data: messages.map(trimMessageModel),
            message: "Messages fetched successfully",
        };
        res.json(responseData);
    } catch (error) {
        console.error(`Error fetching messages: ${error}`);
        res.status(500).json({ message: "An Error occured while fetching messages." });
    }
}