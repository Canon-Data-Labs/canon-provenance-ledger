import * as StellarSdk from '@stellar/stellar-sdk';

const { Horizon, Keypair, TransactionBuilder, Networks, Operation, Asset, BASE_FEE } = StellarSdk;

const server = new Horizon.Server(process.env.STELLAR_HORIZON_URL || 'https://horizon-testnet.stellar.org');
const networkPassphrase = process.env.STELLAR_NETWORK === 'mainnet' ? Networks.PUBLIC : Networks.TESTNET;

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
        value: dataHash.slice(0, 64), // Stellar manageData value max 64 bytes
      })
    )
    .setTimeout(30)
    .build();

  tx.sign(keypair);
  return server.submitTransaction(tx);
}
