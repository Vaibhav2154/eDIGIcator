// const mongoose = require("mongoose");

// const CourseSchema = new mongoose.Schema(
//   {
//     title: { type: String, required: true },
//     description: { type: String, required: true },
//     teacher: { type: mongoose.Schema.Types.ObjectId, ref: "User" }, // Reference to teacher
//     category: { type: String, required: true }, // Eg: Math, Science, Tech
//     language: { type: String, default: "en" }, // Language of the course
//     content: [
//       {
//         type: { type: String, enum: ["video", "text", "quiz"], required: true },
//         data: { type: String, required: true }, // URL for video, text content, or quiz data
//       },
//     ],
//     studentsEnrolled: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
//     createdAt: { type: Date, default: Date.now },
//   },
//   { timestamps: true }
// );

// module.exports = mongoose.model("Course", CourseSchema);