import axios from 'axios';
import { FaissIndexFlatL2 } from 'faiss-node';
import { Translate } from '@google-cloud/translate';
import dotenv from 'dotenv';
import express from 'express';
import { queryVectorDB, saveToVectorDB } from '../services/vectorDB.js';
import { translateText } from '../utils/translate.js';
dotenv.config();

/*
const translateText = async (text, targetLanguage) => {
  try {
    const [translation] = await translate.translate(text, targetLanguage);
    return translation;
  } catch (error) {
    console.error('Error translating text:', error);
    return text; // Return the original text if translation fails
  }
};*/
const askChatbot = asyncHandler(async (req, res) => {
  try {
    const { question, preferredLanguage } = req.body;

    // Store the question in FAISS vector database
    await saveToVectorDB(question, 'question_' + Date.now());

    // Query FAISS for the most relevant context
    const contextChunks = await queryVectorDB(question);

    const prompt = `Answer the question based only on the following context:\n${contextChunks.join(
      '\n'
    )}\n\nQuestion: ${question}\n\nRespond in ${preferredLanguage}.`;

    // Call OpenAI API
    const { data } = await axios.post(
      'https://api.openai.com/v1/completions',
      {
        model: 'gpt-4',
        prompt,
        max_tokens: 200,
        temperature: 0.7,
      },
      {
        headers: {
          Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
        },
      }
    );

    res.json({ answer: data.choices[0].text.trim() });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error generating response' });
  }
});

export { askChatbot };
