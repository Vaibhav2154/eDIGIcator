import axios from "axios";

const API_KEY = "e564ce89391e42ccb261b187d0971496 "; // Store API Key in .env file
const NEWS_API_URL = "https://newsapi.org/v2/top-headlines"; // News API URL

// ✅ 1️⃣ Fetch News by Category (Without Storing in DB)
export const getNewsByCategory = async (req, res) => {
  try {
    const { category } = req.params;

    // ✅ Valid Categories
    const validCategories = ["national", "external", "sports", "technology", "education"];
    if (!validCategories.includes(category)) {
      return res.status(400).json({ message: "Invalid category" });
    }

    // ✅ Fetch News from API
    const response = await axios.get(NEWS_API_URL, {
      params: {
        apiKey: API_KEY,
        country: "in", // India (Change as needed)
        category: category, // National, External, Sports, etc.
        pageSize: 10,
      },
    });

    res.status(200).json(response.data.articles); // Send API response to frontend
  } catch (error) {
    console.error(`❌ Error fetching ${category} news:`, error);
    res.status(500).json({ message: "Server error", error });
  }
};

// ✅ 2️⃣ Fetch News for All Categories
export const getAllNews = async (req, res) => {
  try {
    const categories = ["national", "external", "sports", "technology", "education"];
    const allNews = {};

    // Fetch news for each category
    for (const category of categories) {
      const response = await axios.get(NEWS_API_URL, {
        params: {
          apiKey: API_KEY,
          country: "in",
          category: category,
          pageSize: 5, // Reduce size for better performance
        },
      });

      allNews[category] = response.data.articles;
    }

    res.status(200).json(allNews);
  } catch (error) {
    console.error("❌ Error fetching all news:", error);
    res.status(500).json({ message: "Server error", error });
  }
};
