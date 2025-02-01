import mongoose from 'mongoose'

const TextbookSchema = new mongoose.Schema({
  subject: { type: String, required: true },
  title: { type: String, required: true },
  textbookUrl: { type: String, required: true }, // Link to the textbook
  class:{type:Number,required:true}
});

export default mongoose.model("Textbook", TextbookSchema);