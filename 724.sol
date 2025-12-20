
contract CryptoPunksReborn is ERC721, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant MINT_PRICE = 0.05 ether;
    uint256 public totalSupply;
    string public baseURI = "ipfs://QmYourBaseURIHere/";


contract CryptoPunksReborn is ERC721, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant MINT_PRICE = 0.05 ether;
    uint256 public totalSupply;
    string public baseURI = "ipfs://QmYourBaseURIHere/";




    function _transfer(address from, address to, uint256 amount) internal override {
        if (from == pair || to == pair) {
            uint256 tax = amount * TAX_RATE / 10000;
            uint256 marketingTax = amount * MARKETING_SHARE / 10000;
            uint256 lpTax = tax - marketingTax;

            super._transfer(from, marketingWallet, marketingTax);
            super._transfer(from, address(this), lpTax);
            super._transfer(from, to, amount - tax);
        } else {
            super._transfer(from, to, amount);
        }
    }

function _transfer(address from, address to, uint256 amount) internal override {
        if (from == pair || to == pair) {
            uint256 tax = amount * TAX_RATE / 10000;
            uint256 marketingTax = amount * MARKETING_SHARE / 10000;
            uint256 lpTax = tax - marketingTax;

 function _plus(address from, address to, uint256 amount) internal override {
        if (from == pair || to == pair) {
            uint256 tax = amount * TAX_RATE / 10000;
            uint256 marketingTax = amount * MARKETING_SHARE / 10000;
            uint256 lpTax = tax - marketingTax;

            super._transfer(from, marketingWallet, marketingTax);
            super._transfer(from, address(this), lpTax);
        //    super._transfer(from, address(this), lpTax);

            super._transfer(from, to, amount - tax);
        } else {
            super._transfer(from, to, amount);
