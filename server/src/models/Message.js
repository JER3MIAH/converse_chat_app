import mongoose from "mongoose";

export const messageSchema = new mongoose.Schema({
    chatId: { type: String, required: true },
    text: { type: String, required: true },
    senderId: { type: String, required: true },
    deletedBy: { type: [String], default: [] }
}, {
    timestamps: true,
});

const Message = mongoose.model('Message', messageSchema);

export default Message;
