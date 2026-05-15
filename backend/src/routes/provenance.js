import { Router } from 'express';
import { createHash } from 'crypto';
import { submitDataHashTx, getAccountInfo } from '../services/stellar.js';

const router = Router();

// POST /api/provenance/register
// Body: { data: string, secretKey: string }
router.post('/register', async (req, res) => {
  const { data, secretKey } = req.body;
  if (!data || !secretKey) return res.status(400).json({ error: 'data and secretKey required' });

  const dataHash = createHash('sha256').update(data).digest('hex');

  try {
    const result = await submitDataHashTx(secretKey, dataHash);
    res.json({ hash: dataHash, txHash: result.hash, ledger: result.ledger });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /api/provenance/account/:publicKey
router.get('/account/:publicKey', async (req, res) => {
  try {
    const account = await getAccountInfo(req.params.publicKey);
    res.json({ id: account.id, sequence: account.sequence, balances: account.balances });
  } catch (err) {
    res.status(404).json({ error: 'Account not found' });
  }
});

export default router;
