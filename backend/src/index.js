import dotenv from "dotenv";
import connectDB from "./utils/db.connect.js";
import app from "./app.js";

dotenv.config({
    path: "./.env"
});

//console.log('Cloudinary Config:', process.env.CLOUDINARY_CLOUD_NAME);

const PORT = process.env.PORT || 3000;

connectDB()
.then(() => {
    app.listen(PORT, () => {
        console.log(`⚙️ Server is running at port : ${PORT}`);
    })
})
.catch((err) => {
    console.log("MONGO db connection failed !!! ", err);
})