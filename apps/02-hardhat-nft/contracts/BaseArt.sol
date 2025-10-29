// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BaseArt is ERC721URIStorage, Ownable {
    uint256 private _tokenIdTracker;

    constructor() ERC721("Base Art", "BART") Ownable(msg.sender) {}

    function mintTo(address recipient, string memory tokenURI) external onlyOwner returns (uint256) {
        _tokenIdTracker++;
        uint256 newTokenId = _tokenIdTracker;
        _safeMint(recipient, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        return newTokenId;
    }
}
