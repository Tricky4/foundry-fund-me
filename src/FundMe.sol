// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    address private immutable i_owner;
    uint256 public constant MIN_USD_TO_FUND = 5e8;
    address[] private s_funders;
    AggregatorV3Interface private s_priceFeed;
    mapping(address funderAddress => uint256 fundedAmount) private s_listOfFundersToAmount;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    modifier onlyOwner() {
        // require(msg.sender == owner, "Not an owner");
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MIN_USD_TO_FUND, "Amount must be greater than $5");
        s_funders.push(msg.sender);
        s_listOfFundersToAmount[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // require(listOfFundersToAmount[msg.sender] > 0, "Have zero balance");
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_listOfFundersToAmount[funder] = 0;
        }

        s_funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Send Failed");
    }

    function withdrawCheaper() public onlyOwner {
        // require(listOfFundersToAmount[msg.sender] > 0, "Have zero balance");
        uint256 funderLength = s_funders.length;
        for (uint256 funderIndex = 0; funderIndex < funderLength; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_listOfFundersToAmount[funder] = 0;
        }

        s_funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Send Failed");
    }

    function getAddressToAmountFunded(address fundingAddress) public view returns (uint256) {
        return s_listOfFundersToAmount[fundingAddress];
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
