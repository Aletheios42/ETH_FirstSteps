import React, { useState, useEffect } from 'react';
import { checkBalance } from '../utils/checkBalance';
import { sendTransaction } from '../utils/sendTransaction';

const WalletManager = ({ wallet }) => {
  const [balance, setBalance] = useState('');
  const [recipient, setRecipient] = useState('');
  const [amount, setAmount] = useState('');
  const [status, setStatus] = useState('');

  useEffect(() => {
    fetchBalance();
  }, [wallet]);

  const fetchBalance = async () => {
    if (!wallet) return;
    try {
      const balance = await checkBalance(wallet.address, 'http://localhost:8545'); // Cambia a tu proveedor
      setBalance(balance);
    } catch (error) {
      setStatus(`Error fetching balance: ${error.message}`);
    }
  };

  const handleSendTransaction = async () => {
    if (!wallet || !recipient || !amount) return;
    try {
      const txHash = await sendTransaction(wallet.privateKey, recipient, amount, 'http://localhost:8545'); // Cambia a tu proveedor
      setStatus(`Transaction successful with hash: ${txHash}`);
      fetchBalance(); // Actualiza el saldo después de enviar la transacción
    } catch (error) {
      setStatus(`Transaction failed: ${error.message}`);
    }
  };

  return (
    <div>
      <h2>Wallet Manager</h2>
      <p>Address: {wallet.address}</p>
      <p>Balance: {balance} ETH</p>
      <div>
        <h3>Send Transaction</h3>
        <input
          type="text"
          placeholder="Recipient Address"
          value={recipient}
          onChange={(e) => setRecipient(e.target.value)}
          id="recipient-address"
          name="recipient-address"
        />
        <input
          type="text"
          placeholder="Amount in ETH"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          id="amount"
          name="amount"
        />
        <button onClick={handleSendTransaction}>Send</button>
        {status && <p>{status}</p>}
      </div>
    </div>
  );
};

export default WalletManager;

