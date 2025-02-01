import axios from "axios";
import News from "../models/News.model.js";

const API_KEY = "e564ce89391e42ccb261b187d0971496 "; // Store API Key in .env file
const NEWS_API_URL = "https://newsapi.org/v2/top-headlines"; // News API URL

// ✅ 1️⃣ Fetch and Store News Based on Category
export const fetchAndStoreNews = async (category) => {
  try {
    const response = await axios.get(NEWS_API_URL, {
      params: {
        apiKey: API_KEY,
        country: "in", // India (Change as needed)
        category: category, // National, External, Sports, etc.
        pageSize: 10,
      },
    });

    const newsArticles = response.data.articles;

    // Map API response to our database format
    const newsData = newsArticles.map((article) => ({
      title: article.title,
      content: article.description || "No description available.",
      category,
      source: article.url,
      publishedAt: new Date(article.publishedAt),
    }));

    // ✅ Store in MongoDB (optional)
    await News.insertMany(newsData);

    console.log(`✅ News for ${category} fetched and stored!`);
  } catch (error) {
    console.error(`❌ Error fetching ${category} news:`, error);
  }
};

// ✅ 2️⃣ Get News from Database by Category
export const getNewsByCategory = async (req, res) => {
  try {
    const { category } = req.params;
    
    // Check if the category is valid
    const validCategories = ["national", "external", "sports", "technology", "education"];
    if (!validCategories.includes(category)) {
      return res.status(400).json({ message: "Invalid category" });
    }

    // Fetch from database
    const news = await News.find({ category }).sort({ publishedAt: -1 }).limit(10);

    if (news.length === 0) {
      return res.status(404).json({ message: `No news found for category: ${category}` });
    }

    res.status(200).json(news);
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

// ✅ 3️⃣ Fetch Latest News for All Categories
export const fetchAllCategoriesNews = async (req, res) => {
  try {
    const categories = ["national", "external", "sports", "technology", "education"];

    for (const category of categories) {
      await fetchAndStoreNews(category);
    }

    res.status(200).json({ message: "News fetched and stored successfully for all categories!" });
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};
