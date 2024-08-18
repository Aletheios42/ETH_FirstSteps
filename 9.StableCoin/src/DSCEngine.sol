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

pragma solidity 0.8.19;
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

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

mapping(address token => address priceFeed) private s_priceFeed;
mapping(address token => mapping(address token => uint256 amount)); private s_collateralDeposisted;
DescentralizedStableCoin private immutable i_dsc;


/**************************************************************************/
/*                                 Events                                 */
/**************************************************************************/
event CollateralDeposited(address indexed user, uint256 indexed token, uint256 indexed amount);


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
  constructor(address[] memory tokenAddresses, address[] memory priceFeedAddress, address  dscAddress) {
    if (tokenAddresses.length != priceFeedAddress.lenght) {
      revert DSCEngine__tokenAddressesAndPriceFeedAddressMustBeTheSameLenght();
    }

    for (uint i = 0; i < tokenAddress.lenght; i++) {
      s_priceFeed[tokenAddresses[i]] = priceFeedAddress[i];
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
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral) external moreThanZero(amountCollateral) isAllowedToken(tokenCollateralAddress) nonReentrant {
      s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
      emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);
      
      bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
      if (!success) {
        revert DSCEngine__TrasferFailed();
      }

    }

    function redeemCollateralForDsc() external {}

    function redeemColateral() {}

    function mintDsc() {}

    function burnDsc() external {}
 
    function liquidate() external {}

        function getHealthFactor() external view {}

