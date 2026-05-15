import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import provenanceRouter from './routes/provenance.js';

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

app.get('/health', (_req, res) => res.json({ status: 'ok', service: 'canon-backend' }));
app.use('/api/provenance', provenanceRouter);

app.listen(PORT, () => console.log(`Canon backend running on :${PORT}`));
