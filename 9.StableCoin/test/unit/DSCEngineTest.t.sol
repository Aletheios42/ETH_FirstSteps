//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployDsc} from "script/DeployDsc.s.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
import {DSCEngine} from "src/DSCEngine.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";

contract DSCEngineTest is Test {
    DeployDsc deployer;
    DecentralizedStableCoin dsc;
    DSCEngine dsce;
    HelperConfig config;

    address ethUsdPriceFeed;
    address btcUsdPriceFeed;
    address weth;
    address wbtc;

    address public USER = makeAddr("user");
    uint256 public constant AMOUNT_OF_COLLATERAL = 10 ether;
    uint256 public constant STARTING_ERC20_BALANCE = 10 ether;

    function setUp() public {
        deployer = new DeployDsc();
        (dsc, dsce, config) = deployer.run();
        (ethUsdPriceFeed, , weth, , ) = config.activeNetworkConfig();

        ERC20Mock(weth).mint(USER, STARTING_ERC20_BALANCE);
    }

    /**************************************************************************/
    /*                               Price_Test                               */
    /**************************************************************************/

    function testUsdValue() public view {
        uint256 ethAmount = 15e18;
        uint256 expectedUsd = 30000e18;

        uint256 actualUsd = dsce.getUsdValue(weth, ethAmount);
        assertEq(expectedUsd, actualUsd);
    }

    /**************************************************************************/
    /*                           Deposit_Collateral                           */
    /**************************************************************************/

    function testRevertIfCollateralIsZero() public {
        vm.prank(USER);
        ERC20Mock(weth).approve(address(dsce), AMOUNT_OF_COLLATERAL);

        vm.expectRevert(DSCEngine.DSCEngine__MustBeMoreThanZero.selector);
        dsce.depositCollateral(weth, 0);
        vm.prank(USER);
    }
}
