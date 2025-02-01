import express from "express";
import { sendMessagesAutomatically } from "../controllers/sms.controller.js";
import { verifyUser } from "../middlewares/auth.middleware.js"; // Middleware to verify user authentication
import { verifyJWT } from "../middleware/auth.middleware.js";

const router = express.Router();

// ✅ 1️⃣ Manually Trigger SMS Notifications (For Testing)
router.post("/send-messages", verifyJWT, async (req, res) => {
  try {
    await sendMessagesAutomatically();
    res.status(200).json({ message: "SMS notifications triggered successfully!" });
  } catch (error) {
    res.status(500).json({ error: "Error triggering SMS notifications" });
  }
});

export default router;
