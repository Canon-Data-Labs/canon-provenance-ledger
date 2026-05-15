const BASE = '/api/provenance';

export async function registerData(data: string, secretKey: string) {
  const res = await fetch(`${BASE}/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ data, secretKey }),
  });
  if (!res.ok) throw new Error((await res.json()).error);
  return res.json() as Promise<{ hash: string; txHash: string; ledger: number }>;
}
