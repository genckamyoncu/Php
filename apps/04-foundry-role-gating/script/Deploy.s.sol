// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Script.sol";
import {IdentityRegistry} from "src/IdentityRegistry.sol";

contract DeployIdentityRegistry is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(pk);
        new IdentityRegistry();
        vm.stopBroadcast();
    }
}
