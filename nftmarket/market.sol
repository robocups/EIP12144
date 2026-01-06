// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/utils/Counters.sol";
contract SimpleNFTMarket is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(address => bool) public hasMinted;
    mapping(uint256 => uint256) public listings; // tokenId to price in wei

    constructor() ERC721("SimpleNFT", "SNFT") {}

    
    function mint(string memory uri) public {
        require(!hasMinted[msg.sender], "Already minted");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri); 
        hasMinted[msg.sender] = true;
    }


    function listNFT(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "Not owner");
        require(price > 0, "Price > 0");
        listings[tokenId] = price;
    }

  
    function buyNFT(uint256 tokenId) public payable {
        uint256 price = listings[tokenId];
        require(price > 0, "Not listed");
        require(msg.value == price, "Wrong price");
        address seller = ownerOf(tokenId);
        _transfer(seller, msg.sender, tokenId);
        delete listings[tokenId];
        payable(seller).transfer(price);
    }
}