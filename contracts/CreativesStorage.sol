pragma solidity ^0.4.21;

contract CreativesStorage {

	uint public constant ROLE_BIDDER = 1;
	uint public constant ROLE_ADVERTISER = 2;
	uint public constant ROLE_PUBLISHER = 3;
	uint public constant ROLE_VOTER = 4;

	address public CONTRACT_MEMBERS;
	address public CONTRACT_TOKEN;
	address public VOTER_POOL;

	uint public INITIAL_THRESHOLD = 50;
	uint public THRESHOLD_STEP = 10;
	uint public BLOCK_DEPOSIT = 10000000000000000; //0.01 ADT
	uint public MAJORITY = 666; // 0.666 considered as supermajority

	mapping (address => address) creativeOwner;
	mapping (address => address[]) creatives;
	mapping (address => uint) threshold;
	mapping (address => bool) blocked;
}
