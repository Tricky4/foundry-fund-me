//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {FundMe} from "../src/FundMe.sol";
import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract InteractFund is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundInteract(address fundMeAddress) public {
        vm.startBroadcast();
        FundMe(payable(fundMeAddress)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("FundMe contract created and Funded with", SEND_VALUE, "contract address:", fundMeAddress);
    }

    function run() external {
        vm.startBroadcast();
        address fundMeAddress = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundInteract(fundMeAddress);
        vm.stopBroadcast();
    }
}

contract InteractWithdraw is Script {
    function withdrawInteract(address fundMeAddress) public {
        vm.startBroadcast();
        FundMe(payable(fundMeAddress)).withdraw();
        vm.stopBroadcast();
        console.log("FundMe contract created and Withdrawn, contract address:", fundMeAddress);
    }

    function run() external {
        vm.startBroadcast();
        address fundMeAddress = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawInteract(fundMeAddress);
        vm.stopBroadcast();
    }
}
