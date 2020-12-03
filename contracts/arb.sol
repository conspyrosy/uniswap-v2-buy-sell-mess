pragma solidity >=0.6.2; //TODO This might need to be 0.6.2 due to an interface
pragma experimental ABIEncoderV2;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.1.0/contracts/token/ERC20/ERC20.sol";

interface UniswapExchangeInterface {
    // Address of ERC20 token sold on this exchange
    function tokenAddress() external view returns (address token);
    // Address of Uniswap Factory
    function factoryAddress() external view returns (address factory);
    // Provide Liquidity
    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
    // Get Prices
    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
    function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
    function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
    // Trade ETH to ERC20
    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
    function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
    function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
    // Trade ERC20 to ETH
    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
    function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
    // Trade ERC20 to ERC20
    function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
    function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
    // Trade ERC20 to Custom Pool
    function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
    function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
    // ERC20 comaptibility for liquidity tokens
    //bytes32 public name;
    //bytes32 public symbol;
    //uint256 public decimals;
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    // Never use
    function setup(address token_addr) external;
}

interface UniswapFactoryInterface {
    // Public Variables
    //address public exchangeTemplate;
    //uint256 public tokenCount;
    // Create Exchange
    function createExchange(address token) external returns (address exchange);
    // Get Exchange and Token Info
    function getExchange(address token) external view returns (address exchange);
    function getToken(address exchange) external view returns (address token);
    function getTokenWithId(uint256 tokenId) external view returns (address token);
    // Never use
    function initializeFactory(address template) external;
}

interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract MyContract {
    address payable owner;
    IUniswapV2Router02 uniswapV2Router;

    struct exchangePrice {
        uint256 buyETH;
        uint256 sellETH;
        string exchange;
    }

    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only owner can call this function."
        );
        _;
    }

    constructor() public payable {
        owner = msg.sender;
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    }

    //returns all the cashhh to owner
    //TODO: Send ERC20s as well
    function kill() external onlyOwner {
        selfdestruct(owner);
    }

    function calculateBest1EthRate() payable public {
        exchangePrice[] memory exchangePrices = new exchangePrice[](2);

        uint256 tradeSize = msg.value;

        //THIS IS ETH AS TOKEN 1
        exchangePrices[0] = getUniswapV2Price(0x1c5DEe94a34D795f9EEeF830B68B80e44868d316, tradeSize);

        //THIS IS ETH AS TOKEN 0
        //buyCurrencyUniswapV2(0x70dD7e6d35b7bD97Dca394D68FcA92E6A2d7DaD2, tradeSize);

        address daiExchangeAddress = 0xc0fc958f7108be4060F33a699a92d3ea49b0B5f0;
        ERC20 daiToken = ERC20(0xaD6D458402F60fD3Bd25163575031ACDce07538D);
        exchangePrices[1] = getUniswapV1Price(daiExchangeAddress, daiToken, tradeSize);

        exchangePrice memory bestBuy = exchangePrices[0];
        exchangePrice memory bestSell = exchangePrices[0];

        //loop through prices of this token comparing best buys and sells
        for (uint i = 1; i < exchangePrices.length; i++) {
            if(exchangePrices[i].buyETH < bestBuy.buyETH) {
                bestBuy = exchangePrices[i];
            }
            if(exchangePrices[i].sellETH > bestBuy.sellETH) {
                bestSell = exchangePrices[i];
            }
        }

        uint256 daiAmount = buyCurrencyUniswapV1(daiExchangeAddress, daiToken, tradeSize, true);
        emit successfulTrade(tradeSize, "ETH", daiAmount, "DAI");

        daiToken.approve(daiExchangeAddress, daiAmount);

        uint256 ethFromDai = buyCurrencyUniswapV1(daiExchangeAddress, daiToken, daiAmount, false);
        emit successfulTrade(daiAmount, "DAI", ethFromDai, "ETH");

        //uint256 tokensBought = buyCurrencyUniswapV2(address(daiToken), tradeSize, true);

        //daiToken.approve(address(uniswapV2Router), tokensBought);

        //buyCurrencyUniswapV2(address(daiToken), tokensBought, false);

        emit arbInfo(bestBuy, bestSell, bestBuy.buyETH < bestSell.sellETH);
    }

    function performArb(exchangePrice memory bestBuy, exchangePrice memory bestSell, uint256 tradeSize) public {
        //if(bestBuy.buyETH < bestSell.sellETH) {
        //    uint256 daiAmount = buyCurrencyUniswapV1(daiExchangeAddress, daiToken, tradeSize, true);
        //    emit successfulTrade(tradeSize, "ETH", daiAmount, "DAI");
        //    uint256 ethFromDai = buyCurrencyUniswapV1(daiExchangeAddress, daiToken, daiAmount, false);
        //    emit successfulTrade(daiAmount, "DAI", ethFromDai, "ETH");
        //}
    }

    //TODO: This only supports ETH token pairs at the moment...
    function getUniswapV2Price(address pairAddress, uint256 tradeSize) private returns(exchangePrice memory) {

        //UNISWAP V2 FACTORY ROPSTEN - 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f

        //address weth = 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2; //mainnet
        address weth = 0xc778417E063141139Fce010982780140Aa0cD5Ab; //ropsten

        IUniswapV2Pair pair = IUniswapV2Pair(pairAddress);

        //check weth is one of the tokens
        if(pair.token0() != weth && pair.token1() != weth) {
            revert();
        }

        bool wethFirstToken = pair.token0() == weth ? true : false;

        (uint112 token0Reserves, uint112 token1Reserves, ) = pair.getReserves();

        //check tradeSize doesnt exceed ETH in the pool
        if(wethFirstToken && tradeSize > token0Reserves || !wethFirstToken && tradeSize > token1Reserves) {
            return exchangePrice(0, 0, "UniswapV2");
        }

        uint256 buyEth;
        uint256 sellEth;

        if(wethFirstToken) {
            //this is the number of token you get for tradeSize ETH
            sellEth = uniswapV2Router.getAmountOut(tradeSize, token0Reserves, token1Reserves);

            //this is the number of token you need to buy tradeSize ETH
            buyEth = uniswapV2Router.getAmountIn(tradeSize, token1Reserves, token0Reserves);
        } else {
            sellEth = uniswapV2Router.getAmountOut(tradeSize, token1Reserves, token0Reserves);
            buyEth = uniswapV2Router.getAmountIn(tradeSize, token0Reserves, token1Reserves);
        }

        emit amountBackEvent(buyEth, sellEth, "UniswapV2");

        return exchangePrice(buyEth, sellEth, "UniswapV2");
    }

    function getUniswapV1Price(address exchangeAddress, ERC20 token, uint256 tradeSize) private returns(exchangePrice memory) {
        UniswapExchangeInterface usi = UniswapExchangeInterface(exchangeAddress);

        uint256 buyEth = usi.getTokenToEthOutputPrice(tradeSize);
        uint256 sellEth = usi.getEthToTokenInputPrice(tradeSize);

        emit amountBackEvent(buyEth, sellEth, "UniswapV1");

        uint256 amountEth = msg.value;
        //uint256 amountBack = usi.ethToTokenSwapInput.value(amountEth)(1, block.timestamp);

        //token.transfer(msg.sender, amountBack);

        //get new values after buying, hopefully they've changed
        //buyEth = usi.getTokenToEthOutputPrice(1000000000000000000);
        //sellEth = usi.getEthToTokenInputPrice(1000000000000000000);

        //emit amountBackEvent(buyEth, sellEth, "UniswapV1-after-buy");

        return exchangePrice(buyEth, sellEth, "UniswapV1");
    }

    function buyCurrencyUniswapV1(address exchangeAddress, ERC20 token, uint256 tradeSize, bool isBuyToken) private returns(uint256) {
        UniswapExchangeInterface usi = UniswapExchangeInterface(exchangeAddress);

        if(isBuyToken) {
            //do the exchange
            uint256 tokensBack = usi.ethToTokenSwapInput.value(tradeSize)(1, block.timestamp);

            //send tokens to sender
            //token.transfer(msg.sender, tokensBack);

            return tokensBack;
        } else {
            uint256 etherBack = usi.tokenToEthSwapInput(tradeSize, 1, block.timestamp);

            //send ether to sender
            //msg.sender.transfer(etherBack);

            return etherBack;
        }
    }

    function buyCurrencyUniswapV2(address tokenAddress, uint256 tradeSize, bool isBuyToken) private returns(uint256) {
        if(isBuyToken) {
            require(tradeSize <= address(this).balance, "Not enough Eth in contract to perform swap.");

            address[] memory path = new address[](2);
            path[0] = uniswapV2Router.WETH();
            path[1] = tokenAddress;

            return uniswapV2Router.swapExactETHForTokens.value(tradeSize)(1, path, address(this), block.timestamp)[1];
        } else {
            //TODO: Constraint to check we have the right amount

            address[] memory path = new address[](2);
            path[0] = tokenAddress;
            path[1] = uniswapV2Router.WETH();

            return uniswapV2Router.swapExactTokensForETH(tradeSize, 1, path, address(this), block.timestamp)[1];
        }
    }

fallback() external payable { }

receive() external payable { }

event amountBackEvent(uint256 buyEth, uint256 sellEth, string exchangeName);

event arbInfo(exchangePrice bestBuy, exchangePrice bestSell, bool arbExists);

event successfulTrade(uint256 fromAmount, string fromCurrency, uint256 toAmount, string toCurrency);
}