// services/textbook.service.js
import { Configuration, OpenAIApi } from 'openai';
import { PDFDocument } from 'pdf-lib';
import axios from 'axios';

// Initialize OpenAI
const configuration = new Configuration({
    apiKey: process.env.OPENAI_API_KEY
});
const openai = new OpenAIApi(configuration);

// Extract text from PDF
async function extractTextFromPDF(pdfUrl) {
    try {
        const response = await axios.get(pdfUrl, { responseType: 'arraybuffer' });
        const pdfDoc = await PDFDocument.load(response.data);
        
        let fullText = '';
        for (let i = 0; i < pdfDoc.getPageCount(); i++) {
            const page = pdfDoc.getPage(i);
            const text = await page.getText();
            fullText += text + '\n';
        }
        return fullText;
    } catch (error) {
        console.error('Error extracting text from PDF:', error);
        throw new Error('Failed to extract text from PDF');
    }
}

// Chunk text into smaller pieces
function chunkText(text, chunkSize = 1000) {
    const chunks = [];
    let currentChunk = '';
    const sentences = text.split(/[.!?]+/);

    for (const sentence of sentences) {
        if ((currentChunk + sentence).length > chunkSize && currentChunk.length > 0) {
            chunks.push(currentChunk.trim());
            currentChunk = sentence;
        } else {
            currentChunk += sentence + '. ';
        }
    }
    if (currentChunk.length > 0) {
        chunks.push(currentChunk.trim());
    }
    return chunks;
}

// Calculate cosine similarity
function cosineSimilarity(vecA, vecB) {
    const dotProduct = vecA.reduce((sum, a, i) => sum + a * vecB[i], 0);
    const normA = Math.sqrt(vecA.reduce((sum, a) => sum + a * a, 0));
    const normB = Math.sqrt(vecB.reduce((sum, b) => sum + b * b, 0));
    return dotProduct / (normA * normB);
}

// Main service functions
export async function extractAndProcessText(textbookUrl, question) {
    try {
        // Extract and chunk text
        const textContent = await extractTextFromPDF(textbookUrl);
        const chunks = chunkText(textContent);

        // Create embeddings for question
        const questionEmbedding = await openai.createEmbedding({
            model: "text-embedding-ada-002",
            input: question
        });

        // Create embeddings for chunks
        const chunkEmbeddings = await Promise.all(chunks.map(async (chunk) => {
            const response = await openai.createEmbedding({
                model: "text-embedding-ada-002",
                input: chunk
            });
            return {
                chunk,
                embedding: response.data.data[0].embedding
            };
        }));

        // Find most relevant chunks
        const questionVector = questionEmbedding.data.data[0].embedding;
        const relevantChunks = chunkEmbeddings
            .map(({ chunk, embedding }) => ({
                chunk,
                similarity: cosineSimilarity(questionVector, embedding)
            }))
            .sort((a, b) => b.similarity - a.similarity)
            .slice(0, 3)
            .map(item => item.chunk);

        return relevantChunks;
    } catch (error) {
        throw new Error('Failed to process textbook: ' + error.message);
    }
}

export async function generateAnswer(question, relevantChunks, preferredLanguage) {
    try {
        const completion = await openai.createChatCompletion({
            model: 'gpt-4',
            messages: [
                {
                    role: 'system',
                    content: `You are a helpful teaching assistant. Answer questions based only on the provided textbook context. If the answer cannot be found in the context, say so. Respond in ${preferredLanguage}.`
                },
                {
                    role: 'user',
                    content: `Context:\n${relevantChunks.join('\n\n')}\n\nQuestion: ${question}`
                }
            ],
            max_tokens: 500,
            temperature: 0.7
        });

        return completion.data.choices[0].message;
    } catch (error) {
        throw new Error('Failed to generate answer: ' + error.message);
    }
}