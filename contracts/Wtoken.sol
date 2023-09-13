// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Wrapper.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract lmaoWrapper is ERC20, ERC20Wrapper{
    constructor(address _lmao, IERC20 lmao) ERC20("Wrapped Lmao", "wLM") /*ERC20Permit("Wrapped Lmao")*/
        ERC20Wrapper(lmao) {
        require(lmao != this, "ERC20Wrapper: cannot self wrap");
        Lmao = _lmao;
    }

    event Wrapped(address indexed from, address indexed to, uint256 lmao, uint256 wrapper);
    event Unwrapped(address indexed from, address indexed to, uint256 wrapper, uint256 lmao);
    
    IERC20 public immutable Lmao;     // IERC20 being wrapped in this contract
    uint256 public cache;                   // Amount of lmao wrapped in this contract

    /// Takes lmao from the caller and mint wrapper tokens in exchange.
    /// Any amount of unaccounted lmao in this contract will also be used.
    function wrap(address to, uint256 lmaoIn) external override returns (uint256 wrapperOut){
        address sender = _msgSender();
        uint256 lmaoHere = Lmao.balanceOf(address(this)) - cache;
        uint256 lmaoUsed = lmaoIn + lmaoHere;
        wrapperOut = _wrapMath(lmaoUsed);
        require(lmaoIn != 0 || Lmao.transferFrom(msg.sender, address(this), lmaoIn), "Transfer fail");

        _mint(to, wrapperOut);
        cache += lmaoUsed;
        emit Wrapped(msg.sender, to, lmaoUsed, wrapperOut);
    }

    /// @dev Burn wrapper token from the caller and send lmao tokens in exchange.
    /// Any amount of unaccounted wrapper in this contract will also be used.
    function unwrap(address to, uint256 wrapperIn)external returns (uint256 lmaoOut){
        uint256 wrapperHere = balanceOf[address(this)];
        uint256 wrapperUsed = wrapperIn + wrapperHere;
        lmaoOut = _unwrapMath(wrapperUsed);

        if (wrapperIn > 0) _burn(msg.sender, wrapperIn);  // Approval not necessary
        if (wrapperHere > 0) _burn(address(this), wrapperHere);
        require(Lmao.transfer(to, lmaoOut), "Transfer fail");
        cache -= lmaoOut;
        emit Unwrapped(msg.sender, to, wrapperUsed, lmaoOut);
    }

    /// @dev Formula to convert from underlying to wrapper amounts. Feel free to override with your own.
    function _wrapMath(uint256 lmaoAmount) internal returns (uint256 wrapperAmount) {
        wrapperAmount = lmaoAmount;
    }

    /// @dev Formula to convert from wrapper to underlying amounts. Feel free to override with your own.
    function _unwrapMath(uint256 wrapperAmount) internal virtual returns (uint256 lmaoAmount) {
        lmaoAmount = wrapperAmount;
    }

}



