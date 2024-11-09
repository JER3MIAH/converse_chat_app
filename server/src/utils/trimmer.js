// Functions to trim mongodb generated properties like "_id" and "__v" so its
// not part of the response payload 

export const trimUserModel = (user) => {
    return {
        userId: user._id,
        username: user.username || null,
        avatar: user.avatar,
        email: user.email,
    };
};

export const trimChatModel = (chat) => {
    return {
        id: chat.id,
        participants: chat.participants,
        isArchived: chat.isArchived,
        lastMessage: chat.lastMessage || null,
    };
};

export const trimMessageModel = (message) => {
    return {
        id: message._id,
        chatId: message.chatId,
        senderId: message.senderId,
        receiverId: message.receiverId,
        text: message.text,
        createdAt: message.createdAt,
        updatedAt: message.updatedAt || null,
    };
};