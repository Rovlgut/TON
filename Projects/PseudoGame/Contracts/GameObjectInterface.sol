pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

interface GameObjectInterface {
    // Function to Attack
    function acceptAttack(uint atkStat) external;
}