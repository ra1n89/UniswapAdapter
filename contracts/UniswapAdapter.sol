//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "./IERC20Mint.sol";

contract UniswapAdapter {
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant UniswapV2Factory =
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private constant WETH = 0xc778417E063141139Fce010982780140Aa0cD5Ab;

    IUniswapV2Router02 public UniswapV2Router02;
    IUniswapV2Factory public uniswapV2Factory;
    IERC20Mint public acdm;
    IERC20Mint public pop;
    IERC20Mint public tst;
    uint256 private amountAMin = 1;
    uint256 private amountBMin = 1;
    uint256 private amountTokenMin = 1;
    uint256 private amountETHMin = 1;

    constructor(
        address _acdm,
        address _pop,
        address _tst
    ) {
        UniswapV2Router02 = IUniswapV2Router02(UNISWAP_V2_ROUTER);
        uniswapV2Factory = IUniswapV2Factory(UniswapV2Factory);
        acdm = IERC20Mint(_acdm);
        pop = IERC20Mint(_pop);
        tst = IERC20Mint(_tst);
        acdm.mint(address(this), 100 * 10**18);
        pop.mint(address(this), 100 * 10**18);

        tst.mint(address(this), 100 * 10**18);
    }

    function addLiqudity(
        address _tokenA,
        address _tokenB,
        uint256 _amountTokenA,
        uint256 _amountTokenB
    ) public {
        acdm.approve(UNISWAP_V2_ROUTER, _amountTokenA);
        pop.approve(UNISWAP_V2_ROUTER, _amountTokenB);
        (uint256 amountA, uint256 amountB, uint256 liqudity) = UniswapV2Router02
            .addLiquidity(
                _tokenA,
                _tokenB,
                _amountTokenA,
                _amountTokenB,
                amountAMin,
                amountBMin,
                address(this),
                block.timestamp
            );
        console.log(amountA);
        console.log(amountB);
        console.log(liqudity);
    }

    function removeLiquidity(
        address _tokenA,
        address _tokenB,
        uint256 _liquidity
    ) external returns (uint256 amountA, uint256 amountB) {
        address pair = uniswapV2Factory.getPair(_tokenA, _tokenB);
        uint256 liquidity = IERC20(pair).balanceOf(address(this));
        IERC20(pair).approve(UNISWAP_V2_ROUTER, liquidity);

        UniswapV2Router02.removeLiquidity(
            _tokenA,
            _tokenB,
            _liquidity,
            amountAMin,
            amountBMin,
            address(this),
            block.timestamp
        );
    }

    function addLiqudityETH(address _token, uint256 _amountToken)
        public
        payable
    {
        acdm.approve(UNISWAP_V2_ROUTER, _amountToken);
        UniswapV2Router02.addLiquidityETH{value: msg.value}(
            _token,
            _amountToken,
            amountTokenMin,
            amountETHMin,
            address(this),
            block.timestamp
        );
    }

    function createPair(address _tokenA, address _tokenB)
        external
        returns (address pair)
    {
        uniswapV2Factory.createPair(_tokenA, _tokenB);
    }

    function getPair(address _tokenA, address _tokenB)
        external
        view
        returns (address pair)
    {
        uniswapV2Factory.getPair(_tokenA, _tokenB);
    }

    function swapExactTokensForTokens(
        address _tokenIn,
        address _tokenOut,
        uint256 _amountIn,
        uint256 _amountOutMin,
        address _to
    ) external {
        IERC20(_tokenIn).approve(UNISWAP_V2_ROUTER, _amountIn);
        address[] memory path;
        path = new address[](3);
        path[0] = _tokenIn;
        path[1] = WETH;
        path[2] = _tokenOut;
        UniswapV2Router02.swapExactTokensForTokens(
            _amountIn,
            _amountOutMin,
            path,
            _to,
            block.timestamp
        );
    }
}
