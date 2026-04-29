// SPDX-License-Identifier: MIT
pragma solidity 0.8.34;

/**
 * @custom:security-contact security@example.com
 */

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Votes} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import {Nonces} from "@openzeppelin/contracts/utils/Nonces.sol";

contract TomanToken is ERC20, ERC20Permit, ERC20Votes {
    error TomanToken__ZeroAddress();

    constructor(address initialOwner)
        ERC20("Toman", "TCM")
        ERC20Permit("Toman")
    {
        if (initialOwner == address(0)) revert TomanToken__ZeroAddress();
        _mint(initialOwner, 1_000_000 * 10 ** decimals());
    }

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Votes)
    {
        super._update(from, to, value);
    }

    function nonces(address owner)
        public
        view
        override(ERC20Permit, Nonces)
        returns (uint256)
    {
        return super.nonces(owner);
    }
}
