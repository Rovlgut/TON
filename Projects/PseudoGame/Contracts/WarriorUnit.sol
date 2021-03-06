/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "MilitaryUnit.sol";


contract WarriorUnit is MilitaryUnit {


    constructor(BaseStationInterface baseAddress) MilitaryUnit(baseAddress) public {
        health = 6;
        attackStat = 5;
        defenceStat = 4;
    }

}