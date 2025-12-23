// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CustomMintToken is ERC20, Ownable {
    uint256 public mintPrice = 0.001 ether;
    uint256 public maxSupply;
    bool public isMintingOpen = true;
    uint256 public tokensMinted;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply,
        uint256 _maxSupply
    ) ERC20(_name, _symbol) Ownable(msg.sender) {
        maxSupply = _maxSupply * (10 ** decimals());
        if (_initialSupply > 0) {
            _mint(msg.sender, _initialSupply * (10 ** decimals()));
            tokensMinted = _initialSupply * (10 ** decimals());
        }
    }

    function mintTokens(uint256 _amount) external payable {
        require(isMintingOpen, "Minting is closed");
        require(msg.value >= mintPrice * _amount, "Insufficient ETH sent");

        uint256 amountWithDecimals = _amount * (10 ** decimals());
        require(tokensMinted + amountWithDecimals <= maxSupply, "Max supply reached");

        _mint(msg.sender, amountWithDecimals);
        tokensMinted += amountWithDecimals;
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

    function setMaxSupply(uint256 _newMaxSupply) external onlyOwner {
        require(_newMaxSupply * (10 ** decimals()) >= tokensMinted, "Cannot reduce max supply below minted tokens");
        maxSupply = _newMaxSupply * (10 ** decimals());
    }

    function tokenDetails() external view returns (
        string memory name,
        string memory symbol,
        uint8 decimal,
        uint256 currentSupply,
        uint256 maxTokenSupply,
        uint256 pricePerToken,
        bool mintingStatus
    ) {
        return (
            name,
            symbol,
            decimals(),
            tokensMinted / (10 ** decimals()),
            maxSupply / (10 ** decimals()),
            mintPrice,
            isMintingOpen
        );
    }
}