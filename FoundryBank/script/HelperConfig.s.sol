// SPDX License-Identifier

//1. Deploy mocs when we are on local anvil chain
//2. Keep track of contract address acroos diferrent chains
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
	//If we are on local anvil. we deploy mocks
	//otherwise, grab the existing addres fron the live network

	NetworkConfig public activeNetworkConfig;
	uint8 public constant DECIMALS = 8;
	int256 public constant INITIAL_PRICE = 2000e8;

	struct NetworkConfig {
		address priceFeed; //ETH-USD price
	}


	constructor() {
		if (block.chainid == 11155111) {
			activeNetworkConfig = getSepoliaEthConfig(); 
		}
		else {
			activeNetworkConfig = getAnvilEthConfig();
		}
	}

	function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
		NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
		 return sepoliaConfig;
	}

	function getAnvilEthConfig() public returns (NetworkConfig memory) {
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

