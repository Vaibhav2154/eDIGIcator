import express from "express";
import { fetchAllCategoriesNews, getNewsByCategory } from "../controllers/news.controller.js";

const router = express.Router();

// ✅ Fetch news for all categories (National, External, Sports, etc.)
router.get("/fetch-news", fetchAllCategoriesNews);

// ✅ Get news by category (e.g., National, External, Sports)
router.get("/:category", getNewsByCategory);

export default router;
