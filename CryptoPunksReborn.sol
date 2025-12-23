// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ProfessionalToken is ERC20, Ownable2Step, ReentrancyGuard {
    using SafeMath for uint256;

    // --- Constants ---
    uint256 public constant MAX_SUPPLY_CAP = 1_000_000_000 * 10**decimals(); // 1B tokens
    uint256 public constant MIN_MINT_AMOUNT = 1;
    uint256 public constant MAX_MINT_AMOUNT = 1000 * 10**decimals(); // 1k tokens per tx

    // --- State Variables ---
    uint256 public mintPrice = 0.001 ether;
    uint256 public maxSupply;
    uint256 public tokensMinted;
    bool public isMintingOpen = true;
    address public treasury;

    // --- Events ---
    event TokensMinted(address indexed minter, uint256 amount, uint256 ethPaid);
    event Withdrawal(address indexed recipient, uint256 amount);
    event MintParametersUpdated(uint256 newPrice, uint256 newMaxSupply);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _maxSupply,
        address _treasury
    ) ERC20(_name, _symbol) {
        require(_maxSupply > 0, "Max supply must be > 0");
        require(_maxSupply <= MAX_SUPPLY_CAP / 10**decimals(), "Max supply too high");
        require(_treasury != address(0), "Invalid treasury address");

        maxSupply = _maxSupply.mul(10**decimals());
        treasury = _treasury;
    }

    // --- Core Functions ---
    function mint(uint256 _amount) external payable nonReentrant {
        _validateMint(_amount);
        _processMint(msg.sender, _amount);
    }

    function batchMint(address[] calldata _recipients, uint256[] calldata _amounts)
        external
        payable
        nonReentrant
        onlyOwner
    {
        require(_recipients.length == _amounts.length, "Array length mismatch");
        uint256 totalAmount = 0;
        uint256 totalEthRequired = 0;

        for (uint256 i = 0; i < _recipients.length; i++) {
            _validateMint(_amounts[i]);
            totalAmount = totalAmount.add(_amounts[i]);
            totalEthRequired = totalEthRequired.add(_amounts[i].mul(mintPrice).div(10**decimals()));
        }

        require(msg.value >= totalEthRequired, "Insufficient ETH for batch mint");

        for (uint256 i = 0; i < _recipients.length; i++) {
            _processMint(_recipients[i], _amounts[i]);
        }
    }

    function withdraw() external nonReentrant onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "No funds to withdraw");

        payable(treasury).transfer(amount);
        emit Withdrawal(treasury, amount);
    }

    // --- Admin Functions ---
    function setMintPrice(uint256 _newPrice) external onlyOwner {
        require(_newPrice > 0, "Price must be > 0");
        mintPrice = _newPrice;
        emit MintParametersUpdated(_newPrice, maxSupply.div(10**decimals()));
    }

    function setMaxSupply(uint256 _newMaxSupply) external onlyOwner {
        require(_newMaxSupply > 0, "Max supply must be > 0");
        require(_newMaxSupply >= tokensMinted.div(10**decimals()), "Cannot reduce below minted");
        require(_newMaxSupply <= MAX_SUPPLY_CAP / 10**decimals(), "Max supply too high");

        maxSupply = _newMaxSupply.mul(10**decimals());
        emit MintParametersUpdated(mintPrice, _newMaxSupply);
    }

    function toggleMinting() external onlyOwner {
        isMintingOpen = !isMintingOpen;
    }

    function setTreasury(address _newTreasury) external onlyOwner {
        require(_newTreasury != address(0), "Invalid treasury address");
        treasury = _newTreasury;
    }

    // --- View Functions ---
    function getMintDetails() external view returns (
        uint256 currentPrice,
        uint256 remainingSupply,
        bool mintingActive,
        address treasuryAddress
    ) {
        return (
            mintPrice,
            maxSupply.sub(tokensMinted).div(10**decimals()),
            isMintingOpen,
            treasury
        );
    }

    // --- Internal Functions ---
    function _validateMint(uint256 _amount) internal view {
        require(isMintingOpen, "Minting closed");
        require(_amount >= MIN_MINT_AMOUNT, "Amount too small");
        require(_amount <= MAX_MINT_AMOUNT.div(10**decimals()), "Amount too large");
        require(msg.value >= _amount.mul(mintPrice).div(10**decimals()), "Insufficient ETH");
        require(tokensMinted.add(_amount.mul(10**decimals())) <= maxSupply, "Max supply reached");
    }

    function _processMint(address _to, uint256 _amount) internal {
        uint256 amountWithDecimals = _amount.mul(10**decimals());
        _mint(_to, amountWithDecimals);
        tokensMinted = tokensMinted.add(amountWithDecimals);
        emit TokensMinted(_to, amountWithDecimals, _amount.mul(mintPrice).div(10**decimals()));
    }

    // --- Overrides ---
    function _update(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        super._update(from, to, value);
   
    }
    