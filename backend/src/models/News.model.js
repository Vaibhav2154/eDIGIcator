import mongoose from "mongoose";

const NewsSchema = new mongoose.Schema({
  title: { type: String, required: true },
  content: { type: String, required: true },
  category: { 
    type: String, 
    enum: ["national", "external", "sports", "technology", "education"], 
    required: true 
  },
  source: { type: String, required: true }, // News Source URL
  publishedAt: { type: Date, required: true },
  createdAt: { type: Date, default: Date.now }
});

export default mongoose.model("News", NewsSchema);
