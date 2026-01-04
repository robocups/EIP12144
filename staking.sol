// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AutoETHStaking {
    uint256 private constant DEFAULT_STAKE_AMOUNT = 10000000000000000; // 0.00000001 ETH (10 gwei)
    uint256 private constant UNSTAKE_PERCENTAGE = 75; // 75%

    mapping(address => uint256) private stakedAmounts;
    mapping(address => uint256) private stakingStartTimes;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);

    // Automatic stake with fixed 0.00000001 ETH
    function stake() external payable {
        require(msg.value == DEFAULT_STAKE_AMOUNT, "Must send exactly 0.00000001 ETH");
        stakedAmounts[msg.sender] += DEFAULT_STAKE_AMOUNT;
        stakingStartTimes[msg.sender] = block.timestamp;
        emit Staked(msg.sender, DEFAULT_STAKE_AMOUNT);
    }

    // Automatic unstake 75% of staked amount
    function unstake() external {
        uint256 currentStake = stakedAmounts[msg.sender];
        require(currentStake > 0, "No staked amount");

        uint256 amountToUnstake = (currentStake * UNSTAKE_PERCENTAGE) / 100;
        require(amountToUnstake > 0, "No amount to unstake");

        stakedAmounts[msg.sender] = currentStake - amountToUnstake;
        payable(msg.sender).transfer(amountToUnstake);
        emit Unstaked(msg.sender, amountToUnstake);
    }

    // View functions
    function getStakedAmount() external view returns (uint256) {
        return stakedAmounts[msg.sender];
    }

    function getStakingStartTime() external view returns (uint256) {
        return stakingStartTimes[msg.sender];
    }
}