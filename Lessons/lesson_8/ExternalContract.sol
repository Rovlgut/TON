
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "MyInterface.sol";

// This is class that describes you smart contract.
contract ExternalContract {

    uint32 public myParam;

    // Contract can have a `constructor` – function that will be called when contract will be deployed to the blockchain.
    // In this example constructor adds current time to the instance variable.
    // All contracts need call tvm.accept(); for succeeded deploy
    constructor() public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        // The current smart contract agrees to buy some gas to finish the
        // current transaction. This actions required to process external
        // messages, which bring no value (henceno gas) with themselves.
        tvm.accept();

    }

    modifier checkOwnerAndAccept {
        // Check that message was signed with contract key.
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _;
    }

    function callToPublic(MyInterface myAddress, uint value) public pure checkOwnerAndAccept {
        // Call the remote contract function with parameter
        myAddress.myPublicFunction(value);
    }

    function callToExternal(MyInterface myAddress, uint value) public pure checkOwnerAndAccept {
        // Call the remote contract function with parameter
        myAddress.myExternalFunction(value);
    }

}
