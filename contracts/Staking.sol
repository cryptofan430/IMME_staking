// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// import '@uniswap/v2-core/contracts/interfaces/IPancakeRouter.sol';

interface IPancakeRouter01 {
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

interface IPancakeRouter02 is IPancakeRouter01 {
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

contract ImmeStaking is Ownable {

    IPancakeRouter02 _ipancakeRouter;
    IERC20 public immeToken;
    IERC20 public busdToken;

    address immeowner;
    address public _imme = 0xaCc34268f5D7Cb9B11BfB1ba4D8bD2bc2B49EE4E;//hassle
    address public _busd = 0xaCc34268f5D7Cb9B11BfB1ba4D8bD2bc2B49EE4E;//hassle

    uint256 constant sTime1 = 7 days;
    uint256 constant sTime2 = 14 days;
    uint256 constant sTime3 = 30 days;
    uint256 constant sTime4 = 60 days;
    uint256 constant sTime5 = 90 days;
    uint256 constant sTime6 = 180 days;
    uint256 constant sTime7 = 360 days;
    uint256 constant sTime8 = 720 days;

    struct Staker {
        uint256 balance;
        uint256 startTime;
    }

    mapping(address => Staker) internal stakers;

    constructor(IERC20 _immeToken, IERC20 _busdToken) {
        immeToken = _immeToken;
        busdToken = _busdToken;
        immeowner = msg.sender;
        _setPancakeswap(0xaCc34268f5D7Cb9B11BfB1ba4D8bD2bc2B49EE4E);//hassle
    }

    function deposit(uint256 _amount ) public onlyOwner {
        immeToken.transferFrom(msg.sender, address(this), _amount);
    }

    function staking(uint256 _amount) public {
        require(_amount > 0, "There isn't enough your balance");
        address[] memory path;
        path = new address[](2);
        path[0] = address(_busd);
        path[1] = address(_imme);

        stakers[msg.sender].balance = _ipancakeRouter.getAmountsOut(_amount, path)[1];//hassle
        stakers[msg.sender].startTime = block.timestamp;

        _ipancakeRouter.addLiquidity(_busd, _imme, _amount, stakers[msg.sender].balance, 0, 0, immeowner, block.timestamp);

        uint256 amount = stakers[msg.sender].balance;
        immeToken.transfer(msg.sender, amount);
    }

    function unstaking() public {
        require(stakers[msg.sender].balance > 0, "Don't exist your staking amount!");
        uint256 amount = reward(msg.sender);
        require(immeToken.balanceOf(address(this)) > amount, "There isn't enough your balance");
        immeToken.transfer(msg.sender, amount);
    }

    function reward(address _address) private returns (uint256 reamount) {
        uint256 stime = block.timestamp - stakers[_address].startTime;

        uint256 cnt1 = stime / sTime1; 
        uint256 cnt2 = stime / sTime2; 
        uint256 cnt3 = stime / sTime3; 
        uint256 cnt4 = stime / sTime4; 
        uint256 cnt5 = stime / sTime5; 
        uint256 cnt6 = stime / sTime6; 
        uint256 cnt7 = stime / sTime7; 
        uint256 cnt8 = stime / sTime8; 

        uint256 amount;

        if(cnt1 == 1) {
            amount = stakers[_address].balance * 15 / 1000;
        }
        
        if(cnt2 >= 1 && cnt2 < 3) {
            amount = stakers[_address].balance * 35 / 1000;
        }
        
        if(cnt3 == 1) {
            amount = stakers[_address].balance * 75 / 1000;
        }
        
        if(cnt4 == 1) {
            amount = stakers[_address].balance * 16 / 100;
        }
        
        if(cnt5 == 1) {
            amount = stakers[_address].balance * 25 / 100;
        }
        
        if(cnt6 == 1) {
            amount = stakers[_address].balance * 75;
        }
        
        if(cnt7 == 1) {
            amount = stakers[_address].balance * 2;
        }
        if(cnt8 == 1) {
            amount = stakers[_address].balance * 5;
        }

        return amount;
    }

    function _setPancakeswap(address _router) private {
        _ipancakeRouter = IPancakeRouter02(_router);
    }
}