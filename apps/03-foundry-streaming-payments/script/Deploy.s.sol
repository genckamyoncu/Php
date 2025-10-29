// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Script.sol";
import {StreamingPayments} from "src/StreamingPayments.sol";

contract DeployStreamingPayments is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(pk);
        new StreamingPayments();
        vm.stopBroadcast();
    }
}
