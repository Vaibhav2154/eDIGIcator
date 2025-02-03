import express from "express";
import { askChatbot } from "../controllers/chatbot.controller.js";
import { verifyJWT } from "../middleware/auth.middleware.js"; // Middleware for authentication

const router = express.Router();

router.post('/analyze-and-answer', askChatbot);


export default router;
