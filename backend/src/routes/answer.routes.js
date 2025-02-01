import express from "express";
import {
  addAnswer,
  deleteAnswer,
  getQuestionAnswers,
  getCurrentAnswer,
} from "../controllers/answer.controller.js";
import { verifyJWT } from "../middleware/auth.middleware.js";

const router = express.Router();

router.post("/", verifyJWT, addAnswer);

router.delete("/:questionId/:id", verifyJWT, deleteAnswer);

router.get("/:questionId", getQuestionAnswers);

// ✅ 4️⃣ Get a Single Answer by ID
router.get("/single/:answerId", getCurrentAnswer);
export default router;
