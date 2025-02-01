import { ApiError } from "../utils/API_Error.js";
import asyncHandler from "../utils/asynchandler.utils.js";
import jwt from "jsonwebtoken";
import { User } from "../models/user.models.js";
// import { Parent } from "../models/parent.model.js";
// import { Counsellor } from "../models/counsellor.model.js";

export const verifyJWT = asyncHandler(async (req, _, next) => {
  try {
    const token =
      req.cookies?.accessToken ||
      req.header("Authorization")?.replace("Bearer ", "");

    // console.log(token);
    if (!token) {
      throw new ApiError(401, "Unauthorized request");
    }

    const decodedToken = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);

    const user = await User.findById(decodedToken?._id).select(
      "-password -refreshToken",
    );

    if (!user) {
      throw new ApiError(401, "Invalid Access Token");
    }

    req.user = user;
    next();
  } catch (error) {
    throw new ApiError(401, error?.message || "Invalid access token");
  }
});

export const isAdmin = (req, res, next) => {
  if (req.user.user_type !== "admin") {
    throw new ApiError(403, "Admin access only.");
  }
  next();
};