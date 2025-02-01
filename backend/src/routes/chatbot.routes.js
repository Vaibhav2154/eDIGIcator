import express from "express";
import { askChatbot } from "../controllers/chatbot.controller.js";
//import { verifyUser } from "../middleware/auth.middleware.js"; // Middleware for authentication
import { verifyJWT } from "../middleware/auth.middleware.js";

const router = express.Router();

// ✅ 1️⃣ Ask the Chatbot (Requires Authentication)
router.post("/ask", verifyJWT, askChatbot);

export default router;
