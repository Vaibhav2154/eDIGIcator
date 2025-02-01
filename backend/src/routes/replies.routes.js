import express from 'express';
import { addReply } from '../controllers/replies.controller.js'; // Import the controller
import { isAuthenticated } from '../middlewares/auth.middleware.js'; // Authentication middleware

const router = express.Router();

// Route to add a reply to an answer
router.post('/addReply', isAuthenticated, addReply);

export default router;
