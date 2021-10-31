const { Account } = require("@tonclient/appkit");
const {TonClient, signerKeys } = require("@tonclient/core");
const {libNode} = require("@tonclient/lib-node");


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
    // console.log(`${"#".repeat(50)}\nSigner Keys Player1`);
    // console.dir(signerKeys(keysPlayer1));
    // For Player 2
    const keysPlayer2 = await TonClient.default.crypto.generate_random_sign_keys();
    // console.log(`${"#".repeat(50)}\nSigner Keys Player2`);
    // console.dir(signerKeys(keysPlayer2));


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
    // Warrior 2
    await warrior2.deploy({initInput: {baseAddress: addressBase2}, useGiver: true });
    console.log(`Warrior 2 contract was deployed at address: ${addressWarrior2}`);
    // Archer 2
    await archer2.deploy({initInput: {baseAddress: addressBase2}, useGiver: true });
    console.log(`Archer 2 contract was deployed at address: ${addressArcher2}`);

    // Check base unit list
    console.log(`${"#".repeat(50)}\nCheck bases unit list`);
    //Base 1
    let response = await base1.runLocal("getUnitList", {});
    console.log("Unit lists for base 1 getUnitList:", response.decoded.output.value0)
    //Base 2
    response = await base2.runLocal("getUnitList", {});
    console.log("Unit lists for base 2 getUnitList:", response.decoded.output.value0)

    // Run game
    console.log(`${"#".repeat(50)}\nRunning game`);
    // Warrior 2 attacks 🗡 Archer 1
    response = await warrior2.run("attack", {atkAddress: addressArcher1});
    console.log(`Warrior 2 🗡 Archer 1 with output: ${response.decoded.output}, ${response.transaction.id}`);
    // Check Archer 1 health
    response = await archer1.run("getHealth", {});
    console.log(`Archer 1 health is: ${response.decoded.output.value0}`);
    // Archer 2 attacks 🏹 Archer 1
    response = await archer2.run("attack", {atkAddress: addressArcher1});
    console.log(`Archer 2 🏹 Archer 1 with output: ${response.decoded.output}, ${response.transaction.id}`);
    // Check Archer 1 health
    response = await archer1.run("getHealth", {});
    console.log(`Archer 1 health is: ${response.decoded.output.value0}`);
    // Archer 2 🏹 Archer 1
    response = await archer2.run("attack", {atkAddress: addressArcher1});
    console.log(`Archer 2 🏹 Archer 1 with output: ${response.decoded.output}, ${response.transaction.id}`);
   
    // First blood
    console.log(`${"#".repeat(50)}\nArcher 2 kills 💀 Archer 1`); 
    // Check Archer 2 crystals in net    
    let balance = parseInt(await archer2.getBalance(), 16) / 1000000000
    console.log(`Archer 2 balance: ${balance}`);
    // Check base 1 unit list
    response = await base1.run("getUnitList", {});
    console.log("Unit lists for base 1 getUnitList:", response.decoded.output.value0)
    
    
    console.log(`${"#".repeat(50)}\nAttacking base`);
    // Warrior 1 🗡 Base 2
    response = await warrior1.run("attack", {atkAddress: addressBase2});
    console.log(`Warrior 1 🗡 Base 2 with output: ${response.decoded.output}, ${response.transaction.id}`);
    // Check Base 2 health
    response = await base2.run("getHealth", {atkAddress: addressBase2});
    console.log(`Base 2 health is: ${response.decoded.output.value0}`);
    // Warrior 1 🗡 Base 2
    response = await warrior1.run("attack", {atkAddress: addressBase2});
    console.log(`Warrior 1 🗡 Base 2 with output: ${response.decoded.output}, ${response.transaction.id}`);
    // Check Base 2 health
    response = await base2.run("getHealth", {atkAddress: addressBase2});
    console.log(`Base 2 health is: ${response.decoded.output.value0}`);
    // Warrior 1 🗡 Base 2
    response = await warrior1.run("attack", {atkAddress: addressBase2});
    console.log(`Warrior 1 🗡 Base 2 with output: ${response.decoded.output}, ${response.transaction.id}`);

    // Check Warrior 1 crystals in net (manually)
    console.log(`${"#".repeat(50)}\nWarrior 1 kills 💀 Base 2`);   
    balance = parseInt(await warrior1.getBalance(), 16) / 1000000000
    console.log(`Warrior 1 balance: ${balance}`);
    
    

    // console.log((await client.client.version()).version);
}

