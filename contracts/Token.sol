pragma solidity ^0.4.21;

import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol';

contract Token is ERC20, ERC20Detailed, Ownable {

	/**
	 * Initial supply of the currency
	 */
	uint256 public constant INITIAL_SUPPLY = (10 ** 9) * (10 ** 18);

	/**
	 * Marker for which days the minting is already collected
	 */
	mapping (uint => bool) minted;

	/**
	 * Marker for the deployment time of the contract
	 */
	uint deployment;

	/**
	 * Constructor that gives msg.sender all of existing tokens.
	 */
	constructor () public ERC20Detailed("AdHash Token", "AD", 18) {
		_mint(msg.sender, INITIAL_SUPPLY);
		deployment = now;
	}

	/**
	 * Minting the inflation to the owner of the contract
	 */
	function mint(uint day) public payable onlyOwner {
		if (now > deployment + day * 86400 && minted[day] == false) {
			minted[day] = true;
			uint256 toMint = 0;
			if (day >= 365 * 0 && day < 365 * 1) {
				// First year - 10% inflation - 1.000262 ^ 365
				toMint += (totalSupply() * 262 / 1000000);
			} else if (day >= 365 * 1 && day < 365 * 2) {
				// Second year - 8% inflation - 1.000211 ^ 365
				toMint += (totalSupply() * 211 / 1000000);
			} else if (day >= 365 * 2 && day < 365 * 3) {
				// 3rd year - 6% inflation - 1.000160 ^ 365
				toMint += (totalSupply() * 160 / 1000000);
			} else if (day >= 365 * 3 && day < 365 * 4) {
				// 4th year - 4% inflation - 1.000108 ^ 365
				toMint += (totalSupply() * 108 / 1000000);
			} else if (day >= 365 * 4 && day < 365 * 5) {
				// 5th year - 3% inflation - 1.000081 ^ 365
				toMint += (totalSupply() * 81 / 1000000);
			} else if (day >= 365 * 5) {
				// Any other year - 2% inflation - 1.000054 ^ 365
				toMint += (totalSupply() * 54 / 1000000);
			}
			_mint(msg.sender, toMint);
		} else {
			revert("Minting not possible");
		}
	}
}
