const { ethers } = require('ethers');

// Configurar el proveedor para conectar a Ganache
const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');

// Clave privada de una cuenta preconfigurada de Ganache con suficientes fondos
const senderPrivateKey = '0xa30f74765381093ee341e0980759e5a19cc077405f200d421201c42d0c05fce8';
const senderWallet = new ethers.Wallet(senderPrivateKey, provider);

// Dirección de la wallet creada
const receiverAddress = '0x7daE8782878B3129784167cBDC42daC67bE30B8d'; // Dirección de la wallet creada

async function sendTransaction() {
  const tx = {
    to: receiverAddress,
    value: ethers.utils.parseEther('1.0'), // 1 ETH
    gasLimit: 21000,
    gasPrice: ethers.utils.parseUnits('10', 'gwei')
  };

  const transaction = await senderWallet.sendTransaction(tx);
  await transaction.wait(); // Esperar a que la transacción sea minada
  console.log(`Transaction Hash: ${transaction.hash}`);
}

sendTransaction();
