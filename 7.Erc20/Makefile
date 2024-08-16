-include .env

.PHONY: all clean remove install update build test test-zk snapshot format anvil deploy deploy-sepolia deploy-zk deploy-zk-sepolia deploy-zk-bad verify

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
DEFAULT_ZKSYNC_LOCAL_KEY := 0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110

# Default target
all: clean remove install update build

# Clean the repo
clean:
	@forge clean

# Remove modules and clean up Git state
remove:
	@rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib
	@touch .gitmodules
	@git add . && git commit -m "Removed Git submodules and cleaned up"

# Install dependencies
install:
	@forge install cyfrin/foundry-devops@0.2.2 --no-commit
	@forge install foundry-rs/forge-std@v1.8.2 --no-commit
	@forge install openzeppelin/openzeppelin-contracts@v5.0.2 --no-commit

# Update dependencies
update:
	@forge update

# Build the project
build:
	@forge build

# Run tests
test:
	@forge test

# Run zkSync tests
test-zk:
	@foundryup-zksync
	@forge test --zksync
	@foundryup

# Create a snapshot
snapshot:
	@forge snapshot

# Format the code
format:
	@forge fmt

# Start the Anvil local Ethereum node
anvil:
	@anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

# Deploy contracts to local Ethereum node
deploy:
	@forge script script/DeployToken.s.sol:DeployToken \
		--rpc-url http://localhost:8545 \
		--private-key $(DEFAULT_ANVIL_KEY) \
		--broadcast
# Deploy contracts to Sepolia network using a deployment script
deploy-sepolia:
	@forge script script/DeployAnotherToken.s.sol:DeployAnotherToken \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--account $(ACCOUNT) \
		--sender $(SENDER) \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--broadcast --verify

# Deploy contracts to zkSync local network
deploy-zk:
	@forge create src/AnotherToken.sol:AnotherToken \
		--rpc-url http://127.0.0.1:8011 \
		--private-key $(DEFAULT_ZKSYNC_LOCAL_KEY) \
		--legacy --zksync

# Deploy contracts to zkSync Sepolia network
deploy-zk-sepolia:
	@forge create src/AnotherToken.sol:AnotherToken \
		--rpc-url $(ZKSYNC_SEPOLIA_RPC_URL) \
		--account $(ACCOUNT) \
		--legacy --zksync

# Deploy contracts to zkSync Sepolia network with incorrect RPC URL
deploy-zk-bad:
	@forge create src/AnotherToken.sol:AnotherToken \
		--rpc-url https://sepolia.era.zksync.dev \
		--private-key $(PRIVATE_KEY) \
		--legacy --zksync

# Verify the contract on Etherscan
verify:
	@forge verify-contract \
		--chain-id 11155111 \
		--num-of-optimizations 200 \
		--watch \
		--constructor-args 0x00000000000000000000000000000000000000000000d3c21bcecceda1000000 \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--compiler-version v0.8.19+commit.7dd6d404 \
		0x089dc24123e0a27d44282a1ccc2fd815989e3300 \
		src/AnotherToken.sol:AnotherToken

