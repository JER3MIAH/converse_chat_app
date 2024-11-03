import express from "express";
import * as userController from "../controllers/user-controller.js";
import { authMiddleware } from "../middlewares/auth-middleware.js";

const router = express.Router();

router.post('/signup', userController.register);
router.post('/login', userController.login);
router.get('/get-all-users', authMiddleware, userController.getAllUsers);
router.get('/get-profile', authMiddleware, userController.getProfile);
router.patch('/update-profile', authMiddleware, userController.updateProfile);
router.patch('/save-fcm-token', authMiddleware, userController.saveFcmToken);
router.delete('/delete-account', authMiddleware, userController.deleteAccount);

export default router;