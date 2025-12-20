// GovernanceToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
function _transfer(address from, address to, uint256 amount) internal override {
        if (from == pair || to == pair) {
            uint256 tax = amount * TAX_RATE / 10000;
            uint256 marketingTax = amount * MARKETING_SHARE / 10000;
            uint256 lpTax = tax - marketingTax;


            uint256 marketingTax = amount * MARKETING_SHARE / 10000;
            uint256 lpTax = tax - marketingTax;
    }

