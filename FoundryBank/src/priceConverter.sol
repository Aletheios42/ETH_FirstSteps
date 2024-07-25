// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint) {
        //abi chainlink registry contracto to see actual price
        (,int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(uint ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint) {
        uint ethPrice = getPrice(priceFeed);
        uint ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUSD;
    }
}

