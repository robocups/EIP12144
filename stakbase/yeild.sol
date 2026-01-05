// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PublicLPPair is ERC20 {
    constructor() ERC20("Public LP", "PLP") {}

    function mint(uint256 amount) public {
        _mint(msg.sender, amount);
    }
}