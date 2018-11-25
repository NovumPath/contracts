pragma solidity ^0.4.4;
pragma experimental ABIEncoderV2;

contract Utilities {

	mapping (address => address[]) creatives;
	mapping (address => uint) deposits; //TODO: multiple bidders
	mapping (address => uint) paymentsPublisher; //TODO: multiple bidders
	mapping (address => uint) paymentsBidder; //TODO: multiple bidders

	event Deposit(address from, address to, uint amount);
	event Withdraw(address from, address to, uint amount);
	event Fine(address from, address to, uint amount);
	event PaymentPublisher(address from, address to, uint amount, uint period, address shortHash, address longHash);
	event PaymentBidder(address from, address to, uint amount, uint period, address shortHash, address longHash);

	constructor () public {}

	//Creatives-related functionality

	function announceCreative(address creative) public payable {
		for (uint i; i < creatives[msg.sender].length; i++) {
			if (creatives[msg.sender][i] == creative) {
				revert("Creative already exists");
			}
		}
		creatives[msg.sender].push(creative);
	}

	function getCreatives(address member) public view returns (address[] _creatives) {
		_creatives = creatives[member];
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
		deposits[msg.sender] -= msg.value;
		emit Withdraw(msg.sender, bidder, msg.value);
	}

	function fineDeposit(address advertiser) public payable {
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
		emit PaymentPublisher(msg.sender, publisher, msg.value, period, shortHash, longHash);
	}

	function makePaymentToBidder(address bidder, uint period, address shortHash, address longHash) public payable {
		paymentsBidder[bidder] += msg.value;
		emit PaymentBidder(msg.sender, bidder, msg.value, period, shortHash, longHash);
	}
}