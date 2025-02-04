// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getVersion(AggregatorV3Interface priceFeedAddress) internal view returns (uint256) {
        return AggregatorV3Interface(priceFeedAddress).version();
    }

    function getPrice(AggregatorV3Interface priceFeedAddress) internal view returns (uint256) {
        (, int256 price,,,) = AggregatorV3Interface(priceFeedAddress).latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 _ethAmount, AggregatorV3Interface priceFeedAddress) internal view returns (uint256) {
        uint256 price = getPrice(priceFeedAddress);
        uint256 ethInUsd = (price * _ethAmount) / 1e18;
        return ethInUsd;
    }
}
