pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObject.sol";
import "BaseStationInterface.sol";
import "MilitaryUnitInterface.sol";

contract BaseStation is GameObject, BaseStationInterface{
    
    address[] public unitsList; // list of address
    mapping (address=>MilitaryUnitInterface) public unitsMap; // Map address to BaseStationInterface

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

        // set stat
        health = 10;
        defenceStat = 1;

    }

    // Die function. Kills base and all units
    function die() public override{
        tvm.accept();
        for (uint i=0; i<unitsList.length; i++){
            unitsMap[unitsList[i]].baseFall(attackerAddress); // call base fall function on all units
        }
        sendAllAndDestroy();
    }    

    // Add military unit
    function addUnit() external override{
        tvm.accept();
        unitsList.push(msg.sender);
        unitsMap[msg.sender] = MilitaryUnitInterface(msg.sender);
    }

    // Remove military unit
    function removeUnit() external override{
        tvm.accept();
        // find element index to remove
        uint indexToRemove;
        for (uint i=0; i<unitsList.length; i++){
            if (unitsList[i] == msg.sender) {                
                indexToRemove = i;
            }
        }
        // remove Unit element
        unitsList[indexToRemove] = unitsList[unitsList.length - 1];
        unitsList.pop();
    }

    // List military units
    function getUnitList() public returns(address[]){
        tvm.accept();
        return unitsList;
    }

}