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
    uint256 public deployerKey;

    address public USER = makeAddr("user");
    uint256 public constant AMOUNT_OF_COLLATERAL = 10 ether;
    uint256 public constant STARTING_ERC20_BALANCE = 10 ether;

    function setUp() public {
        deployer = new DeployDsc();
        (dsc, dsce, config) = deployer.run();
        (ethUsdPriceFeed, btcUsdPriceFeed, weth, wbtc, deployerKey) = config
            .activeNetworkConfig();

        ERC20Mock(weth).mint(USER, STARTING_ERC20_BALANCE);
    }

    /**************************************************************************/
    /*                               Modifiers                                */
    /**************************************************************************/

    modifier depositedCollateral() {
        vm.startPrank(USER);
        ERC20Mock(weth).approve(address(dsce), AMOUNT_OF_COLLATERAL);
        dsce.depositCollateral(weth, AMOUNT_OF_COLLATERAL);
        vm.stopPrank();
        _;
    }
    /**************************************************************************/
    /*                               Construtor                               */
    /**************************************************************************/

    address[] public tokenAddresses;
    address[] public priceFeedAddresses;

    function testRevertIfTokenLenghtDoesntMatchPriceFeed() public {
        tokenAddresses.push(weth);
        priceFeedAddresses.push(ethUsdPriceFeed);
        priceFeedAddresses.push(btcUsdPriceFeed);
        vm.expectRevert(
            DSCEngine
                .DSCEngine__tokenAddressesAndPriceFeedAddressMustBeTheSameLenght
                .selector
        );
        new DSCEngine(tokenAddresses, priceFeedAddresses, address(dsc));
    }

    /**************************************************************************/
    /*                               Price_Test                               */
    /**************************************************************************/

    function testUsdValue() public {
        uint256 ethAmount = 15e18;
        uint256 expectedUsd = 30000e18;

        uint256 actualUsd = dsce.getUsdValue(weth, ethAmount);
        assertEq(expectedUsd, actualUsd);
    }

    function testGetTokenAmountFromUsd() public {
        uint256 usdAmount = 100 ether;
        //2000$ / 100ether ----> 0.05
        uint256 expectedWeth = 0.05 ether;

        uint256 actualWeth = dsce.getTokenAmountFromUsd(weth, usdAmount);
        assertEq(expectedWeth, actualWeth);
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

    function testRevertUnapprovedCollateral() public {
        vm.startPrank(USER);
        ERC20Mock testToken = new ERC20Mock(
            "TTK",
            "TTK",
            USER,
            AMOUNT_OF_COLLATERAL
        );
        vm.expectRevert(DSCEngine.DSCEngine__NotAllowedToken.selector);
        dsce.depositCollateral(address(testToken), AMOUNT_OF_COLLATERAL);
        vm.stopPrank();
    }

    function testCanDepositedCollateralAndGetAccountInfo()
        public
        depositedCollateral
    {
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = dsce
            .getAccountInformation(USER);
        uint256 expectedDepositedAmount = dsce.getTokenAmountFromUsd(
            weth,
            collateralValueInUsd
        );
        assertEq(totalDscMinted, 0);
        assertEq(expectedDepositedAmount, AMOUNT_OF_COLLATERAL);
    }
}
