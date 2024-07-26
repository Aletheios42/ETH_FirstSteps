// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./priceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {console} from "forge-std/console.sol";

error FundMe_NotOwner();

contract FundMe {
using PriceConverter for uint256;


uint public MIN_USD = 5e18;
address[] public funders;
mapping(address => uint256) public addressToAmount;
address public immutable i_owner;
AggregatorV3Interface private s_priceFeed;

   
constructor(address priceFeed) {
       i_owner = msg.sender;
       //address 0x694AA1769357215DE4FAC081bf1f309aDC325306 from https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1
       s_priceFeed = AggregatorV3Interface(priceFeed);	    console.log("FundMe owner address:", i_owner);
       
}

modifier onlyOwner() {
    if (msg.sender != i_owner) {
        revert FundMe_NotOwner();
    }
    _;
}


function fund() public payable {
    uint256 convertedValue = msg.value.getConversionRate(s_priceFeed);

    require(convertedValue >= MIN_USD, "Not enough funds");
    funders.push(msg.sender);
    addressToAmount[msg.sender] += msg.value;
}

function withdraw() public onlyOwner {
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

function getVersion() public view returns (uint) {
    return s_priceFeed.version();
}

receive() external payable {
    fund();
}
fallback() external payable {
    fund();
    }
}
