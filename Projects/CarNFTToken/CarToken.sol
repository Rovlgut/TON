
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

// This is class that describes you smart contract.
contract CarToken {

    //NFT-token about Car
    struct Token {
        string brandName; // Brand name of a car
        string modelName; // Unique model name
        uint engineHP;    // Number of engine HP of a car
        string color;     // Color of a car
        bool isManual;    // Bool value if a car have manual transmition or not
        uint value;       // Value of NFT
    }

    mapping (string => Token) tokens; // Map of tokens by name
    mapping (string => uint) tokenToOwner; // Map of onwers by mane
    
    // Modifier that check name uniqueness
    modifier checkIfNameExist (string name) {
        // Проверки на права на создания
        require(tokens[name].modelName == "", 102, "Token exist");
        tvm.accept();
		_;
	}

    // Function that create a token
     function createToken(string brandName, string modelName, uint engineHP, string color, bool isManual) public checkIfNameExist (modelName) {
        tokens[modelName] = Token(brandName, modelName, engineHP, color, isManual, 0);
        tokenToOwner[modelName] = msg.pubkey();
    }

    // Gets information of a token
    function getTokenInfo(string modelName) public view returns (string tokenBrandName, string tokenModelName, 
                                                            uint tokenEngineHP, string tokenColor, 
                                                            bool tokenIsManual, uint tokenValue) {
        tvm.accept();
        tokenBrandName = tokens[modelName].brandName;
        tokenModelName = tokens[modelName].modelName;
        tokenEngineHP = tokens[modelName].engineHP;
        tokenColor = tokens[modelName].color;
        tokenIsManual = tokens[modelName].isManual;
        tokenValue = tokens[modelName].value;
    }  

    // Modifier that allows function to accept external call only if it was signed
    // with contract owner's public key.
    modifier checkOwnerAndAccept (string modelName) {
        // Check that inbound message was signed with owner's public key.
        // Runtime function that obtains sender's public key.
        require(msg.pubkey() == tokenToOwner[modelName], 101);
		// Runtime function that allows contract to process inbound messages spending
		// its own resources (it's necessary if contract should process all inbound messages,
		// not only those that carry value with them).
		tvm.accept();
		_;
	}

    // Get value of token only by owner
    function setValue (string modelName, uint value) public checkOwnerAndAccept(modelName) {
        tvm.accept();
        tokens[modelName].value = value; // Set value of a token
    }



    
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

}