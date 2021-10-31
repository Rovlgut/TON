const { Account } = require("@tonclient/appkit");
const {TonClient, signerKeys } = require("@tonclient/core");
const {libNode} = require("@tonclient/lib-node");

const readline = require("readline");
const r1 = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

const { BaseStationContract } = require("./Contracts/BaseStationContract.js")
const { WarriorUnitContract } = require("./Contracts/WarriorUnitContract.js")
const { ArcherUnitContract } = require("./Contracts/ArcherUnitContract.js")

TonClient.useBinaryLibrary(libNode);
(async () => {
    const client = new TonClient({
        network: {
            endpoints: ["http://localhost"]
        }
    });
    try {
        console.log("Hello localhost TON!");
        await main(client);
        process.exit(0);
    } catch (error) {
        if (error.code === 504) {
            console.error(`Network is inaccessible. You have to start TON OS SE using \`tondev se start\`.\n If you run SE on another port or ip, replace http://localhost endpoint with http://localhost:port or http://ip:port in index.js file.`);
        } else {
            console.error(error);
        }        
    }
    client.close();
})();

/**
 *
 * @param client {TonClient}
 * @returns {Promise<void>}
 */
async function main(client) {
    // Generate an ed25519 key pair for new account for Player 1
    const keysPlayer1 = await TonClient.default.crypto.generate_random_sign_keys();
    console.log(`${"#".repeat(50)}\nSigner Keys Player1`);
    console.dir(signerKeys(keysPlayer1));
    // For Player 2
    const keysPlayer2 = await TonClient.default.crypto.generate_random_sign_keys();
    console.log(`${"#".repeat(50)}\nSigner Keys Player2`);
    console.dir(signerKeys(keysPlayer2));
    // ##############################
    // For Player 12
    const keysPlayer12 = await TonClient.default.crypto.generate_random_sign_keys();
    // ##############################

    //Creating accounts for game
    console.log(`${"#".repeat(50)}\nCreating accounts`);
    // Account for base player1
    const base1 = new Account(BaseStationContract, {
        signer: signerKeys(keysPlayer1),
        client,
    });
    // Account for warrior unit player1
    const warrior1 = new Account(WarriorUnitContract, {
        signer: signerKeys(keysPlayer1),
        client,
    });
    // Account for archer unit player1
    const archer1 = new Account(ArcherUnitContract, {
        signer: signerKeys(keysPlayer1),
        client,
    });
    // ############################
    // Account for warrior 2 unit player1
    const warrior12 = new Account(WarriorUnitContract, {
        signer: signerKeys(keysPlayer12),
        client,
    });
    // Account for archer 2 unit player1
    const archer12 = new Account(ArcherUnitContract, {
        signer: signerKeys(keysPlayer12),
        client,
    });
    // ###########################
    // Same for player2
    // Base player2
    const base2 = new Account(BaseStationContract, {
        signer: signerKeys(keysPlayer2),
        client,
    });
    // warrior unit player2
    const warrior2 = new Account(WarriorUnitContract, {
        signer: signerKeys(keysPlayer2),
        client,
    });
    // archer unit player2
    const archer2 = new Account(ArcherUnitContract, {
        signer: signerKeys(keysPlayer2),
        client,
    });
    // Console output all address
    // Base 1
    const addressBase1 = await base1.getAddress();
    console.log(`Address of the contract Base 1 will be: ${addressBase1}`);
    // Warrior 1
    const addressWarrior1 = await warrior1.getAddress();
    console.log(`Address of the contract Warrior 1 will be: ${addressWarrior1}`);
    // Archer 1
    const addressArcher1 = await archer1.getAddress();
    console.log(`Address of the contract Archer 1 will be: ${addressArcher1}`);
    // ##############################
    // Warrior 12
    const addressWarrior12 = await warrior12.getAddress();
    console.log(`Address of the contract Warrior 12 will be: ${addressWarrior12}`);
    // Archer 12
    const addressArcher12 = await archer12.getAddress();
    console.log(`Address of the contract Archer 12 will be: ${addressArcher12}`);
    // ##############################
    // Base 2
    const addressBase2 = await base2.getAddress();
    console.log(`Address of the contract Base 2 will be: ${addressBase2}`);
    // Warrior 2
    const addressWarrior2 = await warrior2.getAddress();
    console.log(`Address of the contract Warrior 2 will be: ${addressWarrior2}`);
    // Archer 2
    const addressArcher2 = await archer2.getAddress();
    console.log(`Address of the contract Archer 2 will be: ${addressArcher2}`);

    // Deploy contracts
    console.log(`${"#".repeat(50)}\nDeploying accounts`);
    // Base 1
    console.log(`${"#".repeat(50)}\nBase 1`);
    await base1.deploy({ useGiver: true });
    console.log(`Base 1 contract was deployed at address: ${addressBase1}`);
    // Warrior 1
    await warrior1.deploy({initInput: {baseAddress: addressBase1}, useGiver: true });
    console.log(`Warrior 1 contract was deployed at address: ${addressWarrior1}`);
    // Archer 1
    await archer1.deploy({initInput: {baseAddress: addressBase1}, useGiver: true });
    console.log(`Archer 1 contract was deployed at address: ${addressArcher1}`);
    // Base 2
    console.log(`${"#".repeat(50)}\nBase 2`);
    await base2.deploy({ useGiver: true });
    console.log(`Base 2 contract was deployed at address: ${addressBase2}`);


    // Check base unit list
    console.log(`${"#".repeat(50)}\nCheck bases unit list`);
    //Base 1
    let response = await base1.runLocal("getUnitList", {});
    console.log("Unit lists for base 1 getUnitList:", response.decoded.output)

    // Run game
    console.log(`${"#".repeat(50)}\nAttacking base`);
    // Warrior 1 🗡 Base 2
    response = await warrior1.run("attack", {atkAddress: addressBase2});
    console.log(`Contract Warrior 1 🗡 Base 2 with output ${response.decoded.output}, ${response.transaction.id}`);
    // Check Base 2 health
    response = await base2.run("getHealth", {atkAddress: addressBase2});
    console.log(`Contract Base 2 check health with output ${response.decoded.output.value0}, ${response.transaction.id}`);
    // Warrior 1 🗡 Base 2
    response = await warrior1.run("attack", {atkAddress: addressBase2});
    console.log(`Contract Warrior 1 🗡 Base 2 with output ${response.decoded.output}, ${response.transaction.id}`);
    // Check Base 2 health
    response = await base2.run("getHealth", {atkAddress: addressBase2});
    console.log(`Contract Base 2 check health with output ${response.decoded.output.value0}, ${response.transaction.id}`);
    // Warrior 1 🗡 Base 2
    response = await warrior1.run("attack", {atkAddress: addressBase2});
    console.log(`Contract Warrior 1 🗡 Base 2 with output ${response.decoded.output}, ${response.transaction.id}`);
    
   
    // Check base 1 unit list
    // console.log(`${"#".repeat(50)}\nCheck base 1 unit list`); 
    // response = await base1.run("getUnitList", {});
    // console.log("Unit lists for base 1 getUnitList:", response.decoded.output)
    // Check Archer 2 crystals in net (manually)   
    // const ans = await waitInput(`Check Archer 2 address::${addressArcher2}`);
    // console.log(`Ok, lets continue ${ans}`);



    // console.log((await client.client.version()).version);
}

// function waitInput(query) {
//     return new Promise(resolve => r1.question(query, ans => {
//         r1.close();
//         resolve(ans);
//     }))
// }
