// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleETHStaking {
    // Mapping to store staked amounts and timestamps
    mapping(address => uint256) public stakedAmounts;
    mapping(address => uint256) public stakingStartTimes;

    // Events
    event Staked(address indexed user, uint256 amount, uint256 timestamp);
    event Unstaked(address indexed user, uint256 amount);

    // Stake ETH function
    function stake() external payable {
        require(msg.value > 0, "Must stake a positive amount of ETH");
        stakedAmounts[msg.sender] += msg.value;
        stakingStartTimes[msg.sender] = block.timestamp;
        emit Staked(msg.sender, msg.value, block.timestamp);
    }

    // Unstake ETH function
    function unstake(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(stakedAmounts[msg.sender] >= _amount, "Insufficient staked amount");

        stakedAmounts[msg.sender] -= _amount;
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "ETH transfer failed");

        emit Unstaked(msg.sender, _amount);
    }

    // Get staked amount for a user
    function getStakedAmount(address _user) external view returns (uint256) {
        return stakedAmounts[_user];
    }

    // Get staking start time for a user
    function getStakingStartTime(address _user) external view returns (uint256) {
        return stakingStartTimes[_user];
    }
}