import express from 'express';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import videoRouter from './routes/Video.routes.js';
import textRouter from './routes/TextBook.route.js';
import pypRouter from './routes/PreviousPaper.routes.js';
import userRouter from './routes/user.routes.js';
import questionRouter from './routes/question.routes.js';
// import answerRouter from './routes/answer.route.js';
// import replyRouter from './routes/reply.route.js';
import dotenv from 'dotenv';
dotenv.config();
const app = express();

// app.options('*', cors()); 
app.use(
  cors({
    origin: process.env.CORS_ORIGIN || 'http://localhost:5173',
    credentials: true,
    methods: ['GET', 'POST', 'PATCH', 'DELETE', 'OPTIONS'],
  })
);

app.use(express.json({ limit: '16kb' }));
app.use(express.urlencoded({ extended: true, limit: '16kb' }));
app.use(express.static('public'));
app.use(cookieParser());


app.use('/api/videos',videoRouter)
app.use('/api/textbook',textRouter)
app.use('/api/videos',videoRouter)
app.use('/api/pyp',pypRouter)
app.use('/api/users', userRouter);
app.use('/api/questions', questionRouter);
// app.use('/api/answers', answerRouter);
// app.use('/api/reply', replyRouter);

export default app
