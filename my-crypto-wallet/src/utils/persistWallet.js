// Funciones de encriptación básica (no usar en producción)
function encrypt(data, password) {
    return btoa(data); // Simple encriptación para el ejemplo
  }
  
  function decrypt(data, password) {
    return atob(data); // Simple desencriptación para el ejemplo
  }
  
  // Guardar clave privada en localStorage
  function savePrivateKey(privateKey, password) {
    const encryptedKey = encrypt(privateKey, password);
    localStorage.setItem('encryptedPrivateKey', encryptedKey);
  }
  
  // Cargar clave privada de localStorage
  function loadPrivateKey(password) {
    const encryptedKey = localStorage.getItem('encryptedPrivateKey');
    if (!encryptedKey) {
      return null;
    }
    return decrypt(encryptedKey, password);
  }
  
  module.exports = { savePrivateKey, loadPrivateKey };
  