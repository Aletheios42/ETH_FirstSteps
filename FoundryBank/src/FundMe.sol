//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;


import {PriceConverter} from "./priceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint minUSD = 5e18;


    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmount; 

    address owner;
    
    constructor() {
        owner = msg.sender;
    }

    function fund() public payable { 
        require(msg.value.getConversionRate() >= minUSD, "Not enough funds");
        funders.push(msg.sender);
        addressToAmount[msg.sender] += msg.value;
    }

    function Witdthaw () public onlyOwner {
        for (uint funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmount[funder] = 0;
        }
        funders = new address[](0);
        ////transfer
        //payable(msg.sender).transfer(address(this).balance);
        ////send
        //bool succesTransfer = payable(msg.sender).send(address(this).balance);
        //require(succesTransfer, "Transfer failed");
        ////call
        (bool callSucces, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSucces, "call failed");

    }

        modifier onlyOwner() {
        if(msg.sender == owner) {
            revert NotOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

}
