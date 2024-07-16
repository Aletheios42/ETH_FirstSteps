import React, { useState } from 'react';
import { ethers } from 'ethers';
import { saveWalletToDB, loadWalletFromDB } from '../utils/indexedDB';
import CryptoJS from 'crypto-js';
import WalletManager from './WalletManager';
import RecoverWalletComponent from './RecoverWalletComponent';

function WalletComponent() {
  const [wallet, setWallet] = useState(null);
  const [address, setAddress] = useState('');
  const [showManager, setShowManager] = useState(false);
  const [showRecover, setShowRecover] = useState(false);

  const createWallet = () => {
    const newWallet = ethers.Wallet.createRandom();
    const encryptedPrivateKey = CryptoJS.AES.encrypt(newWallet.privateKey, 'your_password').toString();
    saveWalletToDB({ address: newWallet.address, privateKey: encryptedPrivateKey });
    setWallet(newWallet);
    setShowManager(true);
    console.log('Created wallet:', newWallet);
  };

  const loadWallet = (address) => {
    loadWalletFromDB(address, (loadedWallet) => {
      if (loadedWallet) {
        const decryptedPrivateKey = CryptoJS.AES.decrypt(loadedWallet.privateKey, 'your_password').toString(CryptoJS.enc.Utf8);
        const walletInstance = new ethers.Wallet(decryptedPrivateKey);
        setWallet(walletInstance);
        setShowManager(true);
        console.log('Loaded wallet:', walletInstance);
      } else {
        console.error('Wallet not found');
      }
    });
  };

  const recoverWallet = (mnemonic) => {
    try {
      const walletInstance = ethers.Wallet.fromMnemonic(mnemonic);
      const encryptedPrivateKey = CryptoJS.AES.encrypt(walletInstance.privateKey, 'your_password').toString();
      saveWalletToDB({ address: walletInstance.address, privateKey: encryptedPrivateKey });
      setWallet(walletInstance);
      setShowManager(true);
      console.log('Recovered wallet:', walletInstance);
    } catch (error) {
      console.error('Error recovering wallet:', error);
    }
  };

  return (
    <div>
      {!showManager ? (
        <div>
          <button onClick={createWallet}>Create Wallet</button>
          <input
            type="text"
            placeholder="Enter address to load wallet"
            value={address}
            onChange={(e) => setAddress(e.target.value)}
            id="load-wallet-address"
            name="load-wallet-address"
          />
          <button onClick={() => loadWallet(address)}>Load Wallet</button>
          <button onClick={() => setShowRecover(true)}>Recover Wallet</button>
          {showRecover && <RecoverWalletComponent recoverWallet={recoverWallet} />}
        </div>
      ) : (
        <WalletManager wallet={wallet} />
      )}
    </div>
  );
}

export default WalletComponent;

