import express from 'express';
import { getVideosByClassAndSubject } from '../controllers/Video.controller.js';

const router = express.Router();

router.get('/videos/:classNumber/:subject', (req, res) => {
    console.log("Route hit!"); // Debugging line
    getVideosByClassAndSubject(req, res);
});

export default router;
