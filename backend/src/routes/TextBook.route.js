import express from 'express';
import { getTextbooksByClassAndSubject } from '../controllers/TextBook.controller.js';

const router = express.Router();

router.get('/:classNumber/:subject', getTextbooksByClassAndSubject);

export default router;
