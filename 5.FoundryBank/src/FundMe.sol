// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./priceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {console} from "forge-std/console.sol";

error FundMe_NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public MIN_USD = 5e18;
    address[] private s_funders;
    mapping(address => uint256) private s_addressToAmountFunded;
    address private immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        //address 0x694AA1769357215DE4FAC081bf1f309aDC325306 from https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1
        s_priceFeed = AggregatorV3Interface(priceFeed);
        console.log("FundMe owner address:", i_owner);
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
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        ////transfer
        //payable(msg.sender).transfer(address(this).balance);
        ////send
        //bool succesTransfer = payable(msg.sender).send(address(this).balance);
        //require(succesTransfer, "Transfer failed");
        ////call
        (bool callSucces,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSucces, "call failed");
    }

    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;
        for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSucces,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSucces, "call failed");
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunded(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
