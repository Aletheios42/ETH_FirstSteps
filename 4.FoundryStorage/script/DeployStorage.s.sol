// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import "../src/SimpleStorage.sol";

contract DeployStorage is Script {
	function run() external returns (SimpleStorage){
		vm.startBroadcast();
		SimpleStorage simpleStorage = new SimpleStorage();
		vm.stopBroadcast();
		return simpleStorage;
	}
}
