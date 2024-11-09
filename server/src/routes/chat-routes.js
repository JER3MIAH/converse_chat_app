import express from "express";
import * as chatController from "../controllers/chat-controller.js";
import { authMiddleware } from "../middlewares/auth-middleware.js";

const router = express.Router();

router.get('/get-chats', authMiddleware, chatController.getChats);
router.delete('/delete-chats', authMiddleware, chatController.deleteChats);
router.post('/create-chat', authMiddleware, chatController.createChat);
router.get('/get-messages', authMiddleware, chatController.getMessages);

export default router;