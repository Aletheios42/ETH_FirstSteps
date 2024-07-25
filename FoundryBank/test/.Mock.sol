// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import {FundMe} from "../src/FundMe.sol";

contract Mock {
    FundMe fundMe;

    constructor(address fundMeAddress) {
        fundMe = FundMe(payable(fundMeAddress));  // Convierte la dirección a un contrato pagadero
    }

    function getVersion() public view returns (uint) {
        return fundMe.getVersion();
    }

    // Otras funciones según sea necesario
}

