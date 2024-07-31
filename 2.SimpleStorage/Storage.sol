// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract StorageNumber {
    uint myFavoriteNumber;

    struct Person {
        uint favoriteNumber;
        string name;
    }

    Person[] public listOfPeople;
    mapping(string => uint) nameToFavoriteNumber;

    function store(uint _favoriteNumber) public virtual {
        myFavoriteNumber = _favoriteNumber;
    }

    function show() public view returns(uint) {
        return myFavoriteNumber;
    }

    function addPerson(string calldata _name, uint _favoriteNumber) public {
        listOfPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}

