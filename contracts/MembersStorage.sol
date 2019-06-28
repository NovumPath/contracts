pragma solidity ^0.4.21;

contract MembersStorage {

	uint public constant ROLE_BIDDER = 1;
	uint public constant ROLE_ADVERTISER = 2;
	uint public constant ROLE_PUBLISHER = 3;
	uint public constant ROLE_VOTER = 4;

	bool public ALLOW_BIDDERS = false;

	struct Member {
		string name;
		string endpoint;
		uint role;
		bool blocked;
		bool voter;
	}

	mapping (address => Member) members; //TODO: multiple bidders
}
