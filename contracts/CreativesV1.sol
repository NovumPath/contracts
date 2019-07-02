pragma solidity ^0.4.21;

import './CreativesStorage.sol';
import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol';

contract CreativesV1 is CreativesStorage, Ownable {

	//////////////////////////////////////////////////
	// Events
	//////////////////////////////////////////////////

	event AnnounceCreative(address counterparty, address creative);
	event EndBlockCreative(address initiator, address owner, address creative, uint votesFor, uint votesAgainst);
	event StartBlockCreative(address initiator, address owner, address creative, string reason);

	//////////////////////////////////////////////////
	// Owner-only setup functions
	//////////////////////////////////////////////////

	function changeMembersAddress(address membersAddress) public payable onlyOwner {
		CONTRACT_MEMBERS = membersAddress;
	}

	function changeTokenAddress(address tokenAddress) public payable onlyOwner {
		CONTRACT_TOKEN = tokenAddress;
	}

	function changeVoterAddress(address voterAddress) public payable onlyOwner {
		VOTER_POOL = voterAddress;
	}

	function changeInitialThreshold(uint amount) public payable onlyOwner {
		INITIAL_THRESHOLD = amount;
	}

	function changeThresholdStep(uint amount) public payable onlyOwner {
		THRESHOLD_STEP = amount;
	}

	function changeBlockDeposit(uint amount) public payable onlyOwner {
		BLOCK_DEPOSIT = amount;
	}

	function changeMajorityPercentage(uint amount) public payable onlyOwner {
		MAJORITY = amount;
	}

	//////////////////////////////////////////////////
	// Creative related functions
	//////////////////////////////////////////////////

	function announceCreative(address creative) public payable {
		// Store the creative in sender's array
		creatives[msg.sender].push(creative);
		// Store the first account that announced that creative
		if (creativeOwner[creative] == 0x0) {
			creativeOwner[creative] = msg.sender;
		}
		emit AnnounceCreative(msg.sender, creative);
	}

	function announceCreatives(address[] creativesList) public payable {
		for (uint j; j < creativesList.length; j++) {
			announceCreative(creativesList[j]);
		}
	}

	function getCreatives(address member) public view returns (address[] _creatives) {
		_creatives = creatives[member];
	}

	function getBlockedStatus(address creative) public view returns (bool status) {
		status = blocked[creative];
	}

	function getFirstOwner(address creative) public view returns (address owner) {
		owner = creativeOwner[creative];
	}

	//////////////////////////////////////////////////
	// Voting related functions
	//////////////////////////////////////////////////

	function startBlockCreative(address owner, address creative, string reason) public payable {
		// Take BLOCK_DEPOSIT AD from your account
		IERC20 tokenContractObject = IERC20(CONTRACT_TOKEN);
		tokenContractObject.transferFrom(msg.sender, address(this), BLOCK_DEPOSIT);
		// Set the threshold for that creative if it's missing
		if (threshold[creative] == 0) {
			threshold[creative] = INITIAL_THRESHOLD;
		}
		// Emit the event to notify everybody
		emit StartBlockCreative(msg.sender, owner, creative, reason);
	}

	function endBlockCreative(address initiator, address owner, address creative, uint votesFor, uint votesAgainst) public payable {
		if (getMemberRole(msg.sender) != ROLE_BIDDER) {
			revert("Only bidders can end voting process");
		}
		IERC20 tokenContractObject = IERC20(CONTRACT_TOKEN);
		if (votesFor * 1000 / (votesFor + votesAgainst) > MAJORITY) {
			// Voting successful - mark as blocked and return ADT
			blocked[creative] = true;
			tokenContractObject.transfer(initiator, BLOCK_DEPOSIT);
		} else {
			// Voting unsuccessful - increase difficulty and move ADT to pool
			threshold[creative] += THRESHOLD_STEP;
			tokenContractObject.transfer(VOTER_POOL, BLOCK_DEPOSIT);
		}
		emit EndBlockCreative(initiator, owner, creative, votesFor, votesAgainst);
	}

	//////////////////////////////////////////////////
	// Transfer functions (for unintentional deposits)
	//////////////////////////////////////////////////

	function fundTransfer(uint256 value) public payable onlyOwner {
		msg.sender.transfer(value);
  }

	function ERC20Transfer(address token, uint256 value) public payable onlyOwner {
		IERC20 tokenContractObject = IERC20(token);
		tokenContractObject.transfer(msg.sender, value);
  }

	//////////////////////////////////////////////////
	// Private functions
	//////////////////////////////////////////////////

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

