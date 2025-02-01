import mongoose from "mongoose";
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";
const { Schema } = mongoose;
const userSchema = new Schema(
  {
    username: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
      index: true,
    },
    fullName: {
      type: String,
      required: true,
      trim: true,
      index: true,
    },
    mobile: Number,
    profileImage: {
      type: String, // cloudinary url
    },
    goal: {
      type: String
  },
    password: {
      type: String,
      required: [true, "Password is required"],
      minLength: 6,
    },
    refreshToken: {
      type: String,
    },
    questions: {
      type: Schema.Types.ObjectId,
      ref: "question",
    },
    class_no: Number,
    user_type: {
      type: String,
      required: true,
      enum: ["Student", "Teacher", "admin"],
    },
    lastLoginDate: {
      type: Date,
    },
    streak: {
      type: Number,
      default: 0,
    },
    maxStreak: {
      type: Number,
      default: 0,
    },
    bedTime: {
      type: Date,
    },
    studyTime: {
      type: Date,
    },
    schoolTime: {
      start: {
        type: Date,
      },
      end: {
        type: Date,
      },
    },  
    refreshToken: String,
  },
  {
    timestamps: true,
  },
);

userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();

  this.password = await bcrypt.hash(this.password, 10);
  next();
});

userSchema.methods.isPasswordCorrect = async function (password) {
  return await bcrypt.compare(password, this.password);
};

userSchema.methods.generateAccessToken = function () {
  return jwt.sign(
    {
      _id: this._id,
      username: this.username,
      fullName: this.fullName,
    },
    process.env.ACCESS_TOKEN_SECRET,
    {
      expiresIn: process.env.ACCESS_TOKEN_EXPIRY,
    },
  );
};
userSchema.methods.generateRefreshToken = function () {
  return jwt.sign(
    {
      _id: this._id,
    },
    process.env.REFRESH_TOKEN_SECRET,
    {
      expiresIn: process.env.REFRESH_TOKEN_EXPIRY,
    },
  );
};

export const User = mongoose.model("User", userSchema);

