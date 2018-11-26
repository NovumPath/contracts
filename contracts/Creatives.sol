pragma solidity ^0.4.4;

import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract Creatives is Ownable {

	mapping (address => address[]) creatives;
	mapping (address => uint) threshold; //TODO: DIFFERENT PER BIDDER
	mapping (address => bool) blocked; //TODO: DIFFERENT PER BIDDER

	uint public constant INITIAL_THRESHOLD = 30;
	uint public constant THRESHOLD_STEP = 10;

	event AnnounceCreative(address counterparty, address creative);
	event EndBlockCreative(address owner, address creative, uint votesFor, uint votesAgainst);
	event StartBlockCreative(address owner, address creative, string reason);

	function announceCreative(address creative) public payable {
		creatives[msg.sender].push(creative);
		emit AnnounceCreative(msg.sender, creative);
	}

	function announceCreatives(address[] creativesList) public payable {
		for (uint j; j < creativesList.length; j++) {
			creatives[msg.sender].push(creativesList[j]);
			emit AnnounceCreative(msg.sender, creativesList[j]);
		}
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
		//TODO: UPDATE FORMULAS
		if (votesFor > votesAgainst) {
			blocked[creative] = true;
			//TODO: revert deposit to author
		} else {
			threshold[creative] += THRESHOLD_STEP;
			//TODO: send deposit to voters wallet
		}
		emit EndBlockCreative(owner, creative, votesFor, votesAgainst);
	}

	constructor () public {}
}