const { ethers } = require('ethers');
const sqlite3 = require('sqlite3').verbose();

// Configurar el proveedor para conectar a Ganache
const provider = new ethers.providers.JsonRpcProvider('http://localhost:8545');

// Configurar la base de datos
const db = new sqlite3.Database(':memory:');

db.serialize(() => {
  db.run("CREATE TABLE accounts (address TEXT PRIMARY KEY, balance TEXT)");

  provider.on('block', async (blockNumber) => {
    console.log(`Nuevo bloque minado: ${blockNumber}`);
    const block = await provider.getBlockWithTransactions(blockNumber);

    for (const tx of block.transactions) {
      try {
        const fromBalance = await provider.getBalance(tx.from);
        const toBalance = await provider.getBalance(tx.to);

        console.log(`Procesando transacción de ${tx.from} a ${tx.to}`);

        db.run(`INSERT OR REPLACE INTO accounts (address, balance) VALUES (?, ?)`, [tx.from, fromBalance.toString()]);
        db.run(`INSERT OR REPLACE INTO accounts (address, balance) VALUES (?, ?)`, [tx.to, toBalance.toString()]);
      } catch (error) {
        console.error('Error procesando la transacción:', error);
      }
    }
  });
});

// Función para consultar el saldo de una cuenta
function getBalance(address) {
  db.get(`SELECT balance FROM accounts WHERE address = ?`, [address], (err, row) => {
    if (err) {
      console.error(err.message);
    }
    console.log(`Saldo de ${address}: ${row ? ethers.utils.formatEther(row.balance) + ' ETH' : '0 ETH'}`);
  });
}

module.exports = { getBalance };

