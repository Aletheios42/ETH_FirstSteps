const { ethers } = require('ethers');
const { savePrivateKey } = require('./persistWallet');

const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');

function createWallet(password) {
  const wallet = ethers.Wallet.createRandom().connect(provider);
  console.log(`Address: ${wallet.address}`);
  console.log(`Private Key: ${wallet.privateKey}`);
  console.log(`Mnemonic: ${wallet.mnemonic.phrase}`);
  
  // Guardar clave privada de manera segura
  savePrivateKey(wallet.privateKey, password);

  return wallet;
}

module.exports = createWallet;
