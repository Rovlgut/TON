pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

interface IShopingList {

    struct Item {
        uint32 id;
        string name;
        uint32 number;   
        uint64 createdAt; 
        bool isPaid;
        uint32 price;
    }

    struct Summary {
        uint32 isPaidCount;  
        uint32 notPaidCount;
        uint32 priceTotal;
    }

    function createItem(string text, uint32 number) external;
    function updateItem(uint32 id, uint32 price) external;
    function deleteItem(uint32 id) external;
    function getItems() external view returns (Item[] items);
    function getSummary() external view returns (Summary);
}