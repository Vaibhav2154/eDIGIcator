import mongoose from "mongoose";

const VideoSchema = new mongoose.Schema({
  class: { type: Number, required: true }, // Class number (e.g., 8, 10, 12)
  subject: { type: String, required: true }, // Subject name (e.g., Mathematics, Physics)
  module: { type: Number, required: true }, // Chapter number
  title: { type: String, required: true }, // Chapter name
  videoUrl: { type: String, required: true } // YouTube or cloud storage link
});

export default mongoose.model("Video", VideoSchema);
