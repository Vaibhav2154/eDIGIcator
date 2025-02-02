import cron from 'node-cron';
import twilio from 'twilio';
import { User } from '../models/user.model.js'; // Assuming user model contains studyTime, bedTime, etc.
import { MSG } from '../models/msg.model.js'; // Message schema for storing sent messages

const client = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);

// Helper function to send SMS
const sendSMS = async (mobileNumber, messageContent) => {
  try {
    await client.messages.create({
      body: messageContent,
      from: process.env.TWILIO_PHONE_NUMBER,
      to: mobileNumber,
    });

    // Log the message in the database
    await MSG.create({ mobileNumber, msg_content: messageContent });
  } catch (error) {
    console.error('Error sending SMS:', error);
  }
};

const studyReminderMessage = (user) => {
  return `Hello ${user.fullName}, it's time to get back to your studies! Stay focused, you've got this! 📚`;
};

const wakeupMessage = (user) => {
  return `Good morning ${user.fullName}! Here's a day to shine brighter. Stay productive and motivated! 💪`;
};

const sendMessagesAutomatically = async () => {
  try {
    // Fetch users who have set studyTime or wakeUpTime
    const users = await User.find({ studyTime: { $exists: true }, bedTime: { $exists: true } });

    // Loop through users and check if it's time to send messages
    users.forEach(async (user) => {
      const now = new Date();
      const studyTime = new Date(user.studyTime);
      const wakeUpTime = new Date(user.bedTime); // Assuming wakeup time is based on bedtime, adjust as needed

      // Check if the current time matches studyTime
      if (
        now.getHours() === studyTime.getHours() &&
        now.getMinutes() === studyTime.getMinutes()
      ) {
        const studyMessage = studyReminderMessage(user);
        await sendSMS(user.mobile, studyMessage);
      }

      // Check if the current time matches wakeup time
      if (
        now.getHours() === wakeUpTime.getHours() &&
        now.getMinutes() === wakeUpTime.getMinutes()
      ) {
        const wakeupMsg = wakeupMessage(user);
        await sendSMS(user.mobile, wakeupMsg);
      }
    });
  } catch (error) {
    console.error('Error in sendMessagesAutomatically:', error);
  }
};

cron.schedule('* * * * *', sendMessagesAutomatically);

export { sendMessagesAutomatically };
