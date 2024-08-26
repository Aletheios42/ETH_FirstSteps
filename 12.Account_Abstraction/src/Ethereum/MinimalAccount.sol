// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

/**
 * @title MinimalAccount
 * @author Aletheios42
 *
 */

// import {IAccount} from "@account-abstraction/interfaces/IAccount.sol";
// import {PackedUserOperation} from "@account-abstraction/interfaces/PackedUserOperation.sol";

import {IAccount} from "lib/account-abstraction/contracts/interfaces/IAccount.sol";
import {PackedUserOperation} from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "lib/account-abstraction/contracts/core/Helpers.sol";
import {IEntryPoint} from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";

contract MinimalAccount is IAccount, Ownable {
    /**************************************************************************/
    /*                                 Errors                                 */
    /**************************************************************************/
    error MinimalAccount__NotFromEntryPoint();
    error MinimalAccount__NotFromEntryPointOrOwner();
    error MinimalAccount__CalledFailed(bytes);

    /**************************************************************************/
    /*                            State_Variables                             */
    /**************************************************************************/

    IEntryPoint private immutable i_entryPoint;

    /**************************************************************************/
    /*                               Modifiers                                */
    /**************************************************************************/

    modifier requireFromEntryPoint() {
        if (msg.sender != address(i_entryPoint)) {
            revert MinimalAccount__NotFromEntryPoint();
        }
        _;
    }

    modifier requireFromEntryPointOwner() {
        if (msg.sender != address(i_entryPoint) && msg.sender != owner()) {
            revert MinimalAccount__NotFromEntryPointOrOwner();
        }
        _;
    }

    /**************************************************************************/
    /*                               Functions                                */
    /**************************************************************************/

    constructor(address entryPoint) Ownable(msg.sender) {
        i_entryPoint = IEntryPoint(entryPoint);
    }

    receive() external payable {}

    /**************************************************************************/
    /*                           External Functions                           */
    /**************************************************************************/

    function execute(
        address dest,
        uint256 value,
        bytes calldata functionData
    ) external {
        (bool success, bytes memory result) = dest.call{value: value}(
            functionData
        );
        if (!success) {
            revert MinimalAccount__CalledFailed(result);
        }
    }

    //Basic functionality A signature is valid if its the owner
    function validateUserOp(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 missingAccountFunds
    ) external returns (uint256 validationData) {
        validationData = _validateSignature(userOp, userOpHash);
        //entrypint already manages nonce, but i should check it as well
        _payPrefund(missingAccountFunds);
    }

    /**************************************************************************/
    /*                           Internal Functions                           */
    /**************************************************************************/

    //EIP-191 version  of the  signed hash
    function _validateSignature(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash
    ) internal view returns (uint256 validationData) {
        bytes32 ethSingedMessageHash = MessageHashUtils.toEthSignedMessageHash(
            userOpHash
        );
        address signer = ECDSA.recover(ethSingedMessageHash, userOp.signature);
        if (signer != owner()) {
            return SIG_VALIDATION_FAILED;
        }
        return SIG_VALIDATION_SUCCESS;
    }

    function _payPrefund(uint256 missingAccountFunds) internal {
        if (missingAccountFunds != 0) {
            (bool success, ) = payable(msg.sender).call{
                value: missingAccountFunds,
                gas: type(uint256).max
            }("");
            (success);
        }
    }

    /**************************************************************************/
    /*                                 Getter                                 */
    /**************************************************************************/

    function getEntryPoint() external view returns (address) {
        return address(i_entryPoint);
    }
}
