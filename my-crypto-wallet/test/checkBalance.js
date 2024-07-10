const { ethers } = require('ethers');

// Configurar el proveedor para conectar a Ganache
const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');

// Dirección de la wallet creada
const walletAddress = '0x7daE8782878B3129784167cBDC42daC67bE30B8d'; // Usa la dirección de la wallet creada desde tu aplicación

async function checkWalletBalance() {
  const balance = await provider.getBalance(walletAddress);
  console.log(`Balance of ${walletAddress}: ${ethers.utils.formatEther(balance)} ETH`);
}

checkWalletBalance();
