pragma solidity ^0.4.21;

import './UtilitiesStorage.sol';
import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol';

contract UtilitiesV1 is UtilitiesStorage, Ownable {

	event Deposit(address from, address to, uint256 amount);
	event Withdraw(address from, address to, uint256 amount);
	event Fine(address from, address to, uint256 amount);
	event PaymentPublisher(address from, address to, uint256 amount, uint period, address shortHash, address longHash);
	event PaymentBidder(address from, address to, uint256 amount, uint period, address shortHash, address longHash);

	//Initialization functions

	function changeMembersAddress(address membersAddress) public payable onlyOwner {
		CONTRACT_MEMBERS = membersAddress;
	}

	function changeTokenAddress(address tokenAddress) public payable onlyOwner {
		CONTRACT_TOKEN = tokenAddress;
	}

	//Deposit-related functionality

	function makeDeposit(address bidder, uint256 value) public payable {
		IERC20 tokenContractObject = IERC20(CONTRACT_TOKEN);
		tokenContractObject.transferFrom(msg.sender, address(this), value);
		deposits[bidder][msg.sender] += value;
		emit Deposit(msg.sender, bidder, value);
	}

	function withdrawDeposit(address advertiser, uint256 value) public payable {
		if (getMemberRole(msg.sender) != ROLE_BIDDER) {
			revert("Only bidders can withdraw");
		}
		if (deposits[msg.sender][advertiser] < value) {
			revert("Not enough amount");
		}
		// Send the amount back to the advertiser
		IERC20 tokenContractObject = IERC20(CONTRACT_TOKEN);
		tokenContractObject.transfer(advertiser, value);
		// Adjust the deposits array and emit an event
		deposits[msg.sender][advertiser] -= value;
		emit Withdraw(advertiser, msg.sender, value);
	}

	function fineDeposit(address advertiser, uint256 value) public payable {
		if (getMemberRole(msg.sender) != ROLE_BIDDER) {
			revert("Only bidders can fine other members");
		}
		if (deposits[msg.sender][advertiser] < value) {
			revert("Not enough amount");
		}
		// Send the amont to the bidder
		IERC20 tokenContractObject = IERC20(CONTRACT_TOKEN);
		tokenContractObject.transfer(msg.sender, value);
		// Adjust the deposits array and emit an event
		deposits[msg.sender][advertiser] -= value;
		emit Fine(advertiser, msg.sender, value);
	}

	function getDeposit(address advertiser, address bidder) public view returns (uint256 amount) {
		amount = deposits[bidder][advertiser];
	}

	//Payment-related functionality

	function makePaymentToPublisher(address publisher, uint256 value, uint period, address shortHash, address longHash) public payable {
		IERC20 tokenContractObject = IERC20(CONTRACT_TOKEN);
		tokenContractObject.transferFrom(msg.sender, publisher, value);
		emit PaymentPublisher(msg.sender, publisher, value, period, shortHash, longHash);
	}

	function makePaymentToBidder(address bidder, uint256 value, uint period, address shortHash, address longHash) public payable {
		IERC20 tokenContractObject = IERC20(CONTRACT_TOKEN);
		tokenContractObject.transferFrom(msg.sender, bidder, value);
		emit PaymentBidder(msg.sender, bidder, value, period, shortHash, longHash);
	}

	//Transfer functions (needed if somebody deposits something unintentionally)

	function fundTransfer(uint256 value) public payable onlyOwner {
		msg.sender.transfer(value);
  }

	function ERC20Transfer(address token, uint256 value) public payable onlyOwner {
		IERC20 tokenContractObject = IERC20(token);
		tokenContractObject.transfer(msg.sender, value);
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