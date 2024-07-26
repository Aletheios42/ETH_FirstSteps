// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {HelperConfig, CodeConstants} from "../script/HelperConfig.s.sol";
import {console} from "forge-std/console.sol";

//import {Mock} from "./Mock.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    HelperConfig public helperConfig;

    function setUp() external  {
	DeployFundMe deployer = new DeployFundMe();
	(fundMe, helperConfig) = deployer.deployFundMe();
    }

    function testDemo() public view {
        assertEq(fundMe.MIN_USD(), 5e18);
    }

    function testPriceFeedVersion() public view {
        uint version = fundMe.getVersion();
        assertEq(version, 4);
    }
    
    function testFailsWithoutEnoughETH() public {
	    vm.expectRevert();
	    fundMe.fund();
    }

     function testFundFailsWithoutEnoughETH() public {
	    vm.expectRevert();
	    fundMe.fund();
    }

}
