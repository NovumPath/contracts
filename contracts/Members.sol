pragma solidity ^0.4.4;

import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract Members is Ownable {

	uint public constant ROLE_BIDDER = 1;
	uint public constant ROLE_ADVERTISER = 2;
	uint public constant ROLE_PUBLISHER = 3;
	uint public constant ROLE_VOTER = 4;

	bool private ALLOW_BIDDERS = false;

	struct Member {
		string name;
		string endpoint;
		uint role;
		bool blocked;
		bool voter;
    }

	mapping (address => Member) members; //TODO: multiple bidders

	event RegisterMember(address member, uint role, string name, string endpoint);
	event ChangeInformation(address member, string name, string endpoint);
	event ParticipateInVoting(address member, bool voting);
	event BlockMember(address bidder, address member);
	event UnblockMember(address bidder, address member);

	function allowBidders(bool value) public payable onlyOwner {
		ALLOW_BIDDERS = value;
	}

	function getAllowBidders() public view returns (bool allowBiddersInner) {
		allowBiddersInner = ALLOW_BIDDERS;
	}

	function registerMember(uint role, string name, string endpoint) public payable { //TODO: Register member on behalf
		if (members[msg.sender].role != 0) {
			revert("Member is already registered");
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

	function getMember(address counterparty) public view returns (uint role, string name, string endpoint, bool blocked) {
		role = members[counterparty].role;
		name = members[counterparty].name;
		endpoint = members[counterparty].endpoint;
		blocked = members[counterparty].blocked;
	}

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

	function participateInVoting(bool voting) public payable {
		members[msg.sender].voter = voting;
		emit ParticipateInVoting(msg.sender, voting);
	}

	function blockMember(address member) public payable {
		if (members[msg.sender].role != ROLE_BIDDER) {
			revert("The sender must be a bidder");
		}
		members[msg.sender].blocked = true;
		emit BlockMember(msg.sender, member);
	}

	function unblockMember(address member) public payable {
		if (members[msg.sender].role != ROLE_BIDDER) {
			revert("The sender must be a bidder");
		}
		members[msg.sender].blocked = false;
		emit UnblockMember(msg.sender, member);
	}

	constructor () public {}
}