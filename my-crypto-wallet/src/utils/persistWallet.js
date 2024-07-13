// src/utils/persistWallet.js
import CryptoJS from 'crypto-js';

function encrypt(data, password) {
  return CryptoJS.AES.encrypt(data, password).toString();
}

function decrypt(data, password) {
  const bytes = CryptoJS.AES.decrypt(data, password);
  return bytes.toString(CryptoJS.enc.Utf8);
}

function savePrivateKey(privateKey, password) {
  const encryptedKey = encrypt(privateKey, password);
  localStorage.setItem('encryptedPrivateKey', encryptedKey);
}

function loadPrivateKey(password) {
  const encryptedKey = localStorage.getItem('encryptedPrivateKey');
  if (!encryptedKey) {
    return null;
  }
  return decrypt(encryptedKey, password);
}

export { savePrivateKey, loadPrivateKey };
