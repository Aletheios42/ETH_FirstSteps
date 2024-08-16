//SPDX-License-Identifier

pragma solidity ^0.8.9;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AnotherToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("AnotherToken", "ATK") {
        _mint(msg.sender, initialSupply);
    }
}
