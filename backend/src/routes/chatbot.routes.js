import express from "express";
import { askChatbot } from "../controllers/chatbot.controller.js";
import { verifyUser } from "../middlewares/auth.middleware.js"; // Middleware for authentication

const router = express.Router();

// ✅ 1️⃣ Ask the Chatbot (Requires Authentication)
router.post("/ask", verifyUser, askChatbot);

export default router;
