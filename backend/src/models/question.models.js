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
    relatedTags: [
      {
        type: Schema.Types.ObjectId,
        ref: 'Tag',
        required: [true, 'Related tags must be specified'],
      },
    ],
    answers: [{ type: Schema.Types.ObjectId, ref: 'Answer' }],
  },
  { timestamps: true }
);

const Question = mongoose.model('Question', questionSchema);

export default Question;
