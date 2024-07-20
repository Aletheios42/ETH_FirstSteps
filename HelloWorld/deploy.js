const Web3 = require('web3');
const fs = require('fs');
const path = require('path');

// Conectar a Ganache
const web3 = new Web3('http://localhost:8545');

// Leer el bytecode y la ABI del contrato
const bytecode = fs.readFileSync(path.join(__dirname, 'build', 'HelloWorld.bin'), 'utf8');
const abi = JSON.parse(fs.readFileSync(path.join(__dirname, 'build', 'HelloWorld.abi'), 'utf8'));

// Función principal para desplegar el contrato
const deploy = async () => {
    try {
        // Obtener cuentas de Ganache
        const accounts = await web3.eth.getAccounts();

        // Crear la instancia del contrato
        const HelloWorld = new web3.eth.Contract(abi);

        // Desplegar el contrato
        const instance = await HelloWorld.deploy({
            data: '0x' + bytecode, // Asegúrate de prefijar con '0x'
        }).send({
            from: accounts[0],
            gas: 1500000, // Asegúrate de que esto sea suficiente para tu contrato
            gasPrice: '20000000000', // Gas price razonable
        });

        console.log('Contrato desplegado en la dirección:', instance.options.address);
    } catch (error) {
        console.error('Error en el despliegue:', error);
    }
};

deploy();

