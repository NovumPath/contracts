pragma solidity ^0.5.0;

import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol';

contract Token is ERC20, ERC20Detailed, Ownable {

	/**
	 * Initial supply of the currency
	 */
	uint256 public constant INITIAL_SUPPLY = (10 ** 8) * (10 ** 18);

	/**
	 * Constructor that gives msg.sender all of the existing tokens
	 */
	constructor () public ERC20Detailed("AdHash Token", "AD", 18) {
		_mint(msg.sender, INITIAL_SUPPLY);
	}
}
