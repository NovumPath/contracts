pragma solidity ^0.4.21;

import './MembersStorage.sol';
import '../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract MembersRegistry is MembersStorage, Ownable {

	address private CONTRACT_ADDRESS;

    function setContractAddress(address newContractAddress) public onlyOwner {
        CONTRACT_ADDRESS = newContractAddress;
    }

    function () payable public {
        address target = CONTRACT_ADDRESS;
        assembly {
            // Copy the data sent to the memory address starting free mem position
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize)
            // Proxy the call to the contract address with the provided gas and data
            let result := delegatecall(gas, target, ptr, calldatasize, 0, 0)
            // Copy the data returned by the proxied call to memory
            let size := returndatasize
            returndatacopy(ptr, 0, size)
            // Check what the result is, return and revert accordingly
            switch result
            case 0 { revert(ptr, size) }
            case 1 { return(ptr, size) }
        }
    }
}
