pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "base/IShopingList.sol";

contract ShopingListContract is IShopingList{
    
    uint32 m_count;

    mapping(uint32 => Item) m_items;

    uint256 m_ownerPubkey;

    constructor( uint256 pubkey) public {
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = pubkey;
    }

    modifier onlyOwner() {
        require(msg.pubkey() == m_ownerPubkey, 101);
        _;
    }

    // Create item in list
    function createItem(string text, uint32 number) public  onlyOwner override{
        tvm.accept();
        m_count++;
        m_items[m_count] = Item(m_count, text, number, now, false, 0);
    }

    // Update Item to purchased
    function updateItem(uint32 id, uint32 price) public onlyOwner override{
        optional(Item) item = m_items.fetch(id);
        require(item.hasValue(), 102);
        tvm.accept();
        Item thisItem = item.get();
        thisItem.isPaid = true;
        thisItem.price = price;
        m_items[id] = thisItem;
    }

    // Delete item from list
    function deleteItem(uint32 id) public onlyOwner override{
        require(m_items.exists(id), 102);
        tvm.accept();
        delete m_items[id];
    }
    
    //
    // Get methods
    //

    function getItems() public override view returns (Item[] items) {
        string name;
        uint64 createdAt;
        bool isPaid;
        uint32 number;
        uint32 price;

        for((uint32 id, Item item) : m_items) {
            name = item.name;
            isPaid = item.isPaid;
            createdAt = item.createdAt;
            number = item.number;
            price= item.price;
            items.push(Item(id, name, number, createdAt, isPaid, price));
       }
    }

    function getSummary() public override view returns (Summary summary) {
        uint32 isPaidCount;
        uint32 notPaidCount;
        uint32 priceTotal;    

        for((, Item item) : m_items) {
            if  (item.isPaid) {
                isPaidCount ++;
                priceTotal = priceTotal + item.price;
            } else {
                notPaidCount ++;
            }
        }
        summary = Summary( isPaidCount, notPaidCount, priceTotal);
    }

}