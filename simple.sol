// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract BaseSimpleDex {
    ISwapRouter public immutable swapRouter;
    address public immutable WETH;
    address public immutable USDC;

    constructor() {
        swapRouter = ISwapRouter(0x2626664C2603336e57b271C5c0b26F421741E48D); // Correct checksum
        WETH = 0x4200000000000000000000000000000000000006;
        USDC = 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913;
    }

    function swapETHForUSDC(
        uint256 amountOutMinimum,
        address recipient
    ) external payable returns (uint256 amountOut) {
        require(msg.value > 0, "ETH amount must be greater than 0");

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH,
            tokenOut: USDC,
            fee: 500,
            recipient: recipient,
            deadline: block.timestamp + 1200,
            amountIn: msg.value,
            amountOutMinimum: amountOutMinimum,
            sqrtPriceLimitX96: 0
        });

        amountOut = swapRouter.exactInputSingle(params);

        if (address(this).balance > 0) {
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    receive() external payable {}
}