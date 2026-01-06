// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/token/ERC20/utils/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.2/contracts/utils/math/Math.sol";

interface IUniswapV2Pair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
}

contract ArbitrageSimulator is Ownable {
    using SafeERC20 for IERC20;
    using Math for uint256;

    address public dexPair1;
    address public dexPair2;
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public minProfit = 1 ether;
    mapping(address => uint256) public executions;

    event ArbitrageExecuted(address user, uint256 profit);

    constructor(address _pair1, address _pair2) Ownable(msg.sender) {
        dexPair1 = _pair1;
        dexPair2 = _pair2;
        tokenA = IERC20(IUniswapV2Pair(_pair1).token0());
        tokenB = IERC20(IUniswapV2Pair(_pair1).token1());
    }

    function checkArbitrageOpportunity() public view returns (uint256 potentialProfit) {
        (uint112 reserveA1, uint112 reserveB1,) = IUniswapV2Pair(dexPair1).getReserves();
        (uint112 reserveA2, uint112 reserveB2,) = IUniswapV2Pair(dexPair2).getReserves();

        uint256 priceDiff = 0;
        for (uint i = 1; i <= 5; i++) {
            uint256 price1 = (uint256(reserveB1) * 1000) / reserveA1;
            uint256 price2 = (uint256(reserveB2) * 1000) / reserveA2;
            priceDiff += price1 > price2 ? price1 - price2 : price2 - price1;
        }

        potentialProfit = priceDiff.sqrt() * 100;
    }

    function executeArbitrage(uint256 amount) external {
        uint256 profit = checkArbitrageOpportunity();
        require(profit >= minProfit, "No profit");

        bytes memory data = abi.encode(msg.sender, profit);
        IUniswapV2Pair(dexPair1).swap(amount, 0, address(this), data);

        executions[msg.sender]++;
        emit ArbitrageExecuted(msg.sender, profit);
    }

    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external {
        (address user, uint256 profit) = abi.decode(data, (address, uint256));
        uint256 repay = amount0 + (amount0 * 3 / 1000);
        tokenA.safeTransfer(dexPair1, repay);
        tokenA.safeTransfer(user, profit);
    }

    function updateMinProfit(uint256 newMin) external onlyOwner {
        minProfit = newMin;
    }

    function getExecutionCount(address user) external view returns (uint256) {
        return executions[user];
    }
}