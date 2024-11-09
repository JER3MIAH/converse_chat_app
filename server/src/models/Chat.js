import mongoose from 'mongoose';
import { messageSchema } from "./Message.js";

const chatSchema = new mongoose.Schema({
    id: { type: String, required: true },
    participants: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }],
    lastMessage: messageSchema,
    deletedBy: { type: [String], default: [] },
    isArchived: { type: Boolean, default: false }
}, { collection: "chats" });

const Chat = mongoose.model('Chat', chatSchema);

export default Chat;
