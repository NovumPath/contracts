pragma solidity ^0.4.4;

import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';
import '../node_modules/zeppelin-solidity/contracts/token/StandardToken.sol';
import '../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol';

contract TestCoin is StandardToken, Ownable {

	//Token properties
	string public constant name = "Adtrader Token";
	string public constant symbol = "ADT";
	uint8 public constant decimals = 18;

	//Total amount of tokens
	uint public totalSupply = 0;

	//Start and end timestamps where investments are allowed
	uint256 public startTime;
	uint256 public endTime;

	//How many token units a buyer gets per wei
	uint256 public rate;

	//Address where funds are collected
	address public wallet;

	/**
	 * @dev Constructor that gives msg.sender all of existing tokens.
	 */
	function SimpleToken(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
		require(_startTime >= now);
		require(_endTime >= _startTime);
		require(_rate > 0);
		require(_wallet != address(0));

		startTime = _startTime;
		endTime = _endTime;
		rate = _rate;
		wallet = _wallet;
	}

	//@return true if the transaction can buy tokens
	function validPurchase() internal view returns (bool) {
		bool withinPeriod = now >= startTime && now <= endTime;
		bool nonZeroPurchase = msg.value != 0;
		return withinPeriod && nonZeroPurchase;
	}

	//Low level token purchase function
	function buyTokens(address beneficiary) public payable {
		require(beneficiary != address(0));
		require(validPurchase());

		uint256 weiAmount = msg.value;
		uint256 tokens = weiAmount.mul(rate);

		totalSupply = totalSupply.add(tokens);

		balances[msg.sender] = balances[msg.sender].add(tokens);

		wallet.transfer(msg.value);
	}

	//Fallback function can be used to buy tokens
	function () external payable {
		buyTokens(msg.sender);
	}
}