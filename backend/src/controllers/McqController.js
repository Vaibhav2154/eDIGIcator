import axios from 'axios';
import asyncHandler from '../utils/asynchandler.utils.js';
import ApiError from '../utils/API_Error.js';
import ApiResponse from '../utils/API_Response.js';
import redis from '../utils/redis.js'; // Import Redis client

const GEMINI_API_URL = 'https://api.gemini.com/generate-mcqs'; // Replace with actual Gemini API URL

const generateMCQs = asyncHandler(async (req, res) => {
  const { subject, chapter, numberOfQuestions = 5, difficulty } = req.body;

  if (!subject || !chapter) {
    throw new ApiError(400, 'Subject and chapter are required.');
  }

  // Create a cache key based on input parameters
  const cacheKey = `mcqs:${subject}:${chapter}:${numberOfQuestions}:${difficulty}`;

  // Check Redis cache before calling the API
  const cachedMCQs = await redis.get(cacheKey);
  if (cachedMCQs) {
    console.log('Serving from cache');
    return res.status(200).json(new ApiResponse(200, JSON.parse(cachedMCQs), 'MCQs fetched from cache.'));
  }

  try {
    // If not found in cache, call the Gemini API
    const payload = { subject, chapter, numberOfQuestions, difficulty };
    const { data } = await axios.post(GEMINI_API_URL, payload, {
      headers: {
        'Authorization': `Bearer ${ AIzaSyC5I3IvJ_QnEsb28ncuwRgauLCwFLtp6pk}`,
      },
    });

    if (!data || !data.questions) {
      throw new ApiError(500, 'Failed to generate MCQs.');
    }

    // Store the response in Redis cache for 1 hour (3600 seconds)
    await redis.setex(cacheKey, 3600, JSON.stringify(data.questions));

    res.status(200).json(new ApiResponse(200, data.questions, 'MCQs generated successfully.'));
  } catch (error) {
    console.error(error);
    res.status(error.status || 500).json({ error: error.message || 'An error occurred while generating MCQs.' });
  }
});

export { generateMCQs };
