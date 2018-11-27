pragma solidity ^0.4.21;

import './UtilitiesStorage.sol';
import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract UtilitiesV1 is UtilitiesStorage, Ownable {
	//TODO: multiple bidders
	event Deposit(address from, address to, uint256 amount);
	event Withdraw(address from, address to, uint256 amount);
	event Fine(address from, address to, uint256 amount);
	event PaymentPublisher(address from, address to, uint256 amount, uint period, address shortHash, address longHash);
	event PaymentBidder(address from, address to, uint256 amount, uint period, address shortHash, address longHash);

	//Initialization functions

	function changeMembersAddress(address membersAddress) public payable onlyOwner {
		CONTRACT_MEMBERS = membersAddress;
	}

	//Deposit-related functionality

	function makeDeposit(address bidder) public payable {
		deposits[msg.sender] += msg.value;
		emit Deposit(msg.sender, bidder, msg.value);
	}

	function withdrawDeposit(address bidder, uint256 value) public payable {
		if (deposits[msg.sender] < value) {
			revert("Not enough amount");
		}
		//TODO: check if there are no active votings
		msg.sender.transfer(value);
		deposits[msg.sender] -= value;
		emit Withdraw(msg.sender, bidder, value);
	}

	function fineDeposit(address advertiser, uint256 value) public payable {
		if (getMemberRole(msg.sender) != ROLE_BIDDER) {
			revert("Only bidders can fine other members");
		}
		if (deposits[advertiser] < value) {
			revert("Not enough amount");
		}
		msg.sender.transfer(value);
		deposits[advertiser] -= value;
		emit Fine(advertiser, msg.sender, value);
	}

	function getDeposit(address advertiser) public view returns (uint256 amount) {
		amount = deposits[advertiser];
	}

	//Payment-related functionality

	function makePaymentToPublisher(address publisher, uint period, address shortHash, address longHash) public payable {
		paymentsPublisher[publisher] += msg.value;
		publisher.transfer(msg.value);
		emit PaymentPublisher(msg.sender, publisher, msg.value, period, shortHash, longHash);
	}

	function makePaymentToBidder(address bidder, uint period, address shortHash, address longHash) public payable {
		paymentsBidder[bidder] += msg.value;
		bidder.transfer(msg.value);
		emit PaymentBidder(msg.sender, bidder, msg.value, period, shortHash, longHash);
	}

	function fundTransfer(uint256 amount) public payable onlyOwner {
		msg.sender.transfer(amount);
    }

	//Private functions

	function getMemberRole(address counterparty) private returns (uint role) {
		bytes4 sig = bytes4(keccak256("getMemberRole(address)"));
		address to = CONTRACT_MEMBERS;
		assembly {
			let x := mload(0x40) //Find empty storage location using "free memory pointer"
			mstore(x, sig) //Place signature at begining of empty storage
			mstore(add(x, 0x04), counterparty) //Place first argument directly next to signature
			//mstore(add(x, 0x24), b) //Place second argument next to first, padded to 32 bytes
			let success := call(
				5000, //5k gas
				to, //To address
				0, //No value to send
				x, //Inputs are stored at location x
				0x24, //Inputs are 32+4 bytes long
				x, //Store output over input (saves space)
				0x20
			) //Outputs are 32 bytes long
			role := mload(x) //Assign output value
			mstore(0x40, add(x, 0x24)) // Set storage pointer to empty space
		}
	}
}