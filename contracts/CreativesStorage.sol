pragma solidity ^0.4.21;

contract CreativesStorage {

	uint public constant ROLE_BIDDER = 1;
	uint public constant ROLE_ADVERTISER = 2;
	uint public constant ROLE_PUBLISHER = 3;
	uint public constant ROLE_VOTER = 4;

	address public CONTRACT_MEMBERS;
	uint public INITIAL_THRESHOLD = 50;
	uint public THRESHOLD_STEP = 10;

	mapping (address => address[]) creatives;
	mapping (address => uint) threshold; //TODO: DIFFERENT PER BIDDER
	mapping (address => bool) blocked; //TODO: DIFFERENT PER BIDDER
}
