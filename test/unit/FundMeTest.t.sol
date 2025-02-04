//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

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

    function testMinimumUsdIsFive() public view {
        assertEq(fundMe.MIN_USD_TO_FUND(), 5e8);
    }

    function testOwnerIsSendingTxn() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testChainlinkVersion() public view {
        uint256 version = fundMe.getVersion();
        if (block.chainid == 11155111) {
            assertEq(version, 4);
        } else if (block.chainid == 1) {
            assertEq(version, 6);
        }
    }

    function testFundFailedWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund(); //send 0 ETH
    }

    modifier userFundAmount() {
        vm.prank(USER);
        fundMe.fund{value: FUND_AMOUNT}();
        _;
    }

    function testFundUpdatesFundersDataStructure() public userFundAmount {
        uint256 fundedAmount = fundMe.getAddressToAmountFunded(USER);
        assertEq(fundedAmount, FUND_AMOUNT);
    }

    function testAddsFundersToArray() public userFundAmount {
        address fundedAddress = fundMe.getFunder(0);
        assertEq(fundedAddress, USER);
    }

    function testOnlyOwnerCanWithdraw() public userFundAmount {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public userFundAmount {
        address owner = fundMe.getOwner();
        uint256 startingOwnerBalance = owner.balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(owner);
        fundMe.withdraw();

        uint256 endingOwnerBalance = owner.balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingFundMeBalance + startingOwnerBalance);
    }

    function testWithdrawWithMultipleFunder() public userFundAmount {
        uint160 totalFunders = 10;
        uint160 startIndex = 2;

        for (uint160 i = startIndex; i <= totalFunders; i++) {
            hoax(address(i), FUND_AMOUNT);
            fundMe.fund{value: FUND_AMOUNT}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assert(endingFundMeBalance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == endingOwnerBalance);
    }

    function testWithdrawWithMultipleFunderCheaper() public userFundAmount {
        uint160 totalFunders = 10;
        uint160 startIndex = 2;

        for (uint160 i = startIndex; i <= totalFunders; i++) {
            hoax(address(i), FUND_AMOUNT);
            fundMe.fund{value: FUND_AMOUNT}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdrawCheaper();
        vm.stopPrank();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assert(endingFundMeBalance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == endingOwnerBalance);
    }
}
