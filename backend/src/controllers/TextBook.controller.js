import Textbook from "../models/textbook.model.js";

// ✅ 1️⃣ Insert Default Textbooks (Only if Empty)
export const insertDefaultTextbooks = async () => {
    try {
        const existingTextbooks = await Textbook.find();
        if (existingTextbooks.length === 0) {
            await Textbook.insertMany([
                // 8th Standard - Mathematics
                { class: 8, subject: "Mathematics", title: "Mathematics Part 1", textbookUrl: "https://drive.google.com/file/d/19SvsZiyCYV-Z4yeKd4vE4yGS1bAjnAzC/view?usp=sharing" },
                { class: 8, subject: "Mathematics", title: "Mathematics Part 2", textbookUrl: "https://drive.google.com/file/d/1D2PtWOMADAySwcsl-HmLwhH6SskgwV36/view?usp=drive_link" },

                // 8th Standard - Science
                { class: 8, subject: "Science", title: "Fundamentals of Biology", textbookUrl: "https://drive.google.com/file/d/1h3kTQeDTz5WFruRfPZCbJk3fXBNaZ8h7/view?usp=drive_link" },
                { class: 8, subject: "Science", title: "Introduction to Physics", textbookUrl: "https://drive.google.com/file/d/1Jllzq5L4fJLBA1sQ9ckGV562rZquaQY9/view?usp=drive_link" },

                // 8th Standard - Social Science
                { class: 8, subject: "SocialScience", title: "History & Civics", textbookUrl: "https://drive.google.com/file/d/1Oz3vU5P0ij0jmHSKNd-cwp9VG3mhjOLt/view?usp=drive_link" },
                { class: 8, subject: "SocialScience", title: "Geography", textbookUrl: "https://drive.google.com/file/d/1Z7t0g0X_5MM7ZvJNQkUIG21f3gKTL7hD/view?usp=drive_link" },

                // 10th Standard - Science
                { class: 10, subject: "Science", title: "Classical Mechanics", textbookUrl: "https://drive.google.com/file/d/13MJoxZyZMhPB6eU5WzSR-S0lYXvf5xZq/view?usp=drive_link" },
                { class: 10, subject: "Science", title: "Electromagnetism", textbookUrl: "https://drive.google.com/file/d/1jIDRaiD9AKXhIagVbYuL2DtfhIhCFU5X/view?usp=drive_link" },

                // 10th Standard - Mathematics
                { class: 10, subject: "Mathematics", title: "Advanced Algebra", textbookUrl: "https://drive.google.com/file/d/1naZFbzfsUHy50Hk6ubvsFMFegmeCjcQw/view?usp=drive_link" },
                { class: 10, subject: "Mathematics", title: "Calculus Basics", textbookUrl: "https://drive.google.com/file/d/1vXfGb_Clbx0PxQkvbUdAA8ghp49q5qDX/view?usp=drive_link" },

                // 10th Standard - Social Science
                { class: 10, subject: "SocialScience", title: "Political Science", textbookUrl: "https://drive.google.com/file/d/1-cKldLoznzpm73rnjxRdSpblRUGKUjED/view?usp=drive_link" },
                { class: 10, subject: "SocialScience", title: "Economics", textbookUrl: "https://drive.google.com/file/d/1jsBTHW14Gfvv-_8Bd9TAwChcc2FVIMr1/view?usp=drive_link" },

                // 12th Standard - Chemistry
                { class: 12, subject: "Chemistry", title: "Organic Chemistry", textbookUrl: "https://example.com/chemistry12_1.pdf" },
                { class: 12, subject: "Chemistry", title: "Physical Chemistry", textbookUrl: "https://example.com/chemistry12_2.pdf" },

                // 12th Standard - Biology
                { class: 12, subject: "Biology", title: "Human Anatomy", textbookUrl: "https://example.com/biology12_1.pdf" },
                { class: 12, subject: "Biology", title: "Genetics & Evolution", textbookUrl: "https://example.com/biology12_2.pdf" }
            ]);
            console.log("✅ Default textbooks inserted successfully!");
        } else {
            console.log("⚡ Textbooks already exist, skipping insert.");
        }
    } catch (error) {
        console.error("❌ Error inserting default textbooks:", error);
    }
};

// ✅ 2️⃣ Fetch Textbooks by Class & Subject
export const getTextbooksByClassAndSubject = async (req, res) => {
    try {
        const { classNumber, subject } = req.params;
        const textbooks = await Textbook.find({ class: classNumber, subject }).sort({ title: 1 });

        if (textbooks.length === 0) {
            return res.status(404).json({ message: "No textbooks found for this class and subject." });
        }

        res.status(200).json(textbooks);
    } catch (error) {
        res.status(500).json({ message: "Server error", error });
    }
};
