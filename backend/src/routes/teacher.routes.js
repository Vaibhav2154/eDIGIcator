import express from "express";
import { registerTeacher, addVideo, approveVideo, answerQuestion } from "../controllers/teacherController.js";
import { authenticate, isAdmin } from "../middleware/authMiddleware.js";
import multer from "multer";

const router = express.Router();
const upload = multer({ dest: "uploads/" }); 

router.post("/register", registerTeacher);

router.post("/upload-video", authenticate, upload.single("video"), addVideo);

router.patch("/approve-video/:videoId", authenticate, isAdmin, approveVideo);

router.post("/answer-question", authenticate, answerQuestion);

export default router;
