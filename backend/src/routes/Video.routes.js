import express from 'express';
import { insertDefaultVideos, getVideosByClassAndSubject } from '../controllers/Video.controller.js';

const router = express.Router();

// Route to insert default videos (run only once when needed)
router.get('/insert-default-videos', insertDefaultVideos);

// Route to fetch videos by class and subject
router.get('/videos/:classNumber/:subject', getVideosByClassAndSubject);

export default router;
