// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/token/ERC20/utils/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/security/ReentrancyGuard.sol";

address constant WETH = 0x4200000000000000000000000000000000000006;

interface IWETH {
    function deposit() external payable;
    function withdraw(uint256 wad) external;
}

contract SimpleETHStaking is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public immutable weth;
    uint256 public totalStaked;
    mapping(address => uint256) public balanceOf;

    uint256 public minStakeAmount;
    uint256 public maxStakeAmount;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event FailedUnstake(address indexed user, uint256 amount);

    constructor(uint256 _minStakeAmount, uint256 _maxStakeAmount) Ownable(msg.sender) {
        weth = IERC20(WETH);
        minStakeAmount = _minStakeAmount;
        maxStakeAmount = _maxStakeAmount;
    }

    receive() external payable {
        stake();
    }

    fallback() external payable {
        stake();
    }

    function stake() public payable nonReentrant {
        require(msg.value > 0, "No ETH sent");
        require(msg.value >= minStakeAmount, "Amount below minimum stake");
        require(msg.value <= maxStakeAmount, "Amount above maximum stake");

        IWETH(WETH).deposit{value: msg.value}();

        balanceOf[msg.sender] += msg.value;
        totalStaked += msg.value;

        emit Staked(msg.sender, msg.value);
    }

    function unstake(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        balanceOf[msg.sender] -= amount;
        totalStaked -= amount;

        IWETH(WETH).withdraw(amount);

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        if (!success) {
            // Revert balance changes if ETH transfer fails
            balanceOf[msg.sender] += amount;
            totalStaked += amount;
            emit FailedUnstake(msg.sender, amount);
            revert("ETH transfer failed");
        }

        emit Unstaked(msg.sender, amount);
    }

    function getBalance(address user) external view returns (uint256) {
        return balanceOf[user];
    }

    function setMinStakeAmount(uint256 _minStakeAmount) external onlyOwner {
        minStakeAmount = _minStakeAmount;
    }

    function setMaxStakeAmount(uint256 _maxStakeAmount) external onlyOwner {
        maxStakeAmount = _maxStakeAmount;
    }
}