# Scripts
Write some scripts for easy testing.
### Wallet
`wallet.sh` deploys multisig wallet into local net
```
tonos-cli --url http://127.0.0.1 multisig deploy --keys keys.json --local 1000000000000000
```
### Deploy
`deploy.sh` compiles 3 sol files (1 contract, 2 DeBot) and deploys 2 DeBots with `deploy_debot.sh` script
### Deploy Debot
`deploy_debot.sh` sligtly modified script from simple ToDo DeBot
### Test
`test.sh <address>` runs DeBot on loca net on given address