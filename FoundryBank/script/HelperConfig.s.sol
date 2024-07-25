// SPDX License-Identifier

//1. Deploy mocs when we are on local anvil chain
//2. Keep track of contract address acroos diferrent chains
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
	//If we are on local anvil. we deploy mocks
	//otherwise, grab the existing addres fron the live network

	NetworkConfig public activeNetworkConfig;

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
	 }

	function getAnvilEthConfig() public pure  returns (NetworkConfig memory){

	}
}

