pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;


import "base/IShopingList.sol";
import "AShopingDebot.sol";


contract ShopingListDebot is AShopingDebot {
    
    IShopingList.Summary m_summary;        // Statistics of incompleted and completed tasks


    function onSuccess() public view {
        _getStat(tvm.functionId(setStat));
    }


    function checkStatus(int8 acc_type) public override{
        if (acc_type == 1) { // acc is active and  contract is already deployed
            _getStat(tvm.functionId(setStat));

        } else if (acc_type == -1)  { // acc is inactive
            Terminal.print(0, "You don't have a Shopping  list yet, so a new contract with an initial balance of 0.2 tokens will be deployed");
            AddressInput.get(tvm.functionId(creditAccount),"Select a wallet for payment. We will ask you to sign two transactions");

        } else  if (acc_type == 0) { // acc is uninitialized
            Terminal.print(0, format(
                "Deploying new contract. If an error occurs, check if your shoping list contract has enough tokens on its balance"
            ));
            deploy();

        } else if (acc_type == 2) {  // acc is frozen
            Terminal.print(0, format("Can not continue: account {} is frozen", m_address));
        }
    }


    function setStat(IShopingList.Summary stat) public {
        m_summary = stat;
        _menu();
    }

    function _menu() internal virtual{
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
                MenuItem("Show shoping list","",tvm.functionId(showItems)),
                MenuItem("Delete item","",tvm.functionId(deleteItem))
            ]
        );
    }

    
    function showItems(uint32 index) public view {
        index = index;
        optional(uint256) none;
        IShopingList(m_address).getItems{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showItems_),
            onErrorId: 0
        }();
    }

    function showItems_( IShopingList.Item[] tasks ) public {
        uint32 i;
        if (tasks.length > 0 ) {
            Terminal.print(0, "Your shoping list:");
            for (i = 0; i < tasks.length; i++) {
                IShopingList.Item task = tasks[i];
                string completed;
                string price;
                if (task.isPaid) {
                    completed = '✓';
                    price = format("price {}💎", task.price);
                } else {
                    completed = ' ';
                    price = '';
                }
                Terminal.print(0, format("{} {}  {}-{} {} at {}", task.id, completed, task.number, task.name, price, task.createdAt));
            }
        } else {
            Terminal.print(0, "Your shoping list is empty");
        }
        _menu();
    }

    
    function deleteItem(uint32 index) public {
        index = index;
        if (m_summary.isPaidCount + m_summary.notPaidCount > 0) {
            Terminal.input(tvm.functionId(deleteItem_), "Enter item number:", false);
        } else {
            Terminal.print(0, "Sorry, you have no tasks to delete");
            _menu();
        }
    }

    function deleteItem_(string value) public view {
        (uint256 num,) = stoi(value);
        optional(uint256) pubkey = 0;
        IShopingList(m_address).deleteItem{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(uint32(num));
    }

    function _getStat(uint32 answerId) internal view {
        optional(uint256) none;
        IShopingList(m_address).getSummary{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: answerId,
            onErrorId: 0
        }();
    }

    function deploy() internal view override{
            TvmCell image = tvm.insertPubkey(m_shopingListCode, m_masterPubKey);
            optional(uint256) none;
            TvmCell deployMsg = tvm.buildExtMsg({
                abiVer: 2,
                dest: m_address,
                callbackId: tvm.functionId(onSuccess),
                onErrorId:  tvm.functionId(onErrorRepeatDeploy),    // Just repeat if something went wrong
                time: 0,
                expire: 0,
                sign: true,
                pubkey: none,
                stateInit: image,
                call: {HasConstructorWithPubKey, m_masterPubKey}
            });
            tvm.sendrawmsg(deployMsg, 1);
    }

}
