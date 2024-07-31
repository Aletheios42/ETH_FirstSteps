// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { StorageNumber } from "./Storage.sol";

contract StoreFactory {
    StorageNumber[] public listOfContracts;

    function createStorageInstance() public {
        StorageNumber newInstance = new StorageNumber();
        listOfContracts.push(newInstance);
    }

    function storeInInstance(uint _index, uint _number) public {
        listOfContracts[_index].store(_number);
    }

    function getFromInstance(uint _index) public view returns(uint) {
        return listOfContracts[_index].show();
    }
}

