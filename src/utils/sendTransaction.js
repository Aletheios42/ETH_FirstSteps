// src/utils/sendTransaction.js
import { ethers } from 'ethers';

export async function sendTransaction(privateKey, toAddress, amount, providerUrl) {
  try {
    const provider = new ethers.providers.JsonRpcProvider(providerUrl);
    const wallet = new ethers.Wallet(privateKey, provider);

    const tx = {
      to: toAddress,
      value: ethers.utils.parseEther(amount),
      gasLimit: 21000,
      gasPrice: ethers.utils.parseUnits('10', 'gwei'),
    };

    const transaction = await wallet.sendTransaction(tx);
    await transaction.wait(); // Esperar a que la transacción sea minada

    return transaction.hash;
  } catch (error) {
    console.error('Error sending transaction:', error);
    throw new Error('Unable to send transaction');
  }
}
