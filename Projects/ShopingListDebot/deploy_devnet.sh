echo "Compile three contracts (1 contract, 2 DeBot)"
tondev sol compile ShopingListContract.sol
tondev sol compile ShopingListAddDebot.sol
tondev sol compile ShopingListUpdateDebot.sol

echo "Run deploy Bots scripts"
echo "Add Debot"
./deploy_debot_devnet.sh ShopingListAddDebot.tvc | tee test.log
Add_DEBOT_ADDRESS=$(cat test.log | grep "Done!" | cut -d ' ' -f 6)

echo "Update Debot"
./deploy_debot_devnet.sh ShopingListUpdateDebot.tvc | tee test.log
Update_DEBOT_ADDRESS=$(cat test.log | grep "Done!" | cut -d ' ' -f 6)


echo "All done! Debot addresses:"
echo "Add: $Add_DEBOT_ADDRESS"
echo "https://web.ton.surf/debot?address=0%3A${Add_DEBOT_ADDRESS:2}&net=devnet&restart=true"
echo "Update: $Update_DEBOT_ADDRESS"
echo "https://web.ton.surf/debot?address=0%3A${Update_DEBOT_ADDRESS:2}&net=devnet&restart=true"