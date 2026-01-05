// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/token/ERC20/utils/SafeERC20.sol";

address constant WETH = 0x4200000000000000000000000000000000000006;

interface IWETH {
    function deposit() external payable;
    function withdraw(uint256 wad) external;
}

contract FixedAmountStaking {
    using SafeERC20 for IERC20;

    IERC20 public immutable weth;

    uint256 public constant STAKE_AMOUNT = 15_000_000_000_000; // 0.000015 ETH

    mapping(address => uint256) public balanceOf;
    uint256 public totalStaked;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 receivedAmount);

    constructor() {
        weth = IERC20(WETH);
    }

    receive() external payable {
        stake();
    }

    fallback() external payable {
        stake();
    }

    function stake() public payable {
        require(msg.value == STAKE_AMOUNT, "Must send exactly 0.000015 ETH");

        IWETH(WETH).deposit{value: STAKE_AMOUNT}();

        balanceOf[msg.sender] += STAKE_AMOUNT;
        totalStaked += STAKE_AMOUNT;

        emit Staked(msg.sender, STAKE_AMOUNT);
    }

    function unstake() external {
        uint256 userBalance = balanceOf[msg.sender];
        require(userBalance == STAKE_AMOUNT, "No stake or already unstaked");

        uint256 returnAmount = (STAKE_AMOUNT * 75) / 100;

        balanceOf[msg.sender] = 0;
        totalStaked -= STAKE_AMOUNT;

        IWETH(WETH).withdraw(returnAmount);

        (bool success, ) = payable(msg.sender).call{value: returnAmount}("");
        require(success, "ETH transfer failed");

        emit Unstaked(msg.sender, returnAmount);
    }

    function getStakeAmount() external pure returns (uint256) {
        return STAKE_AMOUNT;
    }

    function getUnstakeAmount() external pure returns (uint256) {
        return (STAKE_AMOUNT * 75) / 100;
    }
}