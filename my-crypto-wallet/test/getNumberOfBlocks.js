const { ethers } = require('ethers');

// Configurar el proveedor para conectar a Ganache
const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');

async function getBlockNumber() {
  try {
    const blockNumber = await provider.getBlockNumber();
    console.log(`Número del último bloque: ${blockNumber}`);
  } catch (error) {
    console.error('Error al obtener el número de bloques:', error);
  }
}

getBlockNumber();

