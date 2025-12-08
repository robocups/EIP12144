// GovernanceToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract CryptoYieldToken is ERC20, ERC20Permit {
    constructor() ERC20("CryptoYield", "CYIELD") ERC20Permit("CryptoYield") {
        _mint(msg.sender, 100_000_000 * 10**18);
    }
}
