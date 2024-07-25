// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {console} from "forge-std/console.sol";

//import {Mock} from "./Mock.sol";

contract FundMeTest is Test {
    FundMe fundMe;
   // Mock mockPriceConverter;

    function setUp() external {
	DeployFundMe deployFundMe = new DeployFundMe();
	fundMe = deployFundMe.run();
        //mockPriceConverter = new Mock(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function testDemo() public view {
        assertEq(fundMe.MIN_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        console.log("FundMe owner address in test:", fundMe.i_owner()); // Log de la dirección del propietario en el test
        console.log("Test contract address:", address(this)); // Log de la dirección del contrato de prueba
        assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersion() public view {
        uint version = fundMe.getVersion();
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

