import express from 'express';
import { insertDefaultTextbooks, getTextbooksByClassAndSubject } from '../controllers/TextBook.controller.js';

const router = express.Router();

// ✅ 1️⃣ Route to insert default textbooks (only if they are empty)
router.get('/insert-default', insertDefaultTextbooks);

// ✅ 2️⃣ Route to get textbooks by class and subject
router.get('/class/:classNumber/subject/:subject', getTextbooksByClassAndSubject);

export default router;
