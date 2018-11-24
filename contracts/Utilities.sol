pragma solidity ^0.4.4;

contract AdHashUtilities {

	mapping (address => mapping (string => bool)) creatives;
	mapping (address => uint) deposits; //TODO: multiple bidders
	mapping (address => uint) paymentsPublisher; //TODO: multiple bidders
	mapping (address => uint) paymentsBidder; //TODO: multiple bidders

	event Deposit(address from, address to, uint amount);
	event Withdraw(address from, address to, uint amount);
	event Fine(address from, address to, uint amount);
	event PaymentPublisher(address from, address to, uint amount);
	event PaymentBidder(address from, address to, uint amount);

	constructor () public {}

	//Creatives-related functionality

	function announceCreative(string creative) public payable {
		creatives[msg.sender][creative] = true;
	}

	//Deposit-related functionality

	function makeDeposit(address bidder) public payable {
		deposits[msg.sender] += msg.value;
		emit Deposit(msg.sender, bidder, msg.value);
	}

	function withdrawDeposit(address bidder) public payable {
		deposits[msg.sender] -= msg.value;
		emit Withdraw(msg.sender, bidder, msg.value);
	}

	function fineDeposit(address advertiser) public payable {
		deposits[advertiser] -= msg.value;
		emit Fine(advertiser, msg.sender, msg.value);
	}

	//Payment-related functionality

	function makePaymentToPublisher(address publisher) public payable {
		paymentsPublisher[publisher] += msg.value;
		emit PaymentPublisher(msg.sender, publisher, msg.value);
	}

	function makePaymentToBidder(address bidder) public payable {
		paymentsBidder[bidder] += msg.value;
		emit PaymentBidder(msg.sender, bidder, msg.value);
	}
}