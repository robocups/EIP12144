// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleToken is ERC20, Ownable {
    uint256 public mintPrice = 0.001 ether;
    uint256 public maxSupply = 1000000 * 10**decimals();
    bool public isMintingOpen = true;

    constructor() ERC20("MyToken", "MTK") Ownable(msg.sender) {}

    function mint() external payable {
        require(isMintingOpen, "Minting is closed");
        require(msg.value >= mintPrice, "Insufficient ETH");
        require(totalSupply() + (10**decimals()) <= maxSupply, "Max supply reached");

        _mint(msg.sender, 10**decimals());
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function setMintPrice(uint256 _price) external onlyOwner {
        mintPrice = _price;
    }

    function toggleMinting() external onlyOwner {
        isMintingOpen = !isMintingOpen;
    }
}