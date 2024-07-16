// src/utils/checkBalance.js
import { ethers } from 'ethers';

export async function checkBalance(address, providerUrl) {
  try {
    const provider = new ethers.providers.JsonRpcProvider(providerUrl);
    const balance = await provider.getBalance(address);
    return ethers.utils.formatEther(balance);
  } catch (error) {
    console.error('Error checking balance:', error);
    throw new Error('Unable to fetch balance');
  }
}
