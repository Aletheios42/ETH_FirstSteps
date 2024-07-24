// SPDX-Lincense-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
	FundMe fundMe;
	function setUp() external {
		fundMe = new FundMe();
	}

	function testDemo() public {
		assertEq(fundMe.MIN_USD(), 5e18);
	}
}
