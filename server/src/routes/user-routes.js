import express from "express";
import * as userController from "../controllers/user-controller.js";
import { authMiddleware } from "../middlewares/auth-middleware.js";

const router = express.Router();

router.post('/signup', userController.register);
router.post('/login', userController.login);
router.get('/get-profile', authMiddleware, userController.getProfile);
router.patch('/update-profile', authMiddleware, userController.updateProfile);
router.delete('/delete-account', authMiddleware, userController.deleteAccount);

export default router