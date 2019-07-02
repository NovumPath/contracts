pragma solidity ^0.4.21;

import './MembersStorage.sol';
import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol';

contract MembersV1 is MembersStorage, Ownable {

	//////////////////////////////////////////////////
	// Events
	//////////////////////////////////////////////////

	event RegisterMember(address member, uint role, string name, string endpoint);
	event ChangeInformation(address member, string name, string endpoint);
	event ParticipateInVoting(address member, bool voting);
	event BlockMember(address bidder, address member);
	event UnblockMember(address bidder, address member);

	//////////////////////////////////////////////////
	// Owner-only setup functions
	//////////////////////////////////////////////////

	function allowBidders(bool value) public payable onlyOwner {
		ALLOW_BIDDERS = value;
	}

	//////////////////////////////////////////////////
	// Member related functions
	//////////////////////////////////////////////////

	function registerMember(uint role, string name, string endpoint) public payable {
		if (members[msg.sender].role != 0) {
			revert("You are already registered");
		}
		if (role == ROLE_BIDDER) {
			if (!ALLOW_BIDDERS) {
				revert("Bidders are not allowed");
			}
			members[msg.sender] = Member(name, endpoint, role, false, false);
		} else if (role == ROLE_ADVERTISER) {
			members[msg.sender] = Member(name, endpoint, role, false, false);
		} else if (role == ROLE_PUBLISHER) {
			members[msg.sender] = Member(name, endpoint, role, false, false);
		} else if (role == ROLE_VOTER) {
			members[msg.sender] = Member(name, "", role, false, true);
		} else {
			revert("Unknown role");
		}
		emit RegisterMember(msg.sender, role, name, endpoint);
	}

	function registerMemberOnBehalf(address member, uint role, string name, string endpoint) public payable {
		if (members[msg.sender].role != ROLE_BIDDER) {
			revert("The sender must be a bidder");
		}
		if (members[member].role != 0) {
			revert("Member is already registered");
		}
		if (role == ROLE_ADVERTISER) {
			members[member] = Member(name, endpoint, role, false, false);
		} else if (role == ROLE_PUBLISHER) {
			members[member] = Member(name, endpoint, role, false, false);
		} else if (role == ROLE_VOTER) {
			members[member] = Member(name, "", role, false, true);
		} else {
			revert("Unknown role");
		}
		emit RegisterMember(member, role, name, endpoint);
	}

	function getMember(address counterparty) public view returns (uint role, string name, string endpoint, bool blocked, bool voter) {
		role = members[counterparty].role;
		name = members[counterparty].name;
		endpoint = members[counterparty].endpoint;
		blocked = members[counterparty].blocked;
		voter = members[counterparty].voter;
	}

	// Needed by other smart contracts
	function getMemberRole(address counterparty) public view returns (uint role) {
		role = members[counterparty].role;
	}

	function changeInformation(string name, string endpoint) public payable {
		if (members[msg.sender].role == 0) {
			revert("You are not registered yet");
		}
		members[msg.sender].name = name;
		members[msg.sender].endpoint = endpoint;
		emit ChangeInformation(msg.sender, name, endpoint);
	}

	function changeInformationOnBehalf(address member, string name, string endpoint) public payable {
		if (members[msg.sender].role != ROLE_BIDDER) {
			revert("The sender must be a bidder");
		}
		if (members[member].role == 0) {
			revert("Member not registered yet");
		}
		members[member].name = name;
		members[member].endpoint = endpoint;
		emit ChangeInformation(member, name, endpoint);
	}

	function participateInVoting(bool voting) public payable {
		if (members[msg.sender].role == 0) {
			revert("You are not registered yet");
		}
		members[msg.sender].voter = voting;
		emit ParticipateInVoting(msg.sender, voting);
	}

	function blockMember(address member) public payable {
		if (members[msg.sender].role != ROLE_BIDDER) {
			revert("The sender must be a bidder");
		}
		members[member].blocked = true;
		emit BlockMember(msg.sender, member);
	}

	function unblockMember(address member) public payable {
		if (members[msg.sender].role != ROLE_BIDDER) {
			revert("The sender must be a bidder");
		}
		members[member].blocked = false;
		emit UnblockMember(msg.sender, member);
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
}