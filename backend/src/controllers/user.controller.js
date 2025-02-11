import mongoose from "mongoose";
import asyncHandler from "../utils/asynchandler.utils.js";
import {ApiError} from "../utils/API_Error.js";
import { User } from "../models/user.models.js";
import { Video } from "../models/Video.model.js";
import { OTP } from "../models/OTP.model.js";
import { uploadOnCloudinary } from "../utils/cloudinary.js";
import {ApiResponse} from "../utils/API_Response.js";
import { generateOTP } from "../utils/generateOTP.js";
import jwt from "jsonwebtoken";
import twilio from "twilio";
const generateAccessAndRefereshTokens = async (userId) => {
    try {
      const user = await User.findById(userId);
      const accessToken = user.generateAccessToken();
      const refreshToken = user.generateRefreshToken();
  
      user.refreshToken = refreshToken;
      await user.save({ validateBeforeSave: false });
  
      return { accessToken, refreshToken };
    } catch (error) {
      throw new ApiError(
        500,
        "Something went wrong while generating referesh and access token",
      );
    }
  };
  const registerUser = asyncHandler(async (req, res) => {
      const { fullName, username, password, userClass, user_type, mobile,} = req.body;
      
      // Validate fields
      if (
        [fullName, user_type, username, password].some((field) => field?.trim() === "")
      ) {
        throw new ApiError(400, "All fields are required");
      }
    
      // Check if user already exists
      const existedUser = await User.findOne({
        $or: [{ username }],
      });
    
      if (existedUser) {
        throw new ApiError(409, "User with username already exists");
      }
      const defaultProfileImageUrl =
        "https://static.vecteezy.com/system/resources/thumbnails/002/318/271/small/user-profile-icon-free-vector.jpg";
      const profileLocalPath =
        (req?.files?.profileImage && req.files.profileImage[0]?.path) || null;
    
      let profileImgUrl = defaultProfileImageUrl;
    
      if (profileLocalPath) {
        const profileImg = await uploadOnCloudinary(profileLocalPath);
    
        if (!profileImg) {
          throw new ApiError(400, "Profile picture upload failed");
        }
    
        profileImgUrl = profileImg.url;
      }
    
      // Create the user
      const user = await User.create({
        fullName,
        profileImage: profileImgUrl,
        password,
        mobile,
        user_type,
        username: username.toLowerCase(),
        class_no: userClass,
      });

      // Fetch the created user without sensitive fields
      const createdUser = await User.findById(user._id).select(
        "-password -refreshToken",
      );
    
      if (!createdUser) {
        throw new ApiError(500, "Something went wrong while registering the user");
      }
    
      // Send response with created user
      return res
        .status(201)
        .json(
          new ApiResponse(200, { createdUser }, "User registered successfully"),
        );
    });

    const sendOTP = async (req, res) => {
      const mobileNumber= req.body.mobileNumber;
      const otp=generateOTP();
      await OTP.create({ mobileNumber, otp, createdAt: new Date() });
      const accountSid = process.env.TWILIO_ACCOUNT_SID;
  const authToken = process.env.TWILIO_API_KEY_SECRET;
  const Twilio_Number = process.env.TWILIO_NUMBER;
  const client = twilio(accountSid, authToken);
  try {
      const message = await client.messages.create({
          body: `Your OTP is: ${otp}`, // Use template literals to include OTP
          to: `+91${mobileNumber}`, 
          from: Twilio_Number });
  
      res.json({ success: true, messageSid: message.sid });
  } catch (error) {
      res.status(500).json({ success: false, error: error.message });
  }
  };
  // OTP verification function
  const verifyOTP = async (mobileNumber, enteredOTP) => {
      console.log('Searching for OTP with mobile number:', mobileNumber);
      const record = await OTP.findOne({ mobileNumber }).setOptions({ bypassHooks: true }).sort({ createdAt: -1 });
      console.log(record);
      if (!record || record.otp !== enteredOTP) {
          return { success: false, message: 'Invalid OTP' };
      }
  
      const isExpired = (new Date() - record.createdAt) > 5 * 60 * 1000; // 5 minutes expiry
      if (isExpired) {
          return { success: false, message: 'OTP expired' };
      }
  
      return { success: true, message: 'OTP verified' };
  };
  
    const updateUserSchedule = asyncHandler(async (req, res) => {
      const { bedTime, studyTime, schoolTime, studyGoal, username } = req.body;
    
      // Check if userId is provided
      if (!username) {
        throw new ApiError(400, 'Username is required');
      }
    
      // Find user
      const user = await User.findOne({username: username});
      if (!user) {
        throw new ApiError(404, "User not found.");
      }
    
      // Update user fields if provided
      if (bedTime) user.bedTime = new Date(bedTime);
      if (studyTime) user.studyTime = new Date(studyTime);
      if (schoolTime?.start) user.schoolTime.start = new Date(schoolTime.start);
      if (schoolTime?.end) user.schoolTime.end = new Date(schoolTime.end);
      if (studyGoal) user.goal = studyGoal; // Example: "Complete 2 chapters per day"
    
      // Save updated user
      await user.save();
    
      res.status(200).json(new ApiResponse(200, user, "User schedule updated successfully."));
    });
    
    const loginUser = asyncHandler(async (req, res) => {
      const { username, password, enteredOTP } = req.body;
  
      if (!username) {
          throw new ApiError(400, "Username is required");
      }
  
      const user = await User.findOne({ username });
  
      if (!user) {
          throw new ApiError(404, "User does not exist");
      }
  
      const isPasswordValid = await user.isPasswordCorrect(password);
      if (!isPasswordValid) {
          throw new ApiError(401, "Invalid user credentials");
      }
  
      // if (!enteredOTP) {
      //     throw new ApiError(400, "OTP is required for login");
      // }
  
      // const otpVerification = await verifyOTP(user.mobile, enteredOTP);
      // if (!otpVerification.success) {
      //     throw new ApiError(400, otpVerification.message);
      // }
  
      // 🔹 Streak logic (Unchanged)
      const now = new Date();
      const lastLogin = user.lastLoginDate;
      const diffInHours = lastLogin ? (now - lastLogin) / (1000 * 60 * 60) : null;
  
      if (diffInHours !== null && diffInHours >= 24 && diffInHours < 48) {
          user.streak += 1; // Continue streak
      } else if (diffInHours !== null && diffInHours >= 48) {
          user.streak = 1; // Reset streak
      } else if (!lastLogin) {
          user.streak = 1; // First login
      }
  
      if (user.streak > user.maxStreak) {
          user.maxStreak = user.streak; // Update max streak
      }
  
      user.lastLoginDate = now;
      await user.save();
  
      // 🔹 Generate access & refresh tokens after OTP verification
      const { accessToken, refreshToken } = await generateAccessAndRefereshTokens(user._id);
  
      const loggedInUser = await User.findById(user._id).select("-password -refreshToken");
  
      const options = {
          httpOnly: true,
          secure: true,
      };
  
      return res
          .status(200)
          .cookie("accessToken", accessToken, options)
          .cookie("refreshToken", refreshToken, options)
          .json(
              new ApiResponse(
                  200,
                  {
                      user: loggedInUser,
                      accessToken,
                      refreshToken,
                  },
                  "User logged in successfully after OTP verification"
              )
          );
  });
  
  const logoutUser = asyncHandler(async (req, res) => {
    await User.findByIdAndUpdate(
      req.user._id,
      {
        $unset: {
          refreshToken: 1, // this removes the field from document
        },
      },
      {
        new: true,
      },
    );
  
    const options = {
      httpOnly: true,
      secure: true,
    };
  
    return res
      .status(200)
      .clearCookie("accessToken", options)
      .clearCookie("refreshToken", options)
      .json(new ApiResponse(200, {}, "User logged Out"));
  });
  
  const refreshAccessToken = asyncHandler(async (req, res) => {
    const incomingRefreshToken =
      req.cookies.refreshToken || req.body.refreshToken;
  
    if (!incomingRefreshToken) {
      throw new ApiError(401, "unauthorized request");
    }
  
    try {
      const decodedToken = jwt.verify(
        incomingRefreshToken,
        process.env.REFRESH_TOKEN_SECRET,
      );
  
      const user = await User.findById(decodedToken?._id);
  
      if (!user) {
        throw new ApiError(401, "Invalid refresh token");
      }
  
      if (incomingRefreshToken !== user?.refreshToken) {
        throw new ApiError(401, "Refresh token is expired or used");
      }
  
      const options = {
        httpOnly: true,
        secure: true,
      };
  
      const { accessToken, newRefreshToken } =
        await generateAccessAndRefereshTokens(user._id);
  
      return res
        .status(200)
        .cookie("accessToken", accessToken, options)
        .cookie("refreshToken", newRefreshToken, options)
        .json(
          new ApiResponse(
            200,
            { accessToken, refreshToken: newRefreshToken },
            "Access token refreshed",
          ),
        );
    } catch (error) {
      throw new ApiError(401, error?.message || "Invalid refresh token");
    }
  });
  
  const changeCurrentPassword = asyncHandler(async (req, res) => {
    const { oldPassword, newPassword } = req.body;
  
    const user = await User.findById(req.user?._id);
    const isPasswordCorrect = await user.isPasswordCorrect(oldPassword);
  
    if (!isPasswordCorrect) {
      throw new ApiError(400, "Invalid old password");
    }
  
    user.password = newPassword;
    await user.save({ validateBeforeSave: false });
  
    return res
      .status(200)
      .json(new ApiResponse(200, {}, "Password changed successfully"));
  });
  const markVideoAsWatched = asyncHandler(async (req, res) => {
    const { videoId } = req.body;
    const userId = req.user._id;
  
    const video = await video.findById(videoId);
    if (!video) {
      throw new ApiError(404, "Video not found");
    }
  
    // Ensure user is not added multiple times
    if (!video.watchedBy.includes(userId)) {
      video.watchedBy.push(userId);
      await video.save();
    }
  
    res.status(200).json(new ApiResponse(200, video, "Video marked as watched"));
  });
  const getUserStats = asyncHandler(async (req, res) => {
    const userId = req.user._id;
  
    // Fetch user details including streak, maxStreak, wakeup time, study time, goal, and school time
    const user = await User.findById(userId).select("streak maxStreak bedTime studyTime goal schoolTime");
  
    if (!user) {
      throw new ApiError(404, "User not found");
    }
  
    // Count total videos watched by the user
    const totalVideosWatched = await Video.countDocuments({ watchedBy: userId });
  
    // Count total questions asked by the user
    const totalQuestionsAsked = await Question.countDocuments({ owner: userId });
  
    // Count total questions answered by the user
    const totalQuestionsAnswered = await Question.countDocuments({ "answers.owner": userId });
  
    res.status(200).json(
      new ApiResponse(200, {
        totalVideosWatched,
        totalQuestionsAsked,
        totalQuestionsAnswered,
        streak: user.streak,
        maxStreak: user.maxStreak,
        wakeUpTime: user.bedTime,  // Wakeup time is stored in bedTime
        studyTime: user.studyTime,
        studyGoal: user.goal,
        schoolTime: user.schoolTime, // Includes both start & end time
      }, "User's activity stats fetched successfully")
    );
  });
  
  const getCurrentUser = asyncHandler(async (req, res) => {
    return res
      .status(200)
      .json(new ApiResponse(200, req.user, "User fetched successfully"));
  });
  
  const updateAccountDetails = asyncHandler(async (req, res) => {
    const { fullName } = req.body;
  
    if (!fullName) {
      throw new ApiError(400, "All fields are required");
    }
  
    const user = await User.findByIdAndUpdate(
      req.user?._id,
      {
        $set: {
          fullName,
              },
      },
      { new: true },
    ).select("-password");
  
    return res
      .status(200)
      .json(new ApiResponse(200, user, "Account details updated successfully"));
  });
  
  const updateUserDP = asyncHandler(async (req, res) => {
    const DPLocalPath = req.file?.path;
  
    if (!DPLocalPath) {
      throw new ApiError(400, "Avatar file is missing");
    }
  
    //TODO: delete old image
  
    const newDP = await uploadOnCloudinary(DPLocalPath);
  
    if (!newDP.url) {
      throw new ApiError(400, "Error while uploading on profile pic");
    }
  
    const user = await User.findByIdAndUpdate(
      req.user?._id,
      {
        $set: {
          profileImage: newDP.url,
        },
      },
      { new: true },
    ).select("-password");
  
    return res
      .status(200)
      .json(new ApiResponse(200, user, "Profile image updated successfully"));
  });
  
  export {
    generateAccessAndRefereshTokens,
    registerUser,
    loginUser,
    logoutUser,
    markVideoAsWatched,
    refreshAccessToken,
    changeCurrentPassword,
    getUserStats,
    getCurrentUser,
    updateAccountDetails,
    updateUserDP, 
    updateUserSchedule,
    sendOTP,
    verifyOTP
  };
  