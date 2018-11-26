pragma solidity ^0.4.4;
pragma experimental ABIEncoderV2;

import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract Utilities is Ownable {

	address private CONTRACT_MEMBERS;

	//TODO: multiple bidders
	mapping (address => uint) deposits;
	mapping (address => uint) paymentsPublisher;
	mapping (address => uint) paymentsBidder;

	//TODO: multiple bidders
	event Deposit(address from, address to, uint amount);
	event Withdraw(address from, address to, uint amount);
	event Fine(address from, address to, uint amount);
	event PaymentPublisher(address from, address to, uint amount, uint period, address shortHash, address longHash);
	event PaymentBidder(address from, address to, uint amount, uint period, address shortHash, address longHash);

	constructor () public {}

	//Initialization functions
	function changeMembersAddress(address membersAddress) public payable onlyOwner {
		CONTRACT_MEMBERS = membersAddress;
	}

	//Deposit-related functionality

	function makeDeposit(address bidder) public payable {
		deposits[msg.sender] += msg.value;
		emit Deposit(msg.sender, bidder, msg.value);
	}

	function withdrawDeposit(address bidder) public payable {
		if (deposits[msg.sender] < msg.value) {
			revert("Not enough amount");
		}
		//TODO: check if there are no active votings
		deposits[msg.sender] -= msg.value;
		emit Withdraw(msg.sender, bidder, msg.value);
	}

	function fineDeposit(address advertiser) public payable {
		//TODO: Bidder only
		if (deposits[advertiser] < msg.value) {
			revert("Not enough amount");
		}
		deposits[advertiser] -= msg.value;
		emit Fine(advertiser, msg.sender, msg.value);
	}

	function getDeposit(address advertiser) public view returns (uint _amount) {
		_amount = deposits[advertiser];
	}

	//Payment-related functionality

	function makePaymentToPublisher(address publisher, uint period, address shortHash, address longHash) public payable {
		paymentsPublisher[publisher] += msg.value;
		//TODO: forward
		emit PaymentPublisher(msg.sender, publisher, msg.value, period, shortHash, longHash);
	}

	function makePaymentToBidder(address bidder, uint period, address shortHash, address longHash) public payable {
		paymentsBidder[bidder] += msg.value;
		//TODO: forward
		emit PaymentBidder(msg.sender, bidder, msg.value, period, shortHash, longHash);
	}
}