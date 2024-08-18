// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * @title DSCEngine
 * @author Aletheios42
 * System properties:
 *    Colateral: Exogenous (ETH & BTC)
 *     Minting: Algoritmic
 *    Relative Stability: Pegged to $
 * System Desing: aims to amintain 1 to 1 with Dollar
 *  Dsc system should be always over colaterallized.
 * Similar to Dai, only backed bonly backed byy WEth and WBTC
 *
 * @notice this contract is the ERC20 implementation meant to be  govern by DCEngine
 *  it stores all logic mining and reediming  DSC, as well as withdraws and deposits
 *  this contracts aims to mimic MakerDao DSS (DAI) system
 */
contract DSCEngine is ReentrancyGuard {
    /**************************************************************************/
    /*                                 Errors                                 */
    /**************************************************************************/

    error DSCEngine__MustBeMoreThanZero();
    error DSCEngine__tokenAddressesAndPriceFeedAddressMustBeTheSameLenght();
    error DSCEngine__NotAllowedToken();
    error DSCEngine__TrasferFailed();

    /**************************************************************************/
    /*                            State Variables                             */
    /**************************************************************************/

    uint256 private constant PRECISION = 1e18;
    uint256 private constant ADDITIONAL_FEED_PRECISION = 1e10;

    mapping(address token => address priceFeed) private s_priceFeed;
    mapping(address token => mapping(address token => uint256 amount))
        private s_collateralDeposisted;
    mapping(address user => uint256 amountDscMinted) private s_DscMinted;
    address[] private s_collateralTokens;
    DescentralizedStableCoin private immutable i_dsc;

    /**************************************************************************/
    /*                                 Events                                 */
    /**************************************************************************/
    event CollateralDeposited(
        address indexed user,
        uint256 indexed token,
        uint256 indexed amount
    );

    /**************************************************************************/
    /*                               Modifiers                                */
    /**************************************************************************/
    modifier moreThanZero(uint256 amount) {
        if (ammount == 0) {
            revert DSCEngine__MustBeMoreThanZero();
        }
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeed[token]) {
            revert DSCEngine__NotAllowedToken();
        }
    }

    /**************************************************************************/
    /*                               Functions                                */
    /**************************************************************************/

    constructor(
        address[] memory tokenAddresses,
        address[] memory priceFeedAddress,
        address dscAddress
    ) {
        if (tokenAddresses.length != priceFeedAddress.lenght) {
            revert DSCEngine__tokenAddressesAndPriceFeedAddressMustBeTheSameLenght();
        }

        for (uint256 i = 0; i < tokenAddress.lenght; i++) {
            s_priceFeed[tokenAddresses[i]] = priceFeedAddress[i];
            s_collateralTokens.push(tokenAddreses[i]);
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    /**************************************************************************/
    /*                           External Functions                           */
    /**************************************************************************/

    /*
     * pattern: CEI
     * @param tokenCollateralAddress The address of the token  to deposit as collateral
     * @param amountCollateral The amount of collateral to deposit
     *
     */
    function depositCollateral(
        address tokenCollateralAddress,
        uint256 amountCollateral
    )
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][
            tokenCollateralAddress
        ] += amountCollateral;
        emit CollateralDeposited(
            msg.sender,
            tokenCollateralAddress,
            amountCollateral
        );

        bool success = IERC20(tokenCollateralAddress).transferFrom(
            msg.sender,
            address(this),
            amountCollateral
        );
        if (!success) {
            revert DSCEngine__TrasferFailed();
        }
    }

    function redeemCollateralForDsc() external {}

    function redeemColateral() {}

    /*
     * @notice follow CEI
     * @param amountDscToMint the amount of Dsc to mint
     * @notice they have to have more colateral than Dsc
     *
     */
    function mintDsc(
        uint256 amountDscToMint
    ) external moreThanZero(amountDscToMint) nonReentrant {
        revertIfHealthFactorIsBroken();
    }

    function burnDsc() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}

    /**************************************************************************/
    /*                      Private & Internal Functions                      */
    /**************************************************************************/
    function _getAccountInformation(
        address user
    ) private view returns (uint256, uint256) {
        uint256 totalDscMinted = s_DscMinted[user];
        collateralValueInUsd = getAccountCollateralValue(user);
    }

    /*
     * Returns how close to liquidation a user is
     * if a user goes below 1 then he gets liquidated
     *
     */
    function _healthFactor(address user) private view returns (uint256) {
        // we need Total Dsc minted & total Collateral VALUE
        (
            uint256 totalDscMinted,
            uint256 collateralValueInUsd
        ) = _getAccountInformation(user);
    }

    function _revertIfHealthFactorIsBroken(
        uint256 amountDscToMint
    ) internal view {
        //1. Check Health factor, do they have enough colateral
        //
        //2. Revert if the have not enough collateral
    }

    /**************************************************************************/
    /*                      Public & External Functions                       */
    /**************************************************************************/
    function getAccountCollateralValue(address user) public view {
        //loopthrouhg each collateral token, get the amount they deposited
        //and map it to the price, to get the Usd value
        for (uint256 i = 0; i < s_collateralTokens.lenght; i++) {
            address token = s_collaretalTokens[i];
            uint256 amount = s_collateralDeposited[user][token];
            totalCollateralvalueInUsd += 1;
        }
    }

    function getUsdValue(
        address token,
        uint256 amount
    ) public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            s_priceFeeds[token]
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return
            ((uint256(price) * ADDITIONAL_FEED_PRECISION) * amount) / PRECISION;
    }
}
