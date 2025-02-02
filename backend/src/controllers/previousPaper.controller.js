import PreviousPaper from "../models/PreviousPaper.model.js";

// ✅ 1️⃣ Insert Default Previous Year Papers (Only if Empty)
export const insertDefaultPreviousPapers = async () => {
    try {
        const existingPapers = await PreviousPaper.find();
        if (existingPapers.length === 0) {
            await PreviousPaper.insertMany([
                // 8th Standard - Mathematics
                { class: 8, subject: "Mathematics", pdfUrl: "https://drive.google.com/file/d/1mpuY6GX5audvrWnGvUpKD5oG_2BWa9rm/view?usp=sharing" },
                // { class: 8, subject: "Mathematics", pdfUrl: "https://example.com/8th_math_paper2.pdf" },

                // 8th Standard - Science
                { class: 8, subject: "Science", pdfUrl: "https://drive.google.com/file/d/1ZxTXc3qXuuW0KV7JWFGCOI0pxKMAGsXT/view?usp=sharing" },
              
                // { class: 8, subject: "Science", pdfUrl: "https://example.com/8th_science_paper2.pdf" },
              {class:8,subject:"SocialScience",pdfUrl:"https://drive.google.com/file/d/1IfA57DlGQqQ0XIAUIa0WoIr63F3QLMmU/view?usp=sharing"}
               
            ]);
            console.log("✅ Default previous year papers inserted successfully!");
        } else {
            console.log("⚡ Previous year papers already exist, skipping insert.");
        }
    } catch (error) {
        console.error("❌ Error inserting previous year papers:", error);
    }
};

export const getPreviousPapersByClassAndSubject = async (req, res) => {
    try {
        const { classNumber, subject } = req.params;
        const previousPapers = await PreviousPaper.find({ class: classNumber, subject }).sort({ subject: 1 });

        if (previousPapers.length === 0) {
            return res.status(404).json({ message: "No previous papers found for this class and subject." });
        }

        // Return only the PDF URLs
        const pdfUrls = previousPapers.map(paper => paper.pdfUrl);

        res.status(200).json({ pdfUrls });
    } catch (error) {
        res.status(500).json({ message: "Server error", error });
    }
};

