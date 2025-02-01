import { 
  extractAndProcessText, 
  generateAnswer 
} from '../services/vectorDB.js';

export const askChatbot = async (req, res) => {
  try {
      const { textbookUrl, question, preferredLanguage = 'English' } = req.body;

      if (!textbookUrl) {
          return res.status(400).json({ error: 'Textbook URL is required' });
      }

      if (!question) {
          return res.status(400).json({ error: 'Question is required' });
      }

      // Process textbook and get relevant chunks
      const relevantChunks = await extractAndProcessText(textbookUrl, question);

      // Generate answer using the relevant chunks
      const answer = await generateAnswer(question, relevantChunks, preferredLanguage);

      res.json({ 
          answer: answer.content,
          contextUsed: relevantChunks.length
      });

  } catch (error) {
      console.error('Error processing request:', error);
      res.status(500).json({ 
          error: 'Error processing request',
          message: error.message 
      });
  }
};