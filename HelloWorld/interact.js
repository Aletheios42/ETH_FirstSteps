const Web3 = require('web3');
const fs = require('fs');
const path = require('path');

// Conectar a Ganache
const web3 = new Web3('http://localhost:8545');

// Leer la ABI del contrato
const abi = JSON.parse(fs.readFileSync(path.join(__dirname, 'build', 'HelloWorld.abi')).toString());

// Dirección del contrato desplegado (reemplaza esto con la dirección real)
const contractAddress = '0x...'; // Dirección del contrato desplegado

// Crear la instancia del contrato
const HelloWorld = new web3.eth.Contract(abi, contractAddress);

// Función principal para interactuar con el contrato
const interact = async () => {
    // Leer el saludo
    const greeting = await HelloWorld.methods.greet().call();
    console.log('Saludo del contrato:', greeting);
};

interact();

