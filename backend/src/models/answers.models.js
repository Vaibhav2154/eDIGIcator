import mongoose from 'mongoose';
import { User } from '../models/user.model.js';

const { Schema } = mongoose;

const answerSchema = new Schema(
{
    question: {
      type: Schema.Types.ObjectId,
      ref: 'Question',
    },
    answer_content: {
      type: String,
      required: true,
    },
    upvotes: {
      type: Number,
      default: 0,
    },
    answeredBy: {
      type: Schema.Types.ObjectId,
      ref: 'User',
    },
    images: [
      {
        type: String, // Cloudinary URL
      },
    ],
    replies: [
      {
        type: Schema.Types.ObjectId,
        ref: 'Reply',
      },
    ],
  },
  { timestamps: true }
);

answerSchema.methods.addUpvote = async function () {
  this.upvotes += 1;
  await this.save();

  const user = await User.findById(this.answeredBy);
  if (user) {
    user.totalUpvotes += 1;
    await user.save();
  }
};

const Answer = mongoose.model('Answer', answerSchema);

export default Answer;
