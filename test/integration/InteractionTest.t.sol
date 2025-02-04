//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {InteractFund, InteractWithdraw} from "../../script/InteractionFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("USER");
    uint256 STARTING_BALANCE = 1 ether;
    uint256 FUND_AMOUNT = 0.1 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testInteractionFundMe() external {
        InteractFund interactFund = new InteractFund();
        interactFund.fundInteract(address(fundMe));

        InteractWithdraw interactWithdraw = new InteractWithdraw();
        interactWithdraw.withdrawInteract(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
