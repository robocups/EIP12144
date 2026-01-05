// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/utils/Counters.sol";

contract NFTMarketplace is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    mapping(uint256 => uint256) public listings; // tokenId to price

    constructor() ERC721("ProNFT", "PNFT") {}

    function mintNFT(string memory uri) public payable {
        require(msg.value >= 0.000000001 ether, "Mint fee 0.001 ETH");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // تابع اصلاح‌شده: بدون لوپ بی‌معنی
    function listForSale(uint256 tokenId, uint256 price) external {
        require(ownerOf(tokenId) == msg.sender, "Not owner");
        listings[tokenId] = price; // فقط یک بار نوشتن در استوریج
    }

    function buyNFT(uint256 tokenId) external payable {
        uint256 price = listings[tokenId];
        require(price > 0, "Not listed");
        require(msg.value == price, "Wrong price");
        address seller = ownerOf(tokenId);
        _transfer(seller, msg.sender, tokenId);
        delete listings[tokenId];
        payable(seller).transfer(price);
    }
}