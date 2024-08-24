// SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

contract BoxV1 {
    uint256 internal number;

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 1;
    }
}
