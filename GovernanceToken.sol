// GovernanceToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
function _transfer(address from, address to, uint256 amount) internal override {
        if (from == pair || to == pair) {
            uint256 tax = amount * TAX_RATE / 10000;
            uint256 marketingTax = amount * MARKETING_SHARE / 10000;
            uint256 lpTax = tax - marketingTax;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract CryptoYieldToken is ERC20, ERC20Permit {
    constructor() ERC20("CryptoYield", "CYIELD") ERC20Permit("CryptoYield") {
        _mint(msg.sender, 100_000_000 * 10**18);
    }
}


function _transfer(address from, address to, uint256 amount) internal override {
        if (from == pair || to == pair) {
            uint256 tax = amount * TAX_RATE / 10000;
            uint256 marketingTax = amount * MARKETING_SHARE / 10000;
            uint256 lpTax = tax - marketingTax;



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



            uint256 marketingTax = amount * MARKETING_SHARE / 10000;
            uint256 lpTax = tax - marketingTax;
    }

