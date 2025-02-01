import express from 'express';
import { generateMCQs } from '../controllers/mcq.controller.js'; // Import the controller

const router = express.Router();

// Route to generate MCQs
router.post('/generate', generateMCQs);

export default router;
