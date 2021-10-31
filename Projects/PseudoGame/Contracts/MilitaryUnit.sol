pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObject.sol";
import "BaseStationInterface.sol";
import "MilitaryUnitInterface.sol";


contract MilitaryUnit is GameObject, MilitaryUnitInterface {

    address public baseStationAddress;
    BaseStationInterface public base;
    uint attackStat;

    // Contract construct
    constructor(address baseAddress) public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        // The current smart contract agrees to buy some gas to finish the
        // current transaction.
        tvm.accept();

        baseStationAddress = baseAddress;
        base = BaseStationInterface(baseStationAddress);
        base.addUnit();
    }

    // Make an attack
    function attack(GameObjectInterface atkAddress) public {
        tvm.accept();
        atkAddress.acceptAttack(attackStat); // send attack with attack Stat
    }

    // Getter attack stat
    function getAttack() public returns (uint){
        tvm.accept();
        return attackStat;
    }

    // Setter attack stat
    function setAttack(uint stat) public {
        tvm.accept();
        attackStat = stat;
    }

    // Die function
    function die() public override{ 
        tvm.accept();
        base.removeUnit(); // tells base ro remove myself
        sendAllAndDestroy(); // and send all to attacker and destroys
    }

    modifier onlyOwnBase {
        require (msg.sender == baseStationAddress); // check if its own base
        tvm.accept();
        _;
    }
    // Function if base fall
    function baseFall(address atkAddress) onlyOwnBase external override{ 
        attackerAddress = atkAddress; // set attacker to who destroyed base
        sendAllAndDestroy(); // send all to base attacker and destroys
    }    

}