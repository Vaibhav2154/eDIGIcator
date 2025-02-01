import mongoose from "mongoose";

// Assuming you have a User model to reference
const VideoSchema = new mongoose.Schema({
  class: { type: Number, required: true }, // Class number (e.g., 8, 10, 12)
  subject: { type: String, required: true }, // Subject name (e.g., Mathematics, Physics)
  module: { type: Number, required: true }, // Chapter number
  title: { type: String, required: true }, // Chapter name
  videoUrl: { type: String, required: true }, // YouTube or cloud storage link
  watchedBy: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }] // Array of User references
});

export const Video = mongoose.model("Video", VideoSchema);
