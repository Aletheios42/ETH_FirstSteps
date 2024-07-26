// SPDX License-Identifier

//1. Deploy mocs when we are on local anvil chain
//2. Keep track of contract address acroos diferrent chains
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";



abstract contract CodeConstants {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;


    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
}

error HelperConfig__InvalidChainId();


contract HelperConfig is CodeConstants, Script {
	//If we are on local anvil. we deploy mocks
	//otherwise, grab the existing addres fron the live network

	NetworkConfig public activeNetworkConfig;
	 mapping(uint256 chainId => NetworkConfig) public networkConfigs;


	struct NetworkConfig {
		address priceFeed; //ETH-USD price
	}


	constructor() {
        networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getSepoliaEthConfig();
    }

	  function getConfigByChainId(uint256 chainId) public returns (NetworkConfig memory) {
        if (networkConfigs[chainId].priceFeed != address(0)) {
            return networkConfigs[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateAnvilEthConfig();
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }


	function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
		NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
		 return sepoliaConfig;
	}

	function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
		if (activeNetworkConfig.priceFeed != address(0)) {
			return activeNetworkConfig;
		}

		vm.startBroadcast();
		MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
		vm.stopBroadcast();

		NetworkConfig memory anvilConfig = NetworkConfig({
			priceFeed: address(mockPriceFeed)
		});
		return anvilConfig;
	}
}

