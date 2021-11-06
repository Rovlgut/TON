pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "base/Debot.sol";
import "base/Terminal.sol";
import "base/Menu.sol";
import "base/AddressInput.sol";
import "base/ConfirmInput.sol";
import "base/Upgradable.sol";
import "base/Sdk.sol";

import "base/ITransactable.sol";
import "base/HasConstructorWithPubKey.sol";


abstract contract AShopingDebot is Debot, Upgradable {
    bytes m_icon;

    TvmCell m_shopingListCode; // Shoping list contract code
    address m_address;  // Shoping list contract address
    uint256 m_masterPubKey; // User pubkey
    address m_msigAddress;  // User wallet address


    uint32 INITIAL_BALANCE =  200000000;  // Initial shoping list contract balance


    function setShopingCode(TvmCell code) public {
        require(msg.pubkey() == tvm.pubkey(), 101);
        tvm.accept();
        m_shopingListCode = code;
    }


    function onError(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
        
    }


    function _endMsg() public {
        Terminal.print(0, "Shoping list contract is deployed. You can use Add bot to add items to the list. And use Update bot to update purchases");
    }

    function start() public override {
        Terminal.input(tvm.functionId(savePublicKey),"Please enter your public key",false);
    }
    
    /// @notice Returns Metadata about DeBot.
    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Shoping DeBot";
        version = "0.2.0";
        publisher = "None";
        key = "Shoping list manager";
        author = "Sergey";
        support = address.makeAddrStd(0, 0x66e01d6df5a8d7677d9ab2daf7f258f1e2a7fe73da5320300395f99e01dc3b5f);
        hello = "Hi, i'm a Shoping list DeBot.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = m_icon;
    }

    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID, Menu.ID, AddressInput.ID, ConfirmInput.ID ];
    }

    function savePublicKey(string value) public {
        (uint res, bool status) = stoi("0x"+value);
        if (status) {
            m_masterPubKey = res;

            Terminal.print(0, "Checking if you already have a shoping list ...");
            TvmCell deployState = tvm.insertPubkey(m_shopingListCode, m_masterPubKey);
            m_address = address.makeAddrStd(0, tvm.hash(deployState));
            Terminal.print(0, format( "Info: your shoping list contract address is {}", m_address));
            Sdk.getAccountType(tvm.functionId(checkStatus), m_address);

        } else {
            Terminal.input(tvm.functionId(savePublicKey),"Wrong public key. Try again!\nPlease enter your public key",false);
        }
    }


    function checkStatus(int8 acc_type) public virtual{
        if (acc_type == 1) { // acc is active and  contract is already deployed
            Terminal.print(0, "You have a Shoping list yet. You can use Shoping list Add bot to add items to the list. And use Shoping list Update bot to update purchases"); 

        } else if (acc_type == -1)  { // acc is inactive
            Terminal.print(0, "You don't have a Shoping  list yet, so a new contract with an initial balance of 0.2 tokens will be deployed");
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


    function creditAccount(address value) public {
        m_msigAddress = value;
        optional(uint256) pubkey = 0;
        TvmCell empty;
        ITransactable(m_msigAddress).sendTransaction{
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(waitBeforeDeploy),
            onErrorId: tvm.functionId(onErrorRepeatCredit)  // Just repeat if something went wrong
        }(m_address, INITIAL_BALANCE, false, 3, empty);
    }

    function onErrorRepeatCredit(uint32 sdkError, uint32 exitCode) public {        
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
        sdkError;
        exitCode;
        creditAccount(m_msigAddress);
    }


    function waitBeforeDeploy() public  {
        Sdk.getAccountType(tvm.functionId(checkIfStatusIs0), m_address);
    }

    function checkIfStatusIs0(int8 acc_type) public {
        if (acc_type ==  0) {
            deploy();
        } else {
            waitBeforeDeploy();
        }
    }


    function deploy() internal view virtual{
            TvmCell image = tvm.insertPubkey(m_shopingListCode, m_masterPubKey);
            optional(uint256) none;
            TvmCell deployMsg = tvm.buildExtMsg({
                abiVer: 2,
                dest: m_address,
                callbackId: tvm.functionId(_endMsg),
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


    function onErrorRepeatDeploy(uint32 sdkError, uint32 exitCode) public view {        
        sdkError;
        exitCode;
        deploy();
    }

    
    function onCodeUpgrade() internal override {
        tvm.resetStorage();
    }
}
