# The AdHash Smart Contracts

![AdHash](https://raw.githubusercontent.com/AdHashProtocol/contracts/master/static/logo.png)

The AdHash Protocol Smart Contracts and examples to use in JavaScript.

## File structure

* **contracts** contains all smart contracts
* **samples** contains generic JS sample files
* [package.json](package.json) contains installation scripts and scripts to run the test network.

**Token.sol**
- ERC20 token based on OpenZeppelin implementation.
- Initial supply 100M AD tokens.

**MembersStorage.sol**
- Interface for members contract.
- Role constants.
- ALLOW_BIDDERS flag.
- Member structure.
- Mapping for members (address => Member).

**MembersRegistry.sol**
- Proxy contract that forwards all calls to the actual Members contract.
- CONTRACT_ADDRESS address of the actual Members contract.
- Option for the owner to set CONTRACT_ADDRESS.
- Assembly function that forwards any call to the contract in CONTRACT_ADDRESS.
The reason is customers will call MembersRegistry and it will forward it to CONTRACT_ADDRESS.
If we find a bug in CONTRACT_ADDRESS we can replace it with new one and users will still call MembersRegistry.

**MembersV1.sol**
First version of the Members contract. MembersRegistry will point here. Inherits MembersStorage.
- Option to set ALLOW_BIDDERS (only owner).
- Option to register as a new member via registerMember.
- Option for BIDDER roles to register other members via registerMemberOnBehalf.
- Getter methods for Members and Member role only.
- Option to change your own information via changeInformation.
- Option for BIDDER roles to set information for members on behalf via changeInformationOnBehalf.
- Option to set your own voting flag.
- Option for BIDDER roles to block/unblock members.
- Option to transfer funds or ERC20 tokens back to the owner (for unintentional deposits).

**CreativesStorage.sol**
- Role constants.
- Address of the MembersRegistry contract (CONTRACT_MEMBERS).
- Address of the ERC20 contract (CONTRACT_TOKEN).
- Address of the voter pool where all confiscated deposits will be sent (VOTER_POOL).
- INITIAL_THRESHOLD, THRESHOLD_STEP, BLOCK_DEPOSIT and MAJORITY for voting puroses.
- Mapping creativeOwner (address => address) for creative owners. First address is a wallet address, second is a SHA1 hash from our system.
- Mapping creatives (address => address[]) for a list of all creatives for a certain wallet ID.
- Mapping threshold (address => uint) for voting thresholds. Address is a SHA1 hash from our system, uint is a number starting from INITIAL_THRESHOLD.
- Mapping blocked (address => bool) for blocked members.

**CreativesRegistry.sol**
- Proxy contract that forwards all calls to the actual Creatives contract.
- CONTRACT_ADDRESS address of the actual Creatives contract.
- Option for the owner to set CONTRACT_ADDRESS.
- Assembly function that forwards any call to the contract in CONTRACT_ADDRESS. Same idea as MembersRegistry.

**CreativesV1.sol**
- Option for owners to set CONTRACT_MEMBERS to point to MembersRegistry.
- Option for owners to set CONTRACT_TOKEN to point to Token.
- Option for owners to set VOTER_POOL.
- Option for owners to set INITIAL_THRESHOLD, THRESHOLD_STEP, BLOCK_DEPOSIT and MAJORITY for voting puroses.
- Option to announce creative(s) via announceCreative or announceCreatives.
- Option for BIDDER roles to announce creative(s) on behalf via announceCreativeOnBehalf or announceCreativesOnBehalf.
- Option to get creatives for wallet ID via getCreatives.
- Option to get creative blocked status via getBlockedStatus.
- Option to get a creative's first owner.
- Option to start a voting via startBlockCreative. Parameters are:
	- wallet ID of the creative owner
	- creative SHA1 hash from our system
	- reason - free text explaining the reason for the vote
	Takes BLOCK_DEPOSIT amount of Tokens from your account.
	Requires the caller to have called Token.approve(CreativesRegistry, Amount) first
- Option for owner to call endBlockCreative. Parameters are:
	- wallet ID of the voting initiator
	- wallet ID of the creative owner
	- creative SHA1 hash from our system
	- amount of votes FOR
	- amount of votes AGAINST
	Based on the voting if votes FOR are 66.6% (MAJORITY) or more - the creative is marked as blocked.
	If the voting ended as FOR - the amount is returned to initiator. Else the amount is sent to the voting pool.
	This contract shuold own the ERC20 tokens only for the currently active votes.
- Option to transfer funds or ERC20 tokens back to the owner (for unintentional deposits).

**UtilitiesStorage.sol**
- Role constants.
- Address of the MembersRegistry contract (CONTRACT_MEMBERS).
- Address of the ERC20 contract (CONTRACT_TOKEN).
- Mapping (address => address => uint256) for storing deposits.
The deposits' first address is the bidder address. Second address is the owner address. uint256 is the amount. You can have multiple deposits (for multiple bidders).

**UtilitiesRegistry.sol**
- Proxy contract that forwards all calls to the actual Utilities contract.
- CONTRACT_ADDRESS address of the actual Utilities contract.
- Option for the owner to set CONTRACT_ADDRESS.
- Assembly function that forwards any call to the contract in CONTRACT_ADDRESS. Same idea as MembersRegistry.

**UtilitiesV1.sol**
- Option for owners to set CONTRACT_MEMBERS to point to MembersRegistry.
- Option for owners to set CONTRACT_TOKEN to point to Token.
- Option to make a deposit for a certain bidder via makeDeposit.
- Option for bidders only to withdraw deposit assigned to them sending them back to the advertiser.
- Option for bidders only to fine advertisers, taking some of their deposit.
- Option to get the deposit for a certain advertiser and bidder via getDeposit.
- Option to register a payment from a bidder to a publisher.
- Option to register a payment from an advertiser to a bidder.
- Option to transfer funds or ERC20 tokens back to the owner (for unintentional deposits).
For deposits and payments it is reqired the caller to have called Token.approve(UtilitiesRegistry, Amount) first.

## License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.
