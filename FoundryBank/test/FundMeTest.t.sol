// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {Mock} from "./Mock.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    Mock mockPriceConverter;

    function setUp() external {
        fundMe = new FundMe();
        mockPriceConverter = new Mock();
    }

    function testDemo() public {
        assertEq(fundMe.MIN_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersion() public {
        uint version = mockPriceConverter.getVersion();
        assertEq(version, 4);
    }

   // function testGetPrice() public {
     //   uint price = mockPriceConverter.getPrice();
        // Add assertions based on expected price
    //}

    // function testGetConversionRate() public {
       // uint conversionRate = mockPriceConverter.getConversionRate(1e18);
        // Add assertions based on expected conversion rate
   // }
}

