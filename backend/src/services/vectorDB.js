// Correct method usage for OpenAI v4
import OpenAI from 'openai';
import axios from 'axios';

// Initialize OpenAI client
const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
    basePath: 'https://api.openai.com/v1' // Ensure the correct base path is used
});

// Function to extract text from PDF
async function extractTextFromPDF(pdfUrl) {
    try {
        console.log(`Sending request to Python service for PDF extraction: ${pdfUrl}`);
        const response = await axios.post('http://localhost:5001/extract-text', { pdfUrl });
        return response.data.text;
    } catch (error) {
        console.error('Error extracting text from PDF:', error.response?.data || error.message);
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
        const textContent = await extractTextFromPDF(textbookUrl);
        const chunks = chunkText(textContent);

        // Request embeddings for the question
        const questionEmbedding = await openai.embeddings.create({
            model: 'text-embedding-ada-002',
            input: question
        });

        // Request embeddings for the chunks
        const chunkEmbeddings = await Promise.all(chunks.map(async (chunk) => {
            const response = await openai.embeddings.create({
                model: 'text-embedding-ada-002',
                input: chunk
            });
            return {
                chunk,
                embedding: response.data.data[0].embedding
            };
        }));

        // Find most relevant chunks based on cosine similarity
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

// Function to generate an answer using GPT-4
export async function generateAnswer(question, relevantChunks, preferredLanguage) {
    try {
        const completion = await openai.chat.completions.create({
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

        return completion.choices[0].message.content;  // Correct way to extract the message
    } catch (error) {
        throw new Error('Failed to generate answer: ' + error.message);
    }
}
