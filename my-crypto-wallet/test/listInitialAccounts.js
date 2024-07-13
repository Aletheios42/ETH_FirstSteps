const { ethers } = require('ethers');

// Configurar el proveedor para conectar a Ganache
const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');

async function listAccounts() {
  try {
    // Obtener todas las cuentas desde el proveedor
    const accounts = await provider.listAccounts();
    console.log('Cuentas disponibles en Ganache:');
    accounts.forEach((account, index) => {
      console.log(`Cuenta ${index + 1}: ${account}`);
    });
  } catch (error) {
    console.error('Error al listar las cuentas:', error);
  }
}

listAccounts();

