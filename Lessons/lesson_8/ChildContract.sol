
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "BaseContract.sol";

// This is class that describes you smart contract.
contract ChildContract is BaseContract{

    function myPublicFunction(uint v) public override {
        tvm.accept();
        // myParam = v + 1;
        setParam(v + 1);
        // save address of callee
        callerAddress = msg.sender;
    }

    function myExternalFunction(uint v) virtual external override {
        tvm.accept();
        myParam = v + 1;
        // save address of callee
        callerAddress = msg.sender;
    }

    function myInternalFunction(uint v) internal override{
        tvm.accept();
        myParam = v + 1;
        // save address of callee
        callerAddress = msg.sender;
    }

}
