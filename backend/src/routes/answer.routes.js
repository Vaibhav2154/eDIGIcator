import express from "express";
import {
  addAnswer,
  deleteAnswer,
  getQuestionAnswers,
  getCurrentAnswer,
  upvoteAnswer,
} from "../controllers/answer.controller.js";
import { verifyUser } from "../middlewares/auth.middleware.js"; // Middleware for authentication

const router = express.Router();

// ✅ 1️⃣ Add an Answer (Requires Authentication)
router.post("/", verifyUser, addAnswer);

// ✅ 2️⃣ Delete an Answer (Requires Authentication)
router.delete("/:questionId/:id", verifyUser, deleteAnswer);

// ✅ 3️⃣ Get All Answers for a Question
router.get("/:questionId", getQuestionAnswers);

// ✅ 4️⃣ Get a Single Answer by ID
router.get("/single/:answerId", getCurrentAnswer);

// ✅ 5️⃣ Upvote an Answer
router.patch("/:answerId/upvote", verifyUser, upvoteAnswer);

export default router;
