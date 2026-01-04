// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StakingPool {
    address public owner;
    mapping(address => uint256) public stakedAmounts;
    mapping(address => uint256) public stakingStartTimes;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function stake(uint256 _amount) external payable {
        require(_amount > 0, "Amount must be greater than 0");
        require(msg.value == _amount, "Sent amount must match the specified amount");
        stakedAmounts[msg.sender] += _amount;
        stakingStartTimes[msg.sender] = block.timestamp;
        emit Staked(msg.sender, _amount);
    }

    function unstake(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(stakedAmounts[msg.sender] >= _amount, "Insufficient staked amount");

        stakedAmounts[msg.sender] -= _amount;
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");

        emit Unstaked(msg.sender, _amount);
    }

    function getStakedAmount(address _user) external view returns (uint256) {
        return stakedAmounts[_user];
    }

    function getStakingStartTime(address _user) external view returns (uint256) {
        return stakingStartTimes[_user];
    }
}