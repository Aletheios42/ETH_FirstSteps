//SPDX-Lincense-Identifier: MIT
pragma solidity 0.8.1;

/**
 * @title A Simple Raffle contract
 * @author AlejandroPintosAlcarazo
 * @notice This is the last proyect of my initial step in solidity
 * @dev  implement Chainlink VFRv2.5
 */

contract Raffle {

	uint256 private immutable i_entranceFee;

	constructor(uint256 entranceFee) {
		i_entranceFee = entranceFee
	}

	function enterRaffle() public payable {}

	function pickWinner() public {}

}
