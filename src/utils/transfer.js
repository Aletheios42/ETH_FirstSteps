const { ethers } = require('ethers');

// Configurar el proveedor para conectar a Ganache
const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');

async function sendTransaction(wallet, toAddress, amount) {
  const tx = {
    to: toAddress,
    value: ethers.utils.parseEther(amount),
    gasLimit: 21000,
    gasPrice: ethers.utils.parseUnits('10', 'gwei')
  };

  const transaction = await wallet.sendTransaction(tx);
  console.log(`Transaction Hash: ${transaction.hash}`);
}

module.exports = sendTransaction;
