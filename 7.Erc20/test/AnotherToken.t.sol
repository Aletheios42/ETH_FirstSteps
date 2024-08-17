// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployToken} from "../script/DeployToken.s.sol";
import {AnotherToken} from "../src/AnotherToken.sol";
import {Test, console} from "forge-std/Test.sol";

contract AnotherTokenTest is Test {
    DeployToken deployer;
    AnotherToken anotherToken;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployToken();
        anotherToken = deployer.run();

        vm.prank(msg.sender);
        anotherToken.transfer(bob, STARTING_BALANCE);
    }

    /**************************************************************************/
    /*                               Basic Test                               */
    /**************************************************************************/

    function testBobBalance() public view {
        assertEq(anotherToken.balanceOf(bob), STARTING_BALANCE);
    }

    // I understand hardcoding amounts makes no sense i should check for the diference in the assert, just playing
    function testAllowance() public {
        uint256 allowanceAmount = 1000 * (10 ** 18);

        vm.prank(bob);
        anotherToken.approve(alice, allowanceAmount);

        uint256 transferAmount = 50 * (10 ** 18);
        vm.prank(alice);
        anotherToken.transferFrom(bob, alice, transferAmount);
        console.log("La pasta de bob: ", anotherToken.balanceOf(bob));
        console.log("La pasta de alice: ", anotherToken.balanceOf(alice));
        assertEq(anotherToken.balanceOf(alice), anotherToken.balanceOf(bob));
    }

    /**************************************************************************/
    /*                             ChatGPT Tests                              */
    /**************************************************************************/

    function testTransfer() public {
        uint256 transferAmount = 10 ether;

        vm.prank(bob);
        anotherToken.transfer(alice, transferAmount);

        assertEq(
            anotherToken.balanceOf(bob),
            STARTING_BALANCE - transferAmount
        );
        assertEq(anotherToken.balanceOf(alice), transferAmount);
    }

    function testInsufficientBalanceTransfer() public {
        uint256 transferAmount = STARTING_BALANCE + 1 ether;

        vm.prank(bob);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        anotherToken.transfer(alice, transferAmount);
    }

    function testApproveAndAllowance() public {
        uint256 allowanceAmount = 50 ether;

        vm.prank(bob);
        anotherToken.approve(alice, allowanceAmount);

        assertEq(anotherToken.allowance(bob, alice), allowanceAmount);
    }

    function testTransferFrom() public {
        uint256 allowanceAmount = 50 ether;
        uint256 transferAmount = 20 ether;

        vm.prank(bob);
        anotherToken.approve(alice, allowanceAmount);

        vm.prank(alice);
        anotherToken.transferFrom(bob, alice, transferAmount);

        assertEq(
            anotherToken.balanceOf(bob),
            STARTING_BALANCE - transferAmount
        );
        assertEq(anotherToken.balanceOf(alice), transferAmount);
        assertEq(
            anotherToken.allowance(bob, alice),
            allowanceAmount - transferAmount
        );
    }

    function testExceedAllowanceTransferFrom() public {
        uint256 allowanceAmount = 50 ether;
        uint256 transferAmount = 60 ether;

        vm.prank(bob);
        anotherToken.approve(alice, allowanceAmount);

        vm.prank(alice);
        vm.expectRevert("ERC20: transfer amount exceeds allowance");
        anotherToken.transferFrom(bob, alice, transferAmount);
    }
}
