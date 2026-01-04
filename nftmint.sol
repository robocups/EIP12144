// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract PublicNFT is ERC721URIStorage {
    uint256 private _nextTokenId;

    constructor() ERC721("PublicNFT", "PNFT") {}

    function mint(string memory uri) public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);
    }
}