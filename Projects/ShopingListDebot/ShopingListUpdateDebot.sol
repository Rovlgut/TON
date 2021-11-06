pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;


import "base/IShopingList.sol";
import "ShopingListDebot.sol";


contract ShopingListUpdateDebot is ShopingListDebot {
    
    
    uint32 m_itemId;    // Item id for update. I didn't find a way to make this var local
    string m_temp_item; // Temp for name of item


    function _menu() internal override {
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have to buy {} items. Already bought {} items for {} total amount",
                    m_summary.notPaidCount,
                    m_summary.isPaidCount,
                    m_summary.priceTotal
            ),
            sep,
            [
                MenuItem("Update what bought","",tvm.functionId(updateItem)),
                MenuItem("Show shoping list","",tvm.functionId(showItems)),
                MenuItem("Delete item","",tvm.functionId(deleteItem))
            ]
        );
    }

    function updateItem(uint32 index) public {
        index = index;
        if (m_summary.isPaidCount + m_summary.notPaidCount > 0) {
            Terminal.input(tvm.functionId(updateItem_), "Enter item number:", false);
        } else {
            Terminal.print(0, "Sorry, you have no tasks to update");
            _menu();
        }
    }

    function updateItem_(string value) public {
        (uint256 num,) = stoi(value);
        m_itemId = uint32(num);
        Terminal.input(tvm.functionId(updateItem__), "Enter price:", false);
    }
    

    function updateItem__(string value) public view {
        (uint256 price,) = stoi(value);
        optional(uint256) pubkey = 0;
        IShopingList(m_address).updateItem{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(m_itemId, uint32(price));
    }
    
}
