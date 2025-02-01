import asyncHandler from '../utils/asynchandler.utils.js';
import ApiError from '../utils/API_Error.js';
import ApiResponse from '../utils/API_Response.js';
import Answer from '../models/answers.model.js';
import Question from '../models/question.model.js';
import User from '../models/user.model.js';
import { uploadOnCloudinary } from '../utils/cloudinary.js';

const addAnswer = asyncHandler(async (req, res) => {
  const { content, questionId } = req.body;

  if (!content?.trim() || !questionId?.trim()) {
    throw new ApiError(400, 'Answer content or question ID is missing');
  }

  const question = await Question.findById(questionId);
  if (!question) {
    throw new ApiError(404, 'Question not found');
  }

  const owner = req.user._id;
  const user = await User.findById(owner);
  if (!user) {
    throw new ApiError(404, 'User not found');
  }

  let imageUrls = [];
  if (req.files?.images) {
    const uploadPromises = req.files.images.map(async (file) => {
      const uploadedImage = await uploadOnCloudinary(file.path);
      return uploadedImage?.url;
    });
    imageUrls = await Promise.all(uploadPromises);
  }

  const answer = await Answer.create({
    answer_content: content,
    question: questionId,
    answeredBy: owner,
    images: imageUrls,
    user_type: user.user_type,
  });

  question.answers.push(answer._id);
  await question.save();

  res
    .status(201)
    .json(new ApiResponse(201, answer, 'Answer added successfully'));
});

// Controller to delete an answer
const deleteAnswer = asyncHandler(async (req, res) => {
  const { questionId, id: answerId } = req.params;
  const answer = await Answer.findById(answerId);

  if (!answer) {
    throw new ApiError(404, 'Answer not found');
  }

  if (answer.answeredBy.toString() !== req.user.id) {
    throw new ApiError(403, 'Not authorized to delete this answer');
  }

  const question = await Question.findById(answer.question);
  question.answers.pull(answer._id);
  await question.save();

  await answer.remove();
  res
    .status(200)
    .json(new ApiResponse(200, null, 'Answer deleted successfully'));
});

// Controller to get all answers for a specific question
const getQuestionAnswers = asyncHandler(async (req, res) => {
  const { questionId } = req.params;

  const answers = await Answer.find({ question: questionId })
    .populate('answeredBy', 'username user_type')
    .select('answer_content answeredBy createdAt images');

  res
    .status(200)
    .json(new ApiResponse(200, answers, 'All answers fetched successfully'));
});

// Controller to get a specific answer by ID
const getCurrentAnswer = asyncHandler(async (req, res) => {
  const { answerId } = req.params;

  if (!answerId) {
    throw new ApiError(400, 'Answer ID is required');
  }

  const answer = await Answer.findById(answerId)
    .populate({
      path: 'answeredBy',
      select: 'username profileImage user_type',
    })
    .populate({
      path: 'question',
      select: 'content owner relatedTags',
    })
    .populate({
      path: 'replies',
      select: 'content createdBy',
    });

  if (!answer) {
    throw new ApiError(404, 'Answer not found');
  }

  res
    .status(200)
    .json(new ApiResponse(200, answer, 'Answer fetched successfully'));
});

export {
  addAnswer,
  deleteAnswer,
  getQuestionAnswers,
  getCurrentAnswer,
};
