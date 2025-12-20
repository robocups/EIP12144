// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ShibaKiller is ERC20, Ownable {
    uint256 public constant TOTAL_SUPPLY = 1_000_000_000 * 10**18; // 1 میلیارد توکن
    uint256 public constant TAX_RATE = 500; // 5% tax (500 = 5.00%)
    uint256 public constant MARKETING_SHARE = 300; // 3% به مارکتینگ
    uint256 public constant LP_SHARE = 200;       // 2% به لیکوییدیتی

    address public marketingWallet;
    address public pair;

    constructor(address _marketingWallet) ERC20("ShibaKiller", "SKILL") {
        marketingWallet = _marketingWallet;
        _mint(msg.sender, TOTAL_SUPPLY);
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        if (from == pair || to == pair) {
            uint256 tax = amount * TAX_RATE / 10000;
            uint256 marketingTax = amount * MARKETING_SHARE / 10000;
            uint256 lpTax = tax - marketingTax;

            super._transfer(from, marketingWallet, marketingTax);
            super._transfer(from, address(this), lpTax);
            super._transfer(from, to, amount - tax);
        } else {
            super._transfer(from, to, amount);
        }
    }

    function setPair(address _pair) external onlyOwner {
        pair = _pair;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CryptoPunksReborn is ERC721, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant MINT_PRICE = 0.05 ether;
    uint256 public totalSupply;
    string public baseURI = "ipfs://QmYourBaseURIHere/";

    constructor() ERC721("CryptoPunksReborn", "CPR") {}

    function mint(uint256 quantity) external payable {
        require(totalSupply + quantity <= MAX_SUPPLY, "Sold out");
        require(msg.value >= MINT_PRICE * quantity, "Insufficient ETH");

        for (uint256 i = 0; i < quantity; i++) {
            _safeMint(msg.sender, totalSupply++);
        }
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ShibaKiller is ERC20, Ownable {
    uint256 public constant TOTAL_SUPPLY = 1_000_000_000 * 10**18; // 1 میلیارد توکن
    uint256 public constant TAX_RATE = 500; // 5% tax (500 = 5.00%)
    uint256 public constant MARKETING_SHARE = 300; // 3% به مارکتینگ
    uint256 public constant LP_SHARE = 200;       // 2% به لیکوییدیتی

    address public marketingWallet;
    address public pair;

    constructor(address _marketingWallet) ERC20("ShibaKiller", "SKILL") {
        marketingWallet = _marketingWallet;
        _mint(msg.sender, TOTAL_SUPPLY);
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        if (from == pair || to == pair) {
            uint256 tax = amount * TAX_RATE / 10000;
            uint256 marketingTax = amount * MARKETING_SHARE / 10000;
            uint256 lpTax = tax - marketingTax;

            super._transfer(from, marketingWallet, marketingTax);
            super._transfer(from, address(this), lpTax);
            super._transfer(from, to, amount - tax);
        } else {
            super._transfer(from, to, amount);
        }
    }

    function setPair(address _pair) external onlyOwner {
        pair = _pair;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
