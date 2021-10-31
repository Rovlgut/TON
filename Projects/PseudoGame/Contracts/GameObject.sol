pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObjectInterface.sol";

contract GameObject is GameObjectInterface{
    uint defenceStat; // defence power
    address public attackerAddress; // attacker address
    int public health; // health amount

    // Contract 
    constructor() public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        // The current smart contract agrees to buy some gas to finish the
        // current transaction.
        tvm.accept();

    }

    // Getter defence
    function getDefence() public returns (uint){
        tvm.accept();
        return defenceStat;
    }

    // Setter defence
    function setDefence(uint stat) public {
        tvm.accept();
        defenceStat = stat;
    }

    // Getter attack stat
    function getHealth() public returns (int){
        tvm.accept();
        return health;
    }

    // Accept attack.
    function acceptAttack(uint atkStat) virtual external override{
        tvm.accept();
        attackerAddress = msg.sender; // address of attacker
        uint damage = atkStat - defenceStat;
        health = health - int(damage);
        if (isDead()){
            die(); // if dead then call die function
        }

    }

    // Function check if Unit dead
    function isDead() private returns (bool) {
        if (health < 1) {
            return true;
        } else {
            return false;
        }
    }

    // Function die
    function die() virtual public {
        tvm.accept();
        sendAllAndDestroy(); // call self destruction function
    }

    // Self destruction function
    function sendAllAndDestroy() internal {
        attackerAddress.transfer(1, false, 160); // send all crystal and destoy
    }
}