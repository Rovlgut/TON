pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;


import "base/IShopingList.sol";
import "ShopingListDebot.sol";


contract ShopingListAddDebot is ShopingListDebot {
    
    string m_temp_item; // Temp for name of item
    
    function _menu() internal override{
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
                MenuItem("Add new item","",tvm.functionId(createItem)),
                MenuItem("Show shoping list","",tvm.functionId(showItems)),
                MenuItem("Delete item","",tvm.functionId(deleteItem))
            ]
        );
    }

    function createItem(uint32 index) public {
        index = index;
        Terminal.input(tvm.functionId(createItem_), "What item to buy:", false);
    }

    function createItem_(string value) public {
        m_temp_item = value;
        Terminal.input(tvm.functionId(createItem__), "What quantiy:", false);
    }

    function createItem__(string value) public view {
        (uint256 num,) = stoi(value);
        optional(uint256) pubkey = 0;
        IShopingList(m_address).createItem{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(m_temp_item, uint32(num));
    }

}
