const BaseStationContract = {
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
                "inputs": [],
                "outputs": []
            },
            {
                "name": "die",
                "inputs": [],
                "outputs": []
            },
            {
                "name": "addUnit",
                "inputs": [],
                "outputs": []
            },
            {
                "name": "removeUnit",
                "inputs": [],
                "outputs": []
            },
            {
                "name": "getUnitList",
                "inputs": [],
                "outputs": [
                    {
                        "name": "value0",
                        "type": "address[]"
                    }
                ]
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
                "name": "unitsList",
                "inputs": [],
                "outputs": [
                    {
                        "name": "unitsList",
                        "type": "address[]"
                    }
                ]
            },
            {
                "name": "unitsMap",
                "inputs": [],
                "outputs": [
                    {
                        "name": "unitsMap",
                        "type": "map(address,address)"
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
                "name": "unitsList",
                "type": "address[]"
            },
            {
                "name": "unitsMap",
                "type": "map(address,address)"
            }
        ]
    },
    tvc: "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",
    code: "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",
    codeHash: "76ae0211caa0852cbd78cff7e6635bb3f2671e4cbe539a53a9ea3ccbb5982d23",
};
module.exports = { BaseStationContract };