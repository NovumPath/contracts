pragma solidity ^0.4.21;

contract UtilitiesStorage {

	uint public constant ROLE_BIDDER = 1;
	uint public constant ROLE_ADVERTISER = 2;
	uint public constant ROLE_PUBLISHER = 3;
	uint public constant ROLE_VOTER = 4;

	address public CONTRACT_MEMBERS;
	address public CONTRACT_TOKEN;

	mapping (address => mapping (address => uint256)) deposits;
}
