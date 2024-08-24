//SPDX-License-Identifier:MIT

pragma solidity ^0.8.24;

import {MerkleAirdrop} from "src/MerkleAirdrop.sol";
import {BagelToken} from "src/BagelToken.sol";
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {ZkSyncChainChecker} from "foundry-devops/src/ZkSyncChainChecker.sol";
import {DeployMerkleAirdrop} from "script/DeployMerkleAirdrop.s.sol";

contract ClaimAirdrop is Script {
    address private constant CLAIMING_ADDRESS =
        0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    error __ClaimAirdropScript__InvalidSignatureLength();
    uint256 private constant AMOUNT_TO_COLLECT = (25 * 1e18); // 25.000000

    bytes32 private constant PROOF_ONE =
        0xd1445c931158119b00449ffcac3c947d028c0c359c34a6646d95962b3b55c6ad;
    bytes32 private constant PROOF_TWO =
        0x46f4c7c1c21e8a90c03949beda51d2d02d1ec75b55dd97a999d3edbafa5a1e2f;
    bytes32[] private proof = [PROOF_ONE, PROOF_TWO];

    // the signature will change every time you redeploy the airdrop contract!
    bytes private SIGNATURE =
        hex"fbd2270e6f23fb5fe9248480c0f4be8a4e9bd77c3ad0b1333cc60b5debc511602a2a06c24085d8d7c038bad84edc53664c8ce0346caeaa3570afec0e61144dc11c";

    function claimAirdrop(address airdrop) public {
        MerkleAirdrop(airdrop).claim();
    }

    function run() external view {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "MerkleAirdrop",
            block.chainid
        );
        claimAirdrop(mostRecentlyDeployed);
    }
}
