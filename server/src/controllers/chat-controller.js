import { trimChatModel, trimMessageModel, trimUserModel } from "../utils/trimmer.js";
import * as chatService from "../services/chat-service.js";
import User from "../models/User.js";
import mongoose from "mongoose";



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

            return {
                ...chat.toObject(),
                participants: populatedParticipants.map(trimUserModel),
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

    const existingChat = await chatService.getChat(id);
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

export const getMessages = async (req, res) => {
    const { chatId } = req.body;

    if (!chatId) {
        return res.status(500).json({ message: "chat id is required" });
    }

    const messages = await chatService.getMessages(chatId);

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