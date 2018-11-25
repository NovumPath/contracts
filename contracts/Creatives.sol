pragma solidity ^0.4.4;

import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract Creatives is Ownable {

	mapping (address => address[]) creatives;
	mapping (address => uint) threshold;
	mapping (address => bool) blocked;

	uint public constant INITIAL_THRESHOLD = 30;
	uint public constant THRESHOLD_STEP = 10;

	event AnnounceCreative(address counterparty, address creative);
	event EndBlockCreative(address owner, address creative, uint votesFor, uint votesAgainst);
	event StartBlockCreative(address owner, address creative, string reason);

	function announceCreative(address creative) public payable {
		for (uint i; i < creatives[msg.sender].length; i++) {
			if (creatives[msg.sender][i] == creative) {
				revert("Creative already exists");
			}
		}
		creatives[msg.sender].push(creative);
		emit AnnounceCreative(msg.sender, creative);
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
		//TODO: Check ROLE_BIDDER
		if (votesFor > votesAgainst) {
			blocked[creative] = true;
			//TODO: send deposit to bidder
		} else {
			threshold[creative] += THRESHOLD_STEP;
			//TODO: revert deposit
		}
		emit EndBlockCreative(owner, creative, votesFor, votesAgainst);
	}

	constructor () public {}
}