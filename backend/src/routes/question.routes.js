import express from 'express';
import { 
  addQuestion, 
  updateQuestion, 
  deleteQuestion, 
  getAllQuestions, 
  getUserQuestionHistory, 
  getQuestionsByClassAndSubject 
} from '../controllers/question.controller.js';
import { verifyJWT } from '../middleware/auth.middleware.js';

const router = express.Router();

// Create a new question
router.post('/add', verifyJWT, addQuestion);

// Get all questions
router.get('/all', getAllQuestions);


router.get('/history', verifyJWT, getUserQuestionHistory);


router.get('/by-class-subject', verifyJWT, getQuestionsByClassAndSubject);


router.patch('/update/:id', verifyJWT, updateQuestion);

router.delete('/delete/:id', verifyJWT, deleteQuestion);

export default router;
