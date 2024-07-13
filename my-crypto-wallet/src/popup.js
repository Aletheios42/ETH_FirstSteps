// src/popup.js
import React, { useState } from 'react';
import ReactDOM from 'react-dom';
import { useWallet } from './hooks/useWallet';

const App = () => {
  const { wallet, balance, createWallet, loadWallet, getBalance, sendTransaction } = useWallet();
  const [address, setAddress] = useState('');

  return (
    <div>
      <h1>My Wallet</h1>
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
          <button onClick={getBalance}>Get Balance</button>
          {balance && <p>Balance: {balance} ETH</p>}
          <button onClick={() => sendTransaction('recipient_address', '0.01')}>Send Transaction</button>
        </div>
      )}
    </div>
  );
};

ReactDOM.render(<App />, document.getElementById('root'));
