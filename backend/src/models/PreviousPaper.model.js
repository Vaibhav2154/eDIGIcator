import mongoose from 'mongoose';

const PreviousPaperSchema = new mongoose.Schema({
  subject: { type: mongoose.Schema.Types.ObjectId, ref: "Subject", required: true },
  class: { type: Number, required: true },
  pdfUrl: { type: String, required: true } // Link to the previous year paper PDF
});

export default mongoose.model('PreviousPaper', PreviousPaperSchema);
