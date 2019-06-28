pragma solidity ^0.4.21;

contract UtilitiesStorage {

	uint public constant ROLE_BIDDER = 1;
	uint public constant ROLE_ADVERTISER = 2;
	uint public constant ROLE_PUBLISHER = 3;
	uint public constant ROLE_VOTER = 4;

	address public CONTRACT_MEMBERS;
	address public CONTRACT_TOKEN;

	//TODO: multiple bidders
	mapping (address => uint256) deposits;
	mapping (address => uint256) paymentsPublisher;
	mapping (address => uint256) paymentsBidder;
}
