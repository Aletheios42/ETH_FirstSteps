import React, { useState } from 'react';
import { ethers } from 'ethers';

function WalletComponent() {
  const [wallet, setWallet] = useState(null);

  const createWallet = () => {
    const newWallet = ethers.Wallet.createRandom();
    setWallet(newWallet);
  };

  return (
    <div>
      <button onClick={createWallet}>Create Wallet</button>
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
