//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {DecentralizedStableCoin} from "../src/DecentralizedStableCoin.sol";
import {DSCEngine} from "../src/DSCEngine.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployDsc is Script {
    address[] public tokenAddreses;
    address[] public priceFeedAddresses;

    function run() external returns (DecentralizedStableCoin, DSCEngine) {
        HelperConfig config = new HelperConfig();
        (
            address wethUsdPriceFeed,
            address wbtcUsdPriceFeed,
            address weth,
            address wbtc,
            uint256 deployerKey
        ) = config.activeNetworkConfig();

        tokenAddreses = [weth, wbtc];
        priceFeedAddresses = [wethUsdPriceFeed, wbtcUsdPriceFeed];

        vm.startBroadcast();
        DecentralizedStableCoin dsc = new DecentralizedStableCoin();
        DSCEngine engine = new DSCEngine(
            tokenAddreses,
            priceFeedAddresses,
            address(dsc)
        );

        dsc.tranferOwnership(address(engine));
        vm.stopBroadcast();
    }
}
