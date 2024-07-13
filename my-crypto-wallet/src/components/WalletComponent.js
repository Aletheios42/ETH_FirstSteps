// src/components/WalletComponent.js
import React, { useState } from 'react';
import { ethers } from 'ethers';
import { saveWalletToDB, loadWalletFromDB } from '../utils/indexedDB';
import CryptoJS from 'crypto-js';

function WalletComponent() {
  const [wallet, setWallet] = useState(null);
  const [address, setAddress] = useState('');

  const createWallet = () => {
    const newWallet = ethers.Wallet.createRandom();
    const encryptedPrivateKey = CryptoJS.AES.encrypt(newWallet.privateKey, 'your_password').toString();
    saveWalletToDB({ address: newWallet.address, privateKey: encryptedPrivateKey });
    setWallet(newWallet);
    console.log('Created wallet:', newWallet);
  };

  const loadWallet = (address) => {
    loadWalletFromDB(address, (loadedWallet) => {
      if (loadedWallet) {
        const decryptedPrivateKey = CryptoJS.AES.decrypt(loadedWallet.privateKey, 'your_password').toString(CryptoJS.enc.Utf8);
        const walletInstance = new ethers.Wallet(decryptedPrivateKey);
        setWallet(walletInstance);
        console.log('Loaded wallet:', walletInstance);
      } else {
        console.error('Wallet not found');
      }
    });
  };

  return (
    <div>
      <button onClick={createWallet}>Create Wallet</button>
      <input
        type="text"
        placeholder="Enter address to load wallet"
        value={address}
        onChange={(e) => setAddress(e.target.value)}
      />
      <button onClick={() => loadWallet(address)}>Load Wallet</button>
      {wallet && (
        <div>
          <p>Address: {wallet.address}</p>
          <p>Private Key: {wallet.privateKey}</p>
          <p>Mnemonic: {wallet.mnemonic.phrase}</p>
        </div>
      )}
    </div>
  );
}

export default WalletComponent;
