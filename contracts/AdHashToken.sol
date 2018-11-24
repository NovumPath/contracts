pragma solidity ^0.4.4;

import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol';

contract AdHash is ERC20, ERC20Detailed {

	uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** 18);

    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
	constructor () public ERC20Detailed("AdHash Token", "AD", 18) {
		_mint(msg.sender, INITIAL_SUPPLY);
	}
}