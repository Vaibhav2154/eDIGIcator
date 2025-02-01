import mongoose from "mongoose";
const {Schema}= mongoose;
const replySchema= new mongoose.Schema(
   {
    content: {
        type: String,
        required:true
    },
    createdBy: {
        type: Schema.Types.ObjectId,
        ref:"User"
    },
    answer: {
        type: Schema.Types.ObjectId,
        ref: "Answer"
    }
   },{timestamps:true} 
)

export const Reply= new mongoose.model("Reply", replySchema);