// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/console.sol";

contract IdentityRegistry {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");
    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR");

    mapping(bytes32 => mapping(address => bool)) private _roles;
    mapping(address => string) public metadata;

    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
    event MetadataUpdated(address indexed account, string data);

    modifier onlyRole(bytes32 role) {
        require(hasRole(role, msg.sender), "missing role");
        _;
    }

    constructor() {
        _grantRole(ADMIN_ROLE, msg.sender);
    }

    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role][account];
    }

    function grantRole(bytes32 role, address account) external onlyRole(ADMIN_ROLE) {
        _grantRole(role, account);
    }

    function revokeRole(bytes32 role, address account) external onlyRole(ADMIN_ROLE) {
        _roles[role][account] = false;
        emit RoleRevoked(role, account, msg.sender);
    }

    function registerCreator(string calldata data) external onlyRole(CREATOR_ROLE) {
        metadata[msg.sender] = data;
        emit MetadataUpdated(msg.sender, data);
    }

    function selfRenounce(bytes32 role) external {
        require(hasRole(role, msg.sender), "role missing");
        _roles[role][msg.sender] = false;
        emit RoleRevoked(role, msg.sender, msg.sender);
    }

    function _grantRole(bytes32 role, address account) internal {
        if (!_roles[role][account]) {
            _roles[role][account] = true;
            emit RoleGranted(role, account, msg.sender);
        }
    }
}
