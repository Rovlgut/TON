pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

/// @title Simple wallet
/// @author Sergey_Gritsay
contract Wallet {
    /*
     Exception codes:
      100 - message sender is not a wallet owner.
      101 - invalid transfer value.
     */

    /// @dev Contract constructor.
    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }


    // Modifier that allows function to accept external call only if it was signed
    // with contract owner's public key.
    modifier checkOwnerAndAccept {
        // Check that inbound message was signed with owner's public key.
        // Runtime function that obtains sender's public key.
        require(msg.pubkey() == tvm.pubkey(), 100);

		// Runtime function that allows contract to process inbound messages spending
		// its own resources (it's necessary if contract should process all inbound messages,
		// not only those that carry value with them).
		tvm.accept();
		_;
	}

    /// @dev Allows to transfer tons to the destination account with fee from sender.
    /// @param dest Transfer target address.
    /// @param value Nanotons value to transfer.
    function sendTransactionWithFee(address dest, uint128 value) public pure checkOwnerAndAccept {
         // Runtime function that allows to make a transfer with fee from sender.
        dest.transfer(value, true, 0);
    }

    /// @dev Allows to transfer tons to the destination account without fee from sender..
    /// @param dest Transfer target address.
    /// @param value Nanotons value to transfer.
    function sendTransactionWithOutFee(address dest, uint128 value) public pure checkOwnerAndAccept {
         // Runtime function that allows to make a transfer without fee from sender.
        dest.transfer(value, true, 1);
    }

    /// @dev Allows to transfer all tons to the destination account and destroys.
    /// @param dest Transfer target address.
    /// @param value Nanotons value to transfer.
    function sendAllAndDestroyed(address dest, uint128 value) public pure checkOwnerAndAccept {
         // Runtime function that allows to make a transfer all and destroys.
        dest.transfer(value, true, 160);
    }
}
