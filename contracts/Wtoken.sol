// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Wrapper.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract lmaoWrapper is ERC20, ERC20Wrapper, ERC20Permit{

    IERC20 public immutable lmao;   // IERC20 being wrapped in this contract
    uint256 public cache;  

    constructor(IERC20 _lmao) ERC20("Wrapped Lmao", "wLM") ERC20Permit("Wrapped Lmao")
        ERC20Wrapper(_lmao) {
        require(_lmao != this, "ERC20Wrapper: cannot self wrap");
        lmao = IERC20(_lmao);
    }

    event Wrapped(address indexed from, address indexed to, uint256 lmao, uint256 wrapper);
    event Unwrapped(address indexed from, address indexed to, uint256 wrapper, uint256 lmao);
                     // Amount of lmao wrapped in this contract
    function decimals () public view virtual override (ERC20, ERC20Wrapper) returns (uint8){
        try IERC20Metadata(address(lmao)).decimals() returns(uint8 value) {
            return value;
        } catch {
            return super.decimals();
        }
    }

    /// Takes lmao from the caller and mint wrapper tokens in exchange.
    /// Any amount of unaccounted lmao in this contract will also be used.
    function wrap(address to, uint256 lmaoIn) external returns (uint256 wrapperOut){
        uint256 lmaoHere = lmao.balanceOf(address(this)) - cache;
        uint256 lmaoUsed = lmaoIn + lmaoHere;
        wrapperOut = _wrapMath(lmaoUsed);
        require(lmaoIn != 0 || lmao.transferFrom(msg.sender, address(this), lmaoIn), "Transfer fail");

        _mint(to, wrapperOut);
        cache += lmaoUsed;
        emit Wrapped(msg.sender, to, lmaoUsed, wrapperOut);
    }

    /// @dev Burn wrapper token from the caller and send lmao tokens in exchange.
    /// Any amount of unaccounted wrapper in this contract will also be used.
    function unwrap(address to, uint256 wrapperIn)external returns (uint256 lmaoOut){
        require(wrapperIn > 0, "Invalid Amount");
        _burn(msg.sender, wrapperIn);
        require(lmao.transfer(to, lmaoOut), "Transfer fail");
        cache -= lmaoOut;
        emit Unwrapped(msg.sender, to, wrapperIn, lmaoOut);
    }

    /// @dev Formula to convert from underlying to wrapper amounts. Feel free to override with your own.
    function _wrapMath(uint256 lmaoAmount) internal pure returns (uint256 wrapperAmount) {
        wrapperAmount = lmaoAmount;
    }

    /// @dev Formula to convert from wrapper to underlying amounts. Feel free to override with your own.
    function _unwrapMath(uint256 wrapperAmount) internal virtual returns (uint256 lmaoAmount) {
        lmaoAmount = wrapperAmount;
    }
}



