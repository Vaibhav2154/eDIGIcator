import Video from "../models/Video.model.js";
export const insertDefaultVideos = async () => {
    try {
        const videos = [
            // 8th Standard - Mathematics
            { class: 8, subject: "Mathematics", module: 1, title: "Rational Number", videoUrl: "https://www.youtube.com/watch?v=877YmPOZxhU" },
            { class: 8, subject: "Mathematics", module: 2, title: "Linear Equations", videoUrl: "https://www.youtube.com/watch?v=7_EtyPwzW_g" },
            { class: 8, subject: "Mathematics", module: 3, title: "Understanding Quadrilateral", videoUrl: "https://www.youtube.com/watch?v=PQ-jou752y4" },
            { class: 8, subject: "Mathematics", module: 4, title: "Practical Geometry", videoUrl: "https://www.youtube.com/watch?v=bHioYtzllck" },
            { class: 8, subject: "Mathematics", module: 5, title: "Data Handling", videoUrl: "https://www.youtube.com/watch?v=mPUQjcSMHPY" },

            // 8th Standard - Science
            { class: 8, subject: "Science", module: 1, title: "Crop Production", videoUrl: "https://www.youtube.com/watch?v=31Xglzp-Eec" },
            { class: 8, subject: "Science", module: 2, title: "Microorganisms: Friend and Foe", videoUrl: "https://www.youtube.com/watch?v=3wpxY7iAbOE" },

            // 10th Standard - Physics
            { class: 10, subject: "Physics", module: 1, title: "Electricity", videoUrl: "https://www.youtube.com/watch?v=BcQgUBjRVGY" },
            { class: 10, subject: "Physics", module: 2, title: "Light Reflection", videoUrl: "https://www.youtube.com/watch?v=E846yK7YmEA" },
            { class: 10, subject: "Physics", module: 3, title: "Magnetism", videoUrl: "https://www.youtube.com/watch?v=bz6fJGdVwnM" },

            // 10th Standard - Mathematics
            { class: 10, subject: "Mathematics", module: 1, title: "Real Numbers", videoUrl: "https://www.youtube.com/watch?v=YryVZxHAMTU" },
            { class: 10, subject: "Mathematics", module: 2, title: "Polynomials", videoUrl: "https://www.youtube.com/watch?v=ghIGnFA_QxU" },

            // 12th Standard - Physics
            { class: 12, subject: "Physics", module: 1, title: "Electric Charges and Fields", videoUrl: "https://www.youtube.com/watch?v=obSCMxwSAes" },
            { class: 12, subject: "Physics", module: 2, title: "Ray Optics", videoUrl: "https://www.youtube.com/watch?v=3ytasp0O7gU" },
            { class: 12, subject: "Physics", module: 3, title: "Moving Charges and Magnetism", videoUrl: "https://www.youtube.com/watch?v=aVpfgTbzQsE" },

            // 12th Standard - Mathematics
            { class: 12, subject: "Mathematics", module: 1, title: "Relations and Functions", videoUrl: "https://www.youtube.com/watch?v=VFdI01EytCw" },
            { class: 12, subject: "Mathematics", module: 2, title: "Vector Algebra", videoUrl: "https://www.youtube.com/watch?v=UBrtDRGr2ck" },
            { class: 12, subject: "Mathematics", module: 3, title: "Integration", videoUrl: "https://www.youtube.com/watch?v=FAGRsOJY-mE" },

            // 12th Standard - Chemistry
            { class: 12, subject: "Chemistry", module: 1, title: "Electrochemistry", videoUrl: "https://www.youtube.com/watch?v=7jfCJ2pZE6Y" },
            { class: 12, subject: "Chemistry", module: 2, title: "Alcohol, Phenol, and Ethers", videoUrl: "https://www.youtube.com/watch?v=IWCEfqnOCPs" },
            { class: 12, subject: "Chemistry", module: 3, title: "P-Block Elements", videoUrl: "https://www.youtube.com/watch?v=1xIop-9UBXI" },

            // 12th Standard - Biology
            { class: 12, subject: "Biology", module: 1, title: "Biodiversity and Conservation", videoUrl: "https://youtu.be/f17jAfDa-Ac" },
            { class: 12, subject: "Biology", module: 2, title: "Ecosystem", videoUrl: "https://www.youtube.com/watch?v=GrVf-x5m2ug" }
        ];

        // Loop through each video to insert only if it doesn't exist
        for (const video of videos) {
            const existingVideo = await Video.findOne({
                class: video.class,
                subject: video.subject,
                module: video.module,
                title: video.title
            });

            // Insert video only if it doesn't already exist
            if (!existingVideo) {
                await Video.create(video);
                console.log(`✅ Video inserted: ${video.title}`);
            } else {
                console.log(`⚡ Video already exists: ${video.title}`);
            }
        }

        console.log("✅ Default videos processed successfully!");

    } catch (error) {
        console.error("❌ Error inserting default videos:", error);
    }
};

export const getVideosByClassAndSubject = async (req, res) => {
    try {
      // Get parameters from the route (path params)
      const { classNumber, subject } = req.params;
      
      // Find the videos matching the class and subject
      const videos = await Video.find({ class: classNumber, subject: subject }).sort({ module: 1 });
  
      if (videos.length === 0) {
        return res.status(404).json({ message: "No videos found for this class and subject." });
      }
  
      res.status(200).json(videos);
    } catch (error) {
      res.status(500).json({ message: "Server error", error });
    }
  };
  