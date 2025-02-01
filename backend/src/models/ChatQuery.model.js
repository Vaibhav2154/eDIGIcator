const mongoose = require("mongoose");

const ChatQuerySchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: "User" }, // Optional
    query: { type: String, required: true },
    response: { type: String, required: true },
    createdAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

module.exports = mongoose.model("ChatQuery", ChatQuerySchema);