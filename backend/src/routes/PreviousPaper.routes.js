import express from "express";
import {  getPreviousPapersByClassAndSubject } from "../controllers/previousPaper.controller.js";

const router = express.Router();

router.get("/:classNumber/:subject", getPreviousPapersByClassAndSubject);

export default router;
