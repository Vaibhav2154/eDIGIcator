import express from 'express';
import { getVideosByClassAndSubject } from '../controllers/Video.controller.js';

const router = express.Router();

router.get('/videos/:classNumber/:subject', getVideosByClassAndSubject);

export default router;
