
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "storageInt.sol";

contract storageContract is storageInt {

    uint public storageValue;

    function storeUInt(uint value) public override {
        storageValue = value;
    }
}
