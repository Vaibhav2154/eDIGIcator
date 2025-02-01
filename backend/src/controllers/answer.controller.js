import asyncHandler from '../utils/asynchandler.utils.js';
import ApiError from '../utils/API_Error.js';
import Answer from '../models/answers.model.js';
import Question from '../models/question.model.js';
import { uploadOnCloudinary } from '../utils/cloudinary.js';
import ApiResponse from '../utils/API_Response.js';

const addAnswer = asyncHandler(async (req, res) => {
  const { content, questionId } = req.body;

  if ([content, questionId].some((field) => field?.trim() === "")) {
    throw new ApiError(400, "Answer content or question ID is missing");
  }

  const question = await Question.findById(questionId);
  if (!question) {
    throw new ApiError(404, "Question not found");
  }

  const owner = req.user._id;
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
  });

  question.answers.push(answer._id);
  await question.save();

  res.status(201).json(new ApiResponse(201, answer, "Answer added successfully"));
});

const deleteAnswer = asyncHandler(async (req, res) => {
  const { questionId, id: answerId } = req.params;
  const answer = await Answer.findById(answerId);

  if (!answer) {
    throw new ApiError(404, "Answer not found");
  }

  if (answer.owner.toString() !== req.user.id) {
    throw new ApiError(403, "Not authorized to delete this answer");
  }

  const question = await Question.findById(answer.question);
  question.answers.pull(answer._id);
  await question.save();

  await answer.remove();
  res.status(200).json(new ApiResponse(200, null, "Answer deleted successfully"));
});

const getQuestionAnswers = asyncHandler(async (req, res) => {
  const id = req.params.questionId;
  const answers = await Answer.find({ question: id })
    .populate("answeredBy", "username")
    .select("answer_content owner createdAt upvotes");

  const enhancedAnswers = answers.map((answer) => ({
    ...answer.toObject(),
    totalAnswers: answer?.replies?.length,
    totalUpvotes: answer.upvotes || 0,
  }));

  res.status(200).json(new ApiResponse(200, enhancedAnswers, "All answers fetched successfully"));
});

const getCurrentAnswer = asyncHandler(async (req, res) => {
  try {
    const { answerId } = req.params;

    if (!answerId) {
      throw new ApiError(400, "Answer ID is required");
    }

    const answer = await Answer.findById(answerId)
      .populate({
        path: "answeredBy",
        select: "username profileImage",
      })
      .populate({
        path: "question",
        select: "content owner relatedTags",
      })
      .populate({
        path: "replies",
        select: "content createdBy",
      })
      .select("upvotes");

    if (!answer) {
      throw new ApiError(404, "Answer not found");
    }

    res.status(200).json(new ApiResponse(200, answer, "Answer fetched successfully"));
  } catch (error) {
    res.status(500).json(new ApiError(500, "An error occurred while fetching the answer"));
  }
});

const upvoteAnswer = asyncHandler(async (req, res) => {
  const { answerId } = req.params;
  const answer = await Answer.findById(answerId);
  if (!answer) {
    return res.status(404).json({ error: "Answer not found" });
  }
  await answer.addUpvote();
  res.status(200).json({ success: true, upvotes: answer.upvotes });
});

export {
  addAnswer,
  deleteAnswer,
  getQuestionAnswers,
  getCurrentAnswer,
  upvoteAnswer,
};
