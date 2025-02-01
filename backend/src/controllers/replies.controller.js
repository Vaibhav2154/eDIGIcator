import asyncHandler from '../utils/asynchandler.utils.js';
import ApiError from '../utils/API_Error.js';
import Answer from '../models/answers.model.js';
import ApiResponse from '../utils/API_Response.js';
import Reply from '../models/replies.model.js';

const addReply = asyncHandler(async (req, res) => {
    const { content, answerId } = req.body;

    // Validate input
    if (!content?.trim() || !answerId?.trim()) {
        throw new ApiError(400, "Reply content or answer ID is missing");
    }

    // Check if the answer exists
    const answer = await Answer.findById(answerId);
    if (!answer) {
        throw new ApiError(404, "Answer not found");
    }
    const owner=req.user._id;
    const reply = await Reply.create({
        content,
        answer: answerId,
        answeredBy:owner
      });
      answer.replies.push(reply._id);
      await answer.save();
    
      res 
        .status(201)
        .json(new ApiResponse(201, answer, "Reply added successfully"));
    });

export { addReply };