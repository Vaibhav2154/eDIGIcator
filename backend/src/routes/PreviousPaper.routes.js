import express from "express";
import { insertDefaultPreviousPapers, getPreviousPapersByClassAndSubject } from "../controllers/previousPaper.controller.js";

const router = express.Router();

// ✅ 1️⃣ Route to Insert Default Previous Year Papers
router.post("/insert-default", insertDefaultPreviousPapers);

// ✅ 2️⃣ Route to Fetch Previous Year Papers by Class & Subject
router.get("/:classNumber/:subject", getPreviousPapersByClassAndSubject);

export default router;
