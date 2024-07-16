import React, { useState } from 'react';

const RecoverWalletComponent = ({ recoverWallet }) => {
  const [mnemonic, setMnemonic] = useState('');

  const handleRecover = () => {
    recoverWallet(mnemonic);
  };

  return (
    <div>
      <h3>Recover Wallet</h3>
      <input
        type="text"
        placeholder="Enter your mnemonic phrase"
        value={mnemonic}
        onChange={(e) => setMnemonic(e.target.value)}
        id="mnemonic-phrase"
        name="mnemonic-phrase"
      />
      <button onClick={handleRecover}>Recover</button>
    </div>
  );
};

export default RecoverWalletComponent;

