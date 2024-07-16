const { ethers } = require('ethers');
const readline = require('readline');

// Configurar el proveedor para conectar a Ganache
const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545', {
  chainId: 1337,
  name: 'ganache'
});

// Configurar readline para entrada del usuario
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function askQuestion(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

async function checkWalletBalance() {
  const walletAddress = await askQuestion('Introduce la dirección de la wallet: ');
  
  try {
    const balance = await provider.getBalance(walletAddress.trim());
    console.log(`Balance of ${walletAddress.trim()}: ${ethers.utils.formatEther(balance)} ETH`);
  } catch (error) {
    console.error('Error:', error);
  } finally {
    rl.close();
  }
}

checkWalletBalance();
