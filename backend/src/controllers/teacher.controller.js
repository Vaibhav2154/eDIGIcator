import asyncHandler from "../utils/asynchandler.utils.js";
import {ApiError} from "../utils/API_Error.js";
import {ApiResponse} from "../utils/API_Response.js";
import { User } from "../models/user.models.js"; // Teacher model
import { Video } from "../models/Video.model.js"; // Video model
import Question from "../models/question.models.js"; // Question model
import { uploadOnCloudinary } from "../utils/cloudinary.js"; // Cloudinary Upload Utility

// Allow a teacher to register and select up to 2 subjects
const registerTeacher = asyncHandler(async (req, res) => {
  const { fullName, username, password, mobile, subjects } = req.body;

  if (!fullName || !username|| !password || !mobile) {
    throw new ApiError(400, "All fields are required.");
  }

  if (!Array.isArray(subjects) || subjects.length === 0 || subjects.length > 2) {
    throw new ApiError(400, "You must choose between 1 and 2 subjects.");
  }

  // Check if user already exists
  const existingUser = await User.findOne({ username });
  if (existingUser) {
    throw new ApiError(409, "User with this username already exists.");
  }

  // Create teacher account
  const teacher = await User.create({
    fullName,
    password,
    mobile,
    username,
    user_type: "Teacher",
    subjects,
  });

  res.status(201).json(new ApiResponse(201, { teacher }, "Teacher registered successfully"));
});

// Allow teacher to add videos (Admin approval required)
const addVideo = asyncHandler(async (req, res) => {
  const { title, description, subject } = req.body;
  const teacherId = req.user._id;

  // Ensure user is a teacher
  const teacher = await User.findById(teacherId);
  if (!teacher || teacher.user_type !== "teacher") {
    throw new ApiError(403, "Only teachers can upload videos.");
  }

  if (!teacher.subjects.includes(subject)) {
    throw new ApiError(403, "You can only upload videos for your chosen subjects.");
  }

  if (!req.file) {
    throw new ApiError(400, "Video file is required.");
  }

  // Upload video to Cloudinary (or any other storage)
  const uploadedVideo = await uploadOnCloudinary(req.file.path);
  if (!uploadedVideo || !uploadedVideo.url) {
    throw new ApiError(500, "Video upload failed.");
  }

  // Save video in database (pending admin approval)
  const video = await Video.create({
    title,
    description,
    subject,
    videoUrl: uploadedVideo.url,
    uploadedBy: teacherId,
    approved: false, // Needs admin approval
  });

  res.status(201).json(new ApiResponse(201, { video }, "Video uploaded, awaiting admin approval."));
});

// Allow admin to approve a video
const approveVideo = asyncHandler(async (req, res) => {
  const { videoId } = req.params;

  // Ensure video exists
  const video = await Video.findById(videoId);
  if (!video) {
    throw new ApiError(404, "Video not found.");
  }

  video.approved = true;
  await video.save();

  res.status(200).json(new ApiResponse(200, video, "Video approved successfully."));
});

// Allow teachers to answer questions only related to their chosen subjects
const answerQuestion = asyncHandler(async (req, res) => {
  const { content, questionId } = req.body;
  const teacherId = req.user._id;

  // Ensure user is a teacher
  const teacher = await User.findById(teacherId);
  if (!teacher || teacher.user_type !== "teacher") {
    throw new ApiError(403, "Only teachers can answer questions.");
  }

  // Ensure question exists
  const question = await Question.findById(questionId);
  if (!question) {
    throw new ApiError(404, "Question not found.");
  }

  // Ensure teacher is answering within their subject domain
  if (!teacher.subjects.includes(question.subject)) {
    throw new ApiError(403, "You can only answer questions related to your chosen subjects.");
  }

  // Create an answer
  const answer = await Answer.create({
    answer_content: content,
    question: questionId,
    answeredBy: teacherId,
  });

  // Link answer to the question
  question.answers.push(answer._id);
  await question.save();

  res.status(201).json(new ApiResponse(201, answer, "Answer added successfully."));
});

export { registerTeacher, addVideo, approveVideo, answerQuestion };
