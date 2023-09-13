// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Lmao is ERC20 { 
    uint256 constant FEE_PERCENT = 8;
    uint256 constant FEE_DIVISOR = 100;
    address public feeReceiver;
    mapping (address => uint256) _balances;

    event Transfer(address to, uint256 _value);

    constructor (address _feeReceiver) ERC20 ("Lmao", "LM"){
        feeReceiver = _feeReceiver;
    }
   
    function transfer (address _to, uint256 _value) public override returns (bool success) {
        require (_to != address(0), "transfer to address Zero not allowed");
        require (_value > 0, "increase value");
        require (balanceOf(msg.sender) >= _value, "insufficient funds");
        uint256 feeAmount = (_value * FEE_PERCENT) / FEE_DIVISOR;
        uint256 transferAmount = _value - feeAmount;
        require(transferAmount > 0, "transfer Amount cannot be 0");
        _balances[_to] += transferAmount;
        _balances[feeReceiver] += feeAmount;
        _balances[msg.sender] -= _value;
        success = true;
        emit Transfer(msg.sender, _to, _value);
    }

    function transferFrom (address _from, address _to, uint256 _value) public override returns (bool success) {
        require (_to != address(0), "transfer to address Zero not allowed");
        require (_value > 0, "increase value");
        require (balanceOf(_from) >= _value, "insufficient funds");
        require (allowance(_from, _to) <= _value, "insufficient allowance");
        uint256 feeAmount = (_value * FEE_PERCENT) / FEE_DIVISOR;
        uint256 transferAmount = _value - feeAmount;
        require(transferAmount  > 0, "transfer Amount cannot be zero");
        _balances[_to] += transferAmount;
        _balances[feeReceiver] += feeAmount;
        _balances[_from] -= _value;
        _balances[_to] += _value;
        success = true;
        emit Transfer(_from, _to, _value);
    }

}
