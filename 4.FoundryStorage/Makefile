# Definir variables
FORGE=forge
CAST=cast
SRC_DIR=src
TEST_DIR=test
BUILD_DIR=out

# URLs de RPC
ANVIL_RPC_URL=http://127.0.0.1:8545
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/wzGBXeC2MExNDcvya2LZ9kZgtm7Asrm5
ZKSYNC_RPC_URL=https://eth-zksync.alchemyapi.io/v2/

# Directorio del keystore
KEYSTORE_DIR=~/.foundry/keystores

# Archivos de keystore
ANVIL_KEYSTORE_FILE=Test_Anvil
SEPOLIA_KEYSTORE_FILE=Test_Sepolia
ZKSYNC_KEYSTORE_FILE=Test_ZkSync

# Directorio y archivo del script
SCRIPT_DIR=script
SCRIPT_FILE=DeployStorage.s.sol

# Contrato a desplegar
DEPLOY_CONTRACT=DeployStorage

# Definir objetivos
.PHONY: all build test clean deploy-anvil deploy-sepolia deploy-zksync

# Objetivo por defecto: compilar y ejecutar pruebas
all: build test

# Compilar contratos
build:
	$(FORGE) build

# Ejecutar pruebas
test:
	$(FORGE) test

# Limpiar archivos generados
clean:
	rm -rf $(BUILD_DIR)

# Desplegar contratos utilizando forge script para Anvil
deploy-anvil:
	$(FORGE) script $(SCRIPT_DIR)/$(SCRIPT_FILE):$(DEPLOY_CONTRACT) --rpc-url $(ANVIL_RPC_URL) --keystore $(KEYSTORE_DIR)/$(ANVIL_KEYSTORE_FILE) --broadcast -vvvv

# Desplegar contratos utilizando forge script para Sepolia
deploy-sepolia:
	$(FORGE) script $(SCRIPT_DIR)/$(SCRIPT_FILE):$(DEPLOY_CONTRACT) --rpc-url $(SEPOLIA_RPC_URL) --keystore $(KEYSTORE_DIR)/$(SEPOLIA_KEYSTORE_FILE) --broadcast -vvvv

# Desplegar contratos utilizando forge script para zkSync
deploy-zksync:
	$(FORGE) script $(SCRIPT_DIR)/$(SCRIPT_FILE):$(DEPLOY_CONTRACT) --rpc-url $(ZKSYNC_RPC_URL) --keystore $(KEYSTORE_DIR)/$(ZKSYNC_KEYSTORE_FILE) --broadcast -vvvv

