import asyncHandler from '../utils/asynchandler.utils.js';
import {ApiError} from '../utils/API_Error.js';
import {ApiResponse} from '../utils/API_Response.js';
import { User } from '../models/user.models.js';
import Question from '../models/question.models.js';
import { uploadOnCloudinary } from '../utils/cloudinary.js';

export const addQuestion = asyncHandler(async (req, res) => {
    const { content, subject, classLevel } = req.body;
    const owner = req.user?._id;
  
    if (!content?.trim() || !owner || !subject || !classLevel) {
      throw new ApiError(400, 'Question content, owner, subject, or class level is required');
    }
  
    let imageUrls = [];
    if (req.files?.images) {
      const uploadPromises = req.files.images.map(async (file) => {
        const uploadedImage = await uploadOnCloudinary(file.path);
        return uploadedImage?.url;
      });
      imageUrls = await Promise.all(uploadPromises);
    }
  
    // Create a question with subject and class as strings, not model references
    const question = await Question.create({
      content,
      owner,
      subject,     // Store subject as a string
      classLevel,  // Store class level as a string
      images: imageUrls,
    });
  
    if (!question) {
      throw new ApiError(500, 'Failed to create question');
    }
  
    return res.status(201).json(new ApiResponse(201, { question }, 'Question created successfully'));
  });
  
  export const getAllQuestions = asyncHandler(async (req, res) => {
    const questions = await Question.find()
      .populate('owner', 'username')
      .select('content owner createdAt subject classLevel images');
  
    res.status(200).json(new ApiResponse(200, questions, 'All questions fetched successfully'));
  });
  
  export const updateQuestion = asyncHandler(async (req, res) => {
    const { content, subject, classLevel } = req.body;
    const question = await Question.findById(req.params.id);
  
    if (!question) {
      throw new ApiError(404, 'Question not found');
    }
  
    if (question.owner.toString() !== req.user.id) {
      throw new ApiError(403, 'Not authorized to update this question');
    }
  
    let imageUrls = [];
    if (req.files?.images) {
      const uploadPromises = req.files.images.map(async (file) => {
        const uploadedImage = await uploadOnCloudinary(file.path);
        return uploadedImage?.url;
      });
      imageUrls = await Promise.all(uploadPromises);
    }
  
    question.content = content || question.content;
    question.subject = subject || question.subject; // Update subject if provided
    question.classLevel = classLevel || question.classLevel; // Update classLevel if provided
    question.images = imageUrls.length ? imageUrls : question.images;
  
    const updatedQuestion = await question.save();
  
    res.status(200).json(new ApiResponse(200, updatedQuestion, 'Question updated successfully'));
  });
  
  export const deleteQuestion = asyncHandler(async (req, res) => {
    const question = await Question.findById(req.params.id);
  
    if (!question) {
      throw new ApiError(404, 'Question not found');
    }
  
    if (question.owner.toString() !== req.user.id) {
      throw new ApiError(403, 'Not authorized to delete this question');
    }
  
    await question.remove();
    res.status(200).json(new ApiResponse(200, null, 'Question deleted successfully'));
  });
  
  export const getUserQuestionHistory = asyncHandler(async (req, res) => {
    const user = await User.findById(req.user._id);
    if (!user) throw new ApiError(404, 'User not found');
  
    const questions = await Question.find({ owner: user._id });
    res.status(200).json(new ApiResponse(200, questions, 'User\'s questions fetched successfully'));
  });
  

export const getQuestionsByClassAndSubject = asyncHandler(async (req, res) => {
    try {
      const user = await User.findById(req.user._id);
      if (!user) throw new ApiError(404, 'User not found');
  
      // Check if user has class and subject data
      if (!user.class_no || !user.subjects || user.subjects.length === 0) {
        return res.status(200).json(new ApiResponse(200, [], 'User has no class or subjects assigned'));
      }
  
      // Fetch questions based on user's class and subjects
      const questions = await Question.find({
        classLevel: user.class_no,  // Assuming `class_no` is a string or number
        subject: { $in: user.subjects }  // Assuming `subjects` is an array of strings
      })
      .populate({
        path: 'answers',
        populate: {
          path: 'answeredBy',
          select: 'username'
        }
      })
      .populate({
        path: 'owner',
        select: 'username profileImage'
      });
  
      // Add additional information to each question
      const enhancedQuestions = questions.map((question) => ({
        ...question.toObject(),
        totalAnswers: question.answers.length,
      }));
  
      res.status(200).json(new ApiResponse(200, enhancedQuestions, 'Questions related to user\'s class and subjects fetched successfully'));
    } catch (error) {
      console.error(error);
      res.status(500).json(new ApiError(500, 'Error has occurred'));
    }
  });
  
