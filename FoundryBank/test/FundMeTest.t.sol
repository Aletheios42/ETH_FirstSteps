// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {HelperConfig, CodeConstants} from "../script/HelperConfig.s.sol";
import {console} from "forge-std/console.sol";


contract FundMeTest is Test {
    FundMe public fundMe;
    HelperConfig public helperConfig;
    
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;


    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        (fundMe, helperConfig) = deployer.deployFundMe();
        vm.deal(USER,  STARTING_BALANCE);
    }

    function testDemo() public view {
        assertEq(fundMe.MIN_USD(), 5e18);
    }

    function testPriceFeedVersion() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }
    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
	    fundMe.fund{value: SEND_VALUE}();
	    uint amountFunded = fundMe.getAddressToAmountFunded(USER);
	    assertEq(amountFunded, SEND_VALUE);
    }
}
