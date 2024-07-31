//SPDX-License-Identifier: MIT
pragma solidity 0.8.24;


error NotOwner();

//REMIX AUTOMATICALLY LOOK FOR NPM RESOURCES, THAT S WHY THIS IMPORT WORKS
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
        function getPrice() internal view returns(uint) {
        //address 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF from https://docs.chain.link/data-feeds/price-feeds/addresses?network=zksync&page=1
        //abi chainlink registry contracto to see actual price
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        (,int256 price,,,) = priceFeed.latestRoundData();
       return uint256 (price * 1e10);
    }
    function getVersion() internal view returns (uint) {
        return  AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF).version();
    }

    function getConversionRate (uint ethAmount) internal view returns (uint) {
        uint ethPrice = getPrice();
        uint ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUSD;
    }

}

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
