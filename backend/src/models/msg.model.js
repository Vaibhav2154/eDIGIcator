import mongoose from 'mongoose';

const msgSchema = new mongoose.Schema({
    mobileNumber: { type: String, required: true },
    msg_content: { type: String, required: true },
    createdAt: { type: Date, default: Date.now}
});

export const MSG= mongoose.model('MSG', msgSchema);
