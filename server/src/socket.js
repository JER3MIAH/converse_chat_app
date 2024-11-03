import { io } from "../app.js";
import * as chatService from "./services/chat-service.js";
import { trimMessageModel } from "./utils/trimmer.js";

io.on('connection', (socket) => {
    console.log('A user connected:', socket.id);

    socket.emit('PING', 'Hii there buddy!');

    socket.on('JOIN_CHAT', (chatId) => {
        socket.join(chatId);
        console.log(`User joined room: ${chatId}`);
    });

    socket.on('SEND_MESSAGE', async (message) => {
        const chatId = message.chatId;
        console.log(`User: ${message.senderId} sent message: ${trimMessageModel(message)}`);

        try {
            const newMessage = await chatService.createMessage(message);
            // Emit the message back to the sender
            socket.emit('RECEIVE_MESSAGE', trimMessageModel(newMessage));

            socket.to(chatId).emit('RECEIVE_MESSAGE', trimMessageModel(newMessage));
        } catch (error) {
            console.error(`Error sending message in chat ${chatId}:`, error);
            // socket.emit('ERROR', { message: 'Failed to send message' });
        }

    });


    socket.on('disconnect', () => {
        console.log('User disconnected:', socket.id);
    });
});
