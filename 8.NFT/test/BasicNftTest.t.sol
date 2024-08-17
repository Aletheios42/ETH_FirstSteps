//SPDX-Lincese-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract BasicNftTest is Test {
    BasicNft basicNft;
    DeployBasicNft deployer;
    address USER = makeAddr("User");
    string constant PUG =
        "ipfs://QmSsYRx3LpDAb1GZQm7zZ1AuHZjfbPkD6J7s9r41xu1mf8";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    /**************************************************************************/
    /*                               Basic Test                               */
    /**************************************************************************/

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);

        assert(basicNft.balanceOf(USER) == 1);
        assert(
            keccak256(abi.encode(PUG)) ==
                keccak256(abi.encode(basicNft.tokenURI(0)))
        );
    }

    //  function test() public {}
}
