const ArcherUnitContract = {
    abi: {
        "ABI version": 2,
        "version": "2.1",
        "header": [
            "time",
            "expire"
        ],
        "functions": [
            {
                "name": "constructor",
                "inputs": [
                    {
                        "name": "baseAddress",
                        "type": "address"
                    }
                ],
                "outputs": []
            },
            {
                "name": "attack",
                "inputs": [
                    {
                        "name": "atkAddress",
                        "type": "address"
                    }
                ],
                "outputs": []
            },
            {
                "name": "getAttack",
                "inputs": [],
                "outputs": [
                    {
                        "name": "value0",
                        "type": "uint256"
                    }
                ]
            },
            {
                "name": "setAttack",
                "inputs": [
                    {
                        "name": "stat",
                        "type": "uint256"
                    }
                ],
                "outputs": []
            },
            {
                "name": "die",
                "inputs": [],
                "outputs": []
            },
            {
                "name": "baseFall",
                "inputs": [
                    {
                        "name": "atkAddress",
                        "type": "address"
                    }
                ],
                "outputs": []
            },
            {
                "name": "getDefence",
                "inputs": [],
                "outputs": [
                    {
                        "name": "value0",
                        "type": "uint256"
                    }
                ]
            },
            {
                "name": "setDefence",
                "inputs": [
                    {
                        "name": "stat",
                        "type": "uint256"
                    }
                ],
                "outputs": []
            },
            {
                "name": "getHealth",
                "inputs": [],
                "outputs": [
                    {
                        "name": "value0",
                        "type": "int256"
                    }
                ]
            },
            {
                "name": "acceptAttack",
                "inputs": [
                    {
                        "name": "atkStat",
                        "type": "uint256"
                    }
                ],
                "outputs": []
            },
            {
                "name": "attackerAddress",
                "inputs": [],
                "outputs": [
                    {
                        "name": "attackerAddress",
                        "type": "address"
                    }
                ]
            },
            {
                "name": "health",
                "inputs": [],
                "outputs": [
                    {
                        "name": "health",
                        "type": "int256"
                    }
                ]
            },
            {
                "name": "baseStationAddress",
                "inputs": [],
                "outputs": [
                    {
                        "name": "baseStationAddress",
                        "type": "address"
                    }
                ]
            },
            {
                "name": "base",
                "inputs": [],
                "outputs": [
                    {
                        "name": "base",
                        "type": "address"
                    }
                ]
            }
        ],
        "data": [],
        "events": [],
        "fields": [
            {
                "name": "_pubkey",
                "type": "uint256"
            },
            {
                "name": "_timestamp",
                "type": "uint64"
            },
            {
                "name": "_constructorFlag",
                "type": "bool"
            },
            {
                "name": "defenceStat",
                "type": "uint256"
            },
            {
                "name": "attackerAddress",
                "type": "address"
            },
            {
                "name": "health",
                "type": "int256"
            },
            {
                "name": "baseStationAddress",
                "type": "address"
            },
            {
                "name": "base",
                "type": "address"
            },
            {
                "name": "attackStat",
                "type": "uint256"
            }
        ]
    },
    tvc: "te6ccgECLgEABksAAgE0AwEBAcACAEPQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgBCSK7VMg4wMgwP/jAiDA/uMC8gsrBQQtAujtRNDXScMB+GaNCGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAT4aSHbPNMAAY4SgQIA1xgg+QFY+EIg+GX5EPKo3tM/AfhDIbnytCD4I4ED6KiCCBt3QKC58rT4Y9MfAfgjvPK50x8B2zzyPBUGA1LtRNDXScMB+GYi0NMD+kAw+GmpOADcIccA4wIh1w0f8rwh4wMB2zzyPCoqBgRQIIIQIvFQ3bvjAiCCEEMb9He74wIgghBxH95su+MCIIIQevjCyLvjAiAYCwcCKCCCEHh21i+64wIgghB6+MLIuuMCCQgBTjDR2zz4TSGOG40EcAAAAAAAAAAAAAAAAD6+MLIgyM7OyXD7AN7yACkDgDD4RvLgTPhCbuMA0ds8IY4oI9DTAfpAMDHIz4cgzo0EAAAAAAAAAAAAAAAAD4dtYvjPFsv/yXD7AJEw4ts88gApCiYACPgA+EoEUCCCEEdWVNy64wIgghBMHZWeuuMCIIIQUnXfA7rjAiCCEHEf3my64wIUEA4MA4Aw+Eby4Ez4Qm7jANHbPCGOKCPQ0wH6QDAxyM+HIM6NBAAAAAAAAAAAAAAAAA8R/ebIzxbK/8lw+wCRMOLbPPIAKQ0mAAj4APhMAzYw+Eby4Ez4Qm7jAPpBldTR0PpA39HbPNs88gApDyYBHvhJ+E3HBfLgZPgA+GvbPCgDKDD4RvLgTPhCbuMA0//R2zzbPPIAKREmAjT4APhJ+Gv4SqG1//hMAbT/obT/+GzbPI6A3hMSAQTbPCcAHHD4TMEBkjB/kjBw4wTZAugw+EJu4wD4RvJz+kGV1NHQ+kDf0fhC8uBl+EUgbpIwcN74Qrry4Gb4APhC8uBl+EUgbpIwcN74Qrry4Gb4ACD4bSD4bsjPhYjOjQVOYloAAAAAAAAAAAAAAAAAACIZO/HAzxbJcPsAdfhsdfhvc/hq2zzyABUmAhbtRNDXScIBio6A4ikWAf5w7UTQ9AVw+GqNCGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAT4a3D4bI0IYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABPhtjQhgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAE+G5wFwAg+G+AQPQO8r3XC//4YnD4YwRQIIIQNIWbDbrjAiCCEDUjTeC64wIgghA+TVnWuuMCIIIQQxv0d7rjAh4cGxkDKDD4RvLgTPhCbuMA0//R2zzbPPIAKRomAAj4APhqAVAw0ds8+EwhjhyNBHAAAAAAAAAAAAAAAAAvk1Z1oMjOyv/JcPsA3vIAKQOAMPhG8uBM+EJu4wDR2zwhjigj0NMB+kAwMcjPhyDOjQQAAAAAAAAAAAAAAAALUjTeCM8Wy//JcPsAkTDi2zzyACkdJgAI+AD4TwM2MPhG8uBM+EJu4wD6QZXU0dD6QN/R2zzbPPIAKR8mAFT4APhPAcjPhYjOjQVOYloAAAAAAAAAAAAAAAAAACYOys9AzxbL/8lw+wAETCCCCUIsUrrjAiCCCfs6aLrjAiCCEBzG7ZW64wIgghAi8VDduuMCJSQjIQMoMPhG8uBM+EJu4wDT/9HbPNs88gApIiYACPgA+G8BTjDR2zz4TiGOG40EcAAAAAAAAAAAAAAAACcxu2VgyM7OyXD7AN7yACkBTjDR2zz4SyGOG40EcAAAAAAAAAAAAAAAACB+zpogyM7OyXD7AN7yACkDJDD4RvLgTPhCbuMA0ds82zzyACknJgBc+E/4TvhN+Ez4S/hK+EP4QsjL/8s/z4PL/1VAyM7K/1UgyM5ZyM7L/83NzcntVAFS+AD4TsjPhYjOjQVOYloAAAAAAAAAAAAAAAAAABxnZXlAzxbJcPsA2zwoAED4S8jPhQjOi/EBAAAAAAAAAAAAAAAAABDPFsmBAKD7AABg7UTQ0//TP9MAMdP/1NHQ+kDS/9TR0PpA1NHQ+kDT/9H4b/hu+G34bPhr+Gr4Y/hiAAr4RvLgTAIK9KQg9KEtLAAUc29sIDAuNTAuMAAA",
    code: "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",
    codeHash: "f8656d606d08b1eed5bba8c8300cecaf0041517e5d91a831760c2cb56220004a",
};
module.exports = { ArcherUnitContract };