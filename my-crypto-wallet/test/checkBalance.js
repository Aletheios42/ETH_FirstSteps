const { ethers } = require('ethers');

// Configurar el proveedor para conectar a Ganache
const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');

// Dirección de la wallet creada
const walletAddress = ' 0x08194E0C190BA466d9c3Ed0b0C72ea7e009EDA85'; // Usa la dirección de la wallet creada desde tu aplicación

async function checkWalletBalance() {
  const balance = await provider.getBalance(walletAddress);
  console.log(`Balance of ${walletAddress}: ${ethers.utils.formatEther(balance)} ETH`);
}

checkWalletBalance();
