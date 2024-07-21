//SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

        function getPrice() internal view returns(uint) {
        //address 0x694AA1769357215DE4FAC081bf1f309aDC325306 from https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1
        //abi chainlink registry contracto to see actual price
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();
       return uint256 (price * 1e10);
    }

    function getVersion() internal view returns (uint) {
        return  AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

    function getConversionRate (uint ethAmount) internal view returns (uint) {
        uint ethPrice = getPrice();
        uint ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUSD;
    }

}
