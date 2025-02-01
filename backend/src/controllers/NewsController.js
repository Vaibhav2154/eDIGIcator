import axios from 'axios';
import News from '../models/news.model.js';

// API Key for the News API (use environment variable or config file)
const API_KEY = process.env.NEWS_API_KEY; // Store your API key securely
const NEWS_API_URL = 'https://newsapi.org/v2/top-headlines'; // News API endpoint

// ✅ 1️⃣ Fetch and Store Latest News (From News API)
export const fetchAndStoreNews = async () => {
  try {
    // Fetch the latest news from the News API
    const response = await axios.get(NEWS_API_URL, {
      params: {
        apiKey: API_KEY,
        country: 'us', // You can change the country or use dynamic selection
        category: 'technology', // or 'education', 'farming', etc.
        pageSize: 10, // Number of news articles to fetch
      },
    });

    const newsArticles = response.data.articles;

    // Loop through the articles and save them to the database
    const newsData = newsArticles.map((article) => ({
      title: article.title,
      content: article.content,
      category: 'technology', // Static or dynamic based on your app needs
      source: article.url,
      language: article.language || 'en', // Use the article language or default
      publishedAt: new Date(article.publishedAt),
    }));

    // Insert the news data into the database (bulk insert)
    await News.insertMany(newsData);

    console.log('✅ News fetched and stored successfully!');
  } catch (error) {
    console.error('❌ Error fetching or storing news:', error);
  }
};

// ✅ 2️⃣ Get Latest News (From Database)
export const getLatestNews = async (req, res) => {
  try {
    // Fetch the news articles from the database
    const news = await News.find().sort({ publishedAt: -1 }).limit(10); // Fetch latest 10 articles

    if (news.length === 0) {
      return res.status(404).json({ message: 'No news found.' });
    }

    // Return the news articles as JSON
    res.status(200).json(news);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// ✅ 3️⃣ Get News by Category (Optional, to filter news by category)
export const getNewsByCategory = async (req, res) => {
  const { category } = req.params; // Extract category from request parameters (e.g., education, technology)
  
  try {
    // Fetch the news articles from the database filtered by category
    const news = await News.find({ category }).sort({ publishedAt: -1 }).limit(10);

    if (news.length === 0) {
      return res.status(404).json({ message: `No news found for category: ${category}` });
    }

    // Return the filtered news articles as JSON
    res.status(200).json(news);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};
