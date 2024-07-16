const { ethers } = require('ethers');
const { loadPrivateKey } = require('./persistWallet');

const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');

function loadWalletFromStorage(password) {
  const privateKey = loadPrivateKey(password);
  if (!privateKey) {
    console.log('No private key found in storage.');
    return null;
  }

  const wallet = new ethers.Wallet(privateKey).connect(provider);
  console.log(`Address: ${wallet.address}`);
  return wallet;
}

module.exports = loadWalletFromStorage;
