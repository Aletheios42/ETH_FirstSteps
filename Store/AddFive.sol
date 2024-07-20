// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { StorageNumber } from "./Storage.sol";

contract AddFive is StorageNumber {
    function store(uint _favoriteNumber) override public {
        myFavoriteNumber = _favoriteNumber + 5;
    }
}

