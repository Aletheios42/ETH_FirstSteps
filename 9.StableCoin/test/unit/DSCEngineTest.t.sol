//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployDsc} from "script/DeployDsc.s.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
import {DSCEngine} from "src/DSCEngine.sol";

contract DSCEngineTest is Test {
    DeployDSC deployer;

    function setUp() public {
        deployer = new DeployDSC();

        (dsc, dsce) = deployer.run();
    }
}
