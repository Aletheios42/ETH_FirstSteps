// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {console} from "forge-std/console.sol";

//import {Mock} from "./Mock.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external  {
	DeployFundMe deployFundMe = new DeployFundMe();
	fundMe = deployFundMe.run();
    }

    function testDemo() public view {
        assertEq(fundMe.MIN_USD(), 5e18);
    }


    function testPriceFeedVersion() public view {
        uint version = fundMe.getVersion();
        assertEq(version, 4);
    }
    
    function testFailsWithoutEnoughEth() public {
	    vm.expectRevert();
	    uint cat = 1;
    }
}

