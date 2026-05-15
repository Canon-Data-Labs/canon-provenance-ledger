import * as StellarSdk from '@stellar/stellar-sdk';

const { Horizon, Keypair, TransactionBuilder, Networks, Operation, BASE_FEE } = StellarSdk;

const server = new Horizon.Server(process.env.STELLAR_HORIZON_URL || 'https://horizon-testnet.stellar.org');
const networkPassphrase = process.env.STELLAR_NETWORK === 'mainnet' ? Networks.PUBLIC : Networks.TESTNET;

export function validateSecretKey(secretKey) {
  try {
    Keypair.fromSecret(secretKey);
    return true;
  } catch {
    return false;
  }
}

export async function getAccountInfo(publicKey) {
  return server.loadAccount(publicKey);
}

export async function submitDataHashTx(secretKey, dataHash) {
  const keypair = Keypair.fromSecret(secretKey);
  const account = await server.loadAccount(keypair.publicKey());

  const tx = new TransactionBuilder(account, {
    fee: BASE_FEE,
    networkPassphrase,
  })
    .addOperation(
      Operation.manageData({
        name: 'canon:hash',
        // manageData value must be a Buffer (up to 64 bytes); hex SHA-256 is exactly 64 ASCII bytes
        value: Buffer.from(dataHash),
      })
    )
    .setTimeout(30)
    .build();

  tx.sign(keypair);
  return server.submitTransaction(tx);
}
