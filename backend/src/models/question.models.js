import mongoose from 'mongoose';
const { Schema } = mongoose;

const questionSchema = new Schema(
  {
    content: {
      type: String,
      required: true,
    },
    owner: {
      type: Schema.Types.ObjectId,
      ref: 'User',
    },
    images: [
      {
        type: String, // Cloudinary URL
      },
    ],
    subject: {
      type: String, // Changed from ObjectId reference to a string
      required: true,
    },
    classLevel: {
      type: String, // Changed from ObjectId reference to a string
      required: true,
    },
    answers: [{ type: Schema.Types.ObjectId, ref: 'Answer' }],
  },
  { timestamps: true }
);

const Question = mongoose.model('Question', questionSchema);

export default Question;
