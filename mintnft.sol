// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    uint256 private _tokenIdCounter;

    constructor() ERC721("MyNFT", "MNFT") Ownable(msg.sender) {}  // <-- Fix: Pass `msg.sender` to Ownable

    function mint() public returns (uint256) {
        _tokenIdCounter++;
        _safeMint(msg.sender, _tokenIdCounter);
        return _tokenIdCounter;
    }

    function burn(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        _burn(tokenId);
    }
}