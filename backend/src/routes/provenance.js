import { Router } from 'express';
import { createHash } from 'crypto';
import { submitDataHashTx, getAccountInfo, validateSecretKey } from '../services/stellar.js';

const router = Router();

// POST /api/provenance/register
// Body: { data: string, secretKey: string }
// NOTE: Sending a secret key to a backend is only safe over HTTPS in a trusted environment.
//       For production, sign the transaction client-side and submit the signed XDR instead.
router.post('/register', async (req, res) => {
  const { data, secretKey } = req.body;
  if (!data || !secretKey) return res.status(400).json({ error: 'data and secretKey required' });
  if (!validateSecretKey(secretKey)) return res.status(400).json({ error: 'invalid Stellar secret key' });

  const dataHash = createHash('sha256').update(data).digest('hex');

  try {
    const result = await submitDataHashTx(secretKey, dataHash);
    res.json({ hash: dataHash, txHash: result.hash, ledger: result.ledger });
  } catch (err) {
    // Avoid leaking SDK internals; log server-side, return generic message
    console.error('Stellar tx error:', err);
    const message = err?.response?.data?.extras?.result_codes
      ? JSON.stringify(err.response.data.extras.result_codes)
      : 'Transaction failed';
    res.status(500).json({ error: message });
  }
});

// GET /api/provenance/account/:publicKey
router.get('/account/:publicKey', async (req, res) => {
  try {
    const account = await getAccountInfo(req.params.publicKey);
    res.json({ id: account.id, sequence: account.sequence, balances: account.balances });
  } catch {
    res.status(404).json({ error: 'Account not found' });
  }
});

export default router;
