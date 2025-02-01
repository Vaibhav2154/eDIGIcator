import mongoose from 'mongoose';

const NewsSchema = new mongoose.Schema(
  {
    title: { type: String, required: true },
    content: { type: String, required: true },
    category: { type: String, enum: ["education", "technology", "farming"], required: true },
    source: { type: String }, // The source from the API (e.g., URL or publisher)
    language: { type: String, default: "en" },
    publishedAt: { type: Date, required: true },
    createdAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

export default mongoose.model("News", NewsSchema);
