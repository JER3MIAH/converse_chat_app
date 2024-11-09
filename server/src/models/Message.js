import mongoose from "mongoose";

export const messageSchema = new mongoose.Schema({
    chatId: { type: String, required: true },
    text: { type: String, required: true },
    senderId: { type: String, required: true },
    receiverId: { type: String, required: true },
    deletedBy: { type: [String], default: [] },
    repliedTo: { type: String, default: null }
}, {
    timestamps: true,
});

const Message = mongoose.model('Message', messageSchema);

export default Message;
