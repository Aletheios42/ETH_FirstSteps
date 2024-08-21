//SPDX-License_identifier:MIT

pragma solidity ^0.8.19;

/*
 *@title OracleLib
 *@author Aletheios42
 *@notice this library is used to check if chianlink price wroking well
 *
 * We want to DSCEngine to freeze if oracle stales
 */

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library OracleLib {
    uint256 internal constant TIMEOUT = 3 hours; // 3 * 60 * 60 = 10800 seconds

    // Declaración del error
    error OracleLib__StalePrice();

    function staleCheckLatestRoundData(
        AggregatorV3Interface priceFeed
    ) public view returns (uint80, int256, uint256, uint256, uint80) {
        (
            uint80 roundId,
            int256 answer,
            uint256 startAt,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        uint256 secondsSince = block.timestamp - updatedAt;
        if (secondsSince > TIMEOUT) {
            revert OracleLib__StalePrice();
        }

        return (roundId, answer, startAt, updatedAt, answeredInRound);
    }
}
