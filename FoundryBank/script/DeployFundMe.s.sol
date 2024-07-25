// SPDX License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {console} from "forge-std/console.sol";

contract DeployFundMe is Script {
	function run() external returns (FundMe) {
		//Before broadcasting --> NOT REAL TX
		HelperConfig helperConfig = new HelperConfig();
		address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
		console.log("ETH-USD Price Feed Address:", ethUsdPriceFeed);

		//After broadcasting --> REAL TX
		vm.startBroadcast();
		 console.log("Deploying FundMe from:", msg.sender);
		FundMe fundMe = new FundMe(ethUsdPriceFeed);
		vm.stopBroadcast();
		return fundMe;
	}
}
