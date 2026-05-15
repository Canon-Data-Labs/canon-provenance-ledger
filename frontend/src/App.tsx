import { useState } from 'react';
import { registerData } from './api/provenance';

export default function App() {
  const [data, setData] = useState('');
  const [secretKey, setSecretKey] = useState('');
  const [result, setResult] = useState<{ hash: string; txHash: string; ledger: number } | null>(null);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError('');
    setResult(null);
    setLoading(true);
    try {
      const res = await registerData(data, secretKey);
      setResult(res);
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : 'Unknown error');
    } finally {
      setLoading(false);
    }
  }

  return (
    <main style={{ maxWidth: 600, margin: '60px auto', fontFamily: 'sans-serif', padding: '0 16px' }}>
      <h1>Canon Protocol</h1>
      <p style={{ color: '#666' }}>Register verified human data on the Stellar blockchain.</p>

      <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
        <textarea
          placeholder="Data to register (text, JSON, hash…)"
          value={data}
          onChange={e => setData(e.target.value)}
          rows={4}
          required
          style={{ padding: 8, fontSize: 14 }}
        />
        <input
          type="password"
          placeholder="Stellar secret key (S…)"
          value={secretKey}
          onChange={e => setSecretKey(e.target.value)}
          required
          style={{ padding: 8, fontSize: 14 }}
        />
        <p style={{ margin: 0, fontSize: 12, color: '#b45309', background: '#fef3c7', padding: '6px 10px', borderRadius: 4 }}>
          ⚠️ Only use this on a trusted, HTTPS-secured connection. Never enter your secret key on an untrusted site.
        </p>
        <button type="submit" disabled={loading} style={{ padding: '10px 20px', cursor: 'pointer' }}>
          {loading ? 'Registering…' : 'Register on Canon'}
        </button>
      </form>

      {error && <p style={{ color: 'red', marginTop: 16 }}>{error}</p>}

      {result && (
        <div style={{ marginTop: 24, background: '#f4f4f4', padding: 16, borderRadius: 6 }}>
          <h3 style={{ margin: '0 0 8px' }}>✓ Registered</h3>
          <p><strong>SHA-256:</strong> <code>{result.hash}</code></p>
          <p><strong>Tx Hash:</strong> <code>{result.txHash}</code></p>
          <p><strong>Ledger:</strong> {result.ledger}</p>
        </div>
      )}
    </main>
  );
}
