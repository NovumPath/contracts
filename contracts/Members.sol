pragma solidity ^0.4.4;

import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract AdHashMembers is Ownable {

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
    }

	mapping (address => Member) members; //TODO: multiple bidders

	event RegisterMember(uint role, string name, string endpoint);
	event ChangeInformation(string name, string endpoint);
	event BlockMember(address member);
	event UnblockMember(address member);

	function allowBidders(bool value) public payable { //TODO: OwnerOnly
		ALLOW_BIDDERS = value;
	}

	function registerMember(uint role, string name, string endpoint) public payable { //TODO: Register member on behalf
		if (members[msg.sender].role == 0) {
			revert();
		}
		if (role == ROLE_BIDDER && ALLOW_BIDDERS) {
			members[msg.sender] = Member(name, endpoint, role, false);
		} else if (role == ROLE_ADVERTISER) {
			members[msg.sender] = Member(name, endpoint, role, false);
		} else if (role == ROLE_PUBLISHER) {
			members[msg.sender] = Member(name, endpoint, role, false);
		} else if (role == ROLE_VOTER) {
			members[msg.sender] = Member(name, "", role, false);
		} else {
			revert();
		}
		emit RegisterMember(role, name, endpoint);
	}

	function changeInformation(string name, string endpoint) public payable {
		if (members[msg.sender].role == 0) {
			revert();
		}
		members[msg.sender].name = name;
		members[msg.sender].endpoint = endpoint;
		emit ChangeInformation(name, endpoint);
	}

	function blockMember(address member) public payable {
		if (members[msg.sender].role != ROLE_BIDDER) {
			revert();
		}
		members[msg.sender].blocked = true;
		emit BlockMember(member);
	}

	function unblockMember(address member) public payable {
		if (members[msg.sender].role != ROLE_BIDDER) {
			revert();
		}
		members[msg.sender].blocked = false;
		emit UnblockMember(member);
	}

	constructor () public {}
}