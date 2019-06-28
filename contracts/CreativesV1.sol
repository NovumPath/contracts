pragma solidity ^0.4.21;

import './CreativesStorage.sol';
import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract CreativesV1 is CreativesStorage, Ownable {

	event AnnounceCreative(address counterparty, address creative);
	event EndBlockCreative(address owner, address creative, uint votesFor, uint votesAgainst);
	event StartBlockCreative(address owner, address creative, string reason);

	function changeMembersAddress(address membersAddress) public payable onlyOwner {
		CONTRACT_MEMBERS = membersAddress;
	}

	function changeInitialThreshold(uint initialThreshold) public payable onlyOwner {
		INITIAL_THRESHOLD = initialThreshold;
	}

	function changeThresholdStep(uint step) public payable onlyOwner {
		THRESHOLD_STEP = step;
	}

	function announceCreative(address creative) public payable {
		creatives[msg.sender].push(creative);
		emit AnnounceCreative(msg.sender, creative);
	}

	function announceCreatives(address[] creativesList) public payable {
		for (uint j; j < creativesList.length; j++) {
			creatives[msg.sender].push(creativesList[j]);
			emit AnnounceCreative(msg.sender, creativesList[j]);
		}
	}

	function getCreatives(address member) public view returns (address[] _creatives) {
		_creatives = creatives[member];
	}

	function startBlockCreative(address owner, address creative, string reason) public payable {
		if (msg.value != 10 finney) {
			revert("The amount sent should be exactly 0.01 ETH");
		}
		if (threshold[creative] == 0) {
			threshold[creative] = INITIAL_THRESHOLD;
		}
		emit StartBlockCreative(owner, creative, reason);
	}

	function endBlockCreative(address owner, address creative, uint votesFor, uint votesAgainst) public payable {
		if (getMemberRole(msg.sender) != ROLE_BIDDER) {
			revert("Only bidders can fine other members");
		}
		//TODO: UPDATE FORMULAS
		if (votesFor > votesAgainst) {
			blocked[creative] = true;
			//TODO: revert deposit to author
		} else {
			threshold[creative] += THRESHOLD_STEP;
			//TODO: send deposit to voters wallet
		}
		emit EndBlockCreative(owner, creative, votesFor, votesAgainst);
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

