//SPDX-License_Identifier

pragma solidity ^0.8.10;

import {Script} from "forge-std/Script.sol";
import {AnotherToken} from "../src/AnotherToken.sol";

contract DeployToken is Script {
    uint256 public constant INITIAL_SUPPLY = 100 ether;

    function run() external returns (AnotherToken) {
        vm.startBroadcast();
        AnotherToken anotherToken = new AnotherToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return anotherToken;
    }
}
