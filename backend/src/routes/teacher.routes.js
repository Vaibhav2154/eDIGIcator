import express from "express";
import { registerTeacher, addVideo, approveVideo, answerQuestion } from "../controllers/teacherController.js";
import { isAdmin } from "../middleware/auth.middleware.js";
import multer from "multer";
import { verifyJWT } from "../middleware/auth.middleware.js";

const router = express.Router();
const upload = multer({ dest: "uploads/" }); 

router.post("/register", registerTeacher);

router.post("/upload-video", verifyJWT, upload.single("video"), addVideo);

router.patch("/approve-video/:videoId", verifyJWT, isAdmin, approveVideo);

router.post("/answer-question", verifyJWT, answerQuestion);

export default router;
