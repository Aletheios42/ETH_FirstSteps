const { ethers } = require('ethers');
const readline = require('readline');

// Configurar el proveedor para conectar a Ganache
const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');

// Configurar readline para entrada del usuario
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function askQuestion(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

async function sendTransaction() {
  const senderPrivateKey = await askQuestion('Introduce la clave privada de la cuenta remitente: ');
  const receiverAddress = await askQuestion('Introduce la dirección de la cuenta receptora: ');
  const amount = await askQuestion('Introduce la cantidad a enviar (en ETH): ');

  // Crear el objeto de la billetera del remitente
  const senderWallet = new ethers.Wallet(senderPrivateKey.trim(), provider);

  const tx = {
    to: receiverAddress.trim(),
    value: ethers.utils.parseEther(amount.trim()), // Convertir la cantidad a ETH
    gasLimit: 21000,
    gasPrice: ethers.utils.parseUnits('10', 'gwei')
  };

  try {
    const transaction = await senderWallet.sendTransaction(tx);
    await transaction.wait(); // Esperar a que la transacción sea minada
    console.log(`Transaction Hash: ${transaction.hash}`);
  } catch (error) {
    console.error('Error:', error);
  } finally {
    rl.close();
  }
}

sendTransaction();
