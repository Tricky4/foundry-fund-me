//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint8 private DECIMAL = 8;
    int256 private INITIAL_PRICE = 3100e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) activeNetworkConfig = getEthSepoliaConfig();
        else if (block.chainid == 1) activeNetworkConfig = getEthMainnetConfig();
        else activeNetworkConfig = getOrCreateAnvilTestConfig();
    }

    function getEthSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethSepoliaNetworkConfig =
            NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return ethSepoliaNetworkConfig;
    }

    function getEthMainnetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethMainnetNetworkConfig =
            NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethMainnetNetworkConfig;
    }

    function getOrCreateAnvilTestConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMAL, INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilNetworkConfig = NetworkConfig({priceFeed: address(mockV3Aggregator)});
        return anvilNetworkConfig;
    }
}
