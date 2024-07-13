// src/hooks/useWallet.js
import { useState } from 'react';
import { ethers } from 'ethers';
import CryptoJS from 'crypto-js';
import { saveWalletToDB, loadWalletFromDB } from '../utils/indexedDB';

export function useWallet() {
  const [wallet, setWallet] = useState(null);
  const [balance, setBalance] = useState('');

  const createWallet = () => {
    const newWallet = ethers.Wallet.createRandom();
    const encryptedPrivateKey = CryptoJS.AES.encrypt(newWallet.privateKey, 'your_password').toString();
    saveWalletToDB({ address: newWallet.address, privateKey: encryptedPrivateKey });
    setWallet(newWallet);
  };

  const loadWallet = (address) => {
    loadWalletFromDB(address, (loadedWallet) => {
      if (loadedWallet) {
        const decryptedPrivateKey = CryptoJS.AES.decrypt(loadedWallet.privateKey, 'your_password').toString(CryptoJS.enc.Utf8);
        const walletInstance = new ethers.Wallet(decryptedPrivateKey);
        setWallet(walletInstance);
      }
    });
  };

  const getBalance = async () => {
    if (!wallet) return;
    const provider = new ethers.providers.InfuraProvider('homestead', 'your_infura_project_id');
    const balance = await provider.getBalance(wallet.address);
    setBalance(ethers.utils.formatEther(balance));
  };

  const sendTransaction = async (to, amount) => {
    if (!wallet) return;
    const provider = new ethers.providers.InfuraProvider('homestead', 'your_infura_project_id');
    const transaction = {
      to,
      value: ethers.utils.parseEther(amount),
    };
    await wallet.connect(provider).sendTransaction(transaction);
  };

  return { wallet, balance, createWallet, loadWallet, getBalance, sendTransaction };
}
