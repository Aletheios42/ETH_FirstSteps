// src/utils/indexedDB.js

export function saveWalletToDB(wallet) {
  const request = indexedDB.open('MyCryptoWalletDB', 1);

  request.onupgradeneeded = (event) => {
    const db = event.target.result;
    if (!db.objectStoreNames.contains('wallets')) {
      db.createObjectStore('wallets', { keyPath: 'address' });
    }
  };

  request.onsuccess = (event) => {
    const db = event.target.result;
    const transaction = db.transaction('wallets', 'readwrite');
    const store = transaction.objectStore('wallets');
    const addRequest = store.put(wallet);
    
    addRequest.onsuccess = () => {
      console.log('Wallet saved to IndexedDB:', wallet);
    };

    addRequest.onerror = (event) => {
      console.error('Error saving wallet to IndexedDB:', event.target.error);
    };
  };
}

// src/utils/indexedDB.js

export function loadWalletFromDB(address, callback) {
  const request = indexedDB.open('MyCryptoWalletDB', 1);

  request.onsuccess = (event) => {
    const db = event.target.result;
    const transaction = db.transaction('wallets', 'readonly');
    const store = transaction.objectStore('wallets');
    const walletRequest = store.get(address);

    walletRequest.onsuccess = (event) => {
      const wallet = event.target.result;
      if (wallet) {
        console.log('Wallet loaded from IndexedDB:', wallet);
        callback(wallet);
      } else {
        console.log('No wallet found for address:', address);
        callback(null);
      }
    };

    walletRequest.onerror = (event) => {
      console.error('Error loading wallet from IndexedDB:', event.target.error);
    };
  };
}
