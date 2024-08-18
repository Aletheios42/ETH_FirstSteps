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
import {ERC20, ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

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
contract DSCEngine is ERC20, ERC20Burnable, Ownable {
    error DSCEngine__MustBeMoreThanZero();

    function depositCollateralAndMintDsc() external {}

    function depositCollateral() external {}

    function redeemCollateralForDsc() external {}

    function redeemColateral() {}

    function mintDsc() {}

    function burnDsc() external {}
 
    function liquidate() external {}

        function getHealthFactor() external view {}

