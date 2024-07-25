// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import {PriceConverter} from "../src/priceConverter.sol";

contract Mock {
    function getVersion() public view returns (uint) {
        return PriceConverter.getVersion();
    }

    function getPrice() public view returns (uint) {
        return PriceConverter.getPrice();
    }

    function getConversionRate(uint ethAmount) public view returns (uint) {
        return PriceConverter.getConversionRate(ethAmount);
    }
}

