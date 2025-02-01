const express = require('express');
const axios = require('axios');
const { FaissIndexFlatL2 } = require('faiss-node');
const { Translate } = require('@google-cloud/translate').v2;
require('dotenv').config();

const app = express();
app.use(express.json());

// Initialize FAISS vector store
const vectorIndex = new FaissIndexFlatL2(512); // 512-dimensional embeddings

// Initialize Google Translate
const translate = new Translate({
  projectId: process.env.GOOGLE_CLOUD_PROJECT_ID,
  keyFilename: 'PATH_TO_SERVICE_ACCOUNT.json',
});

// Mock: Create embeddings (you can replace this with your own embedding logic)
const createEmbedding = async (text) => {
  // Simulate embedding generation
  return new Float32Array(512).fill(Math.random());
};

// Save text and its embedding to the FAISS vector store
const saveToVectorDB = async (text, fileId) => {
  const textChunks = splitTextIntoChunks(text, 500); // Split text into smaller chunks (500 characters max)
  for (const chunk of textChunks) {
    const embedding = await createEmbedding(chunk);
    vectorIndex.add(embedding); // Add the embedding to FAISS
  }
};

// Search the FAISS vector store
const queryVectorDB = async (query) => {
  const queryEmbedding = await createEmbedding(query);
  const { distances, indices } = vectorIndex.search(queryEmbedding, 5); // Top 5 results
  return indices.map((index) => vectorIndex.getItem(index));
};

// Translate text using Google Translate
const translateText = async (text, targetLanguage) => {
  try {
    const [translation] = await translate.translate(text, targetLanguage);
    return translation;
  } catch (error) {
    console.error('Error translating text:', error);
    return text; // Return the original text if translation fails
  }
};

// Chatbot Endpoint
app.post('/ask', async (req, res) => {
  try {
    const { question, preferredLanguage } = req.body;

    // Translate question to English if necessary
    const translatedQuestion =
      preferredLanguage && preferredLanguage !== 'en'
        ? await translateText(question, 'en')
        : question;

    // Query FAISS for the most relevant context
    const contextChunks = await queryVectorDB(translatedQuestion);

    // Construct prompt for OpenAI
    const prompt = `Answer the question based only on the following context:\n${contextChunks.join(
      '\n'
    )}\n\nQuestion: ${translatedQuestion}`;

    // Call OpenAI API for a response
    const response = await axios.post(
      'https://api.openai.com/v1/completions',
      {
        model: 'text-davinci-003',
        prompt: prompt,
        max_tokens: 200,
        temperature: 0.7,
      },
      {
        headers: {
          Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
        },
      }
    );

    // Translate the response back to the user's preferred language
    const translatedAnswer =
      preferredLanguage && preferredLanguage !== 'en'
        ? await translateText(response.data.choices[0].text.trim(), preferredLanguage)
        : response.data.choices[0].text.trim();

    res.json({ answer: translatedAnswer });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error generating response' });
  }
});

// Utility: Split text into smaller chunks
const splitTextIntoChunks = (text, maxChunkSize) => {
  const chunks = [];
  for (let i = 0; i < text.length; i += maxChunkSize) {
    chunks.push(text.substring(i, i + maxChunkSize));
  }
  return chunks;
};

// Server listening
const PORT = 3000;
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
