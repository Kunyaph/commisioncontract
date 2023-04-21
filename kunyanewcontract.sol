//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./kunyaowner.sol";

contract Token is Ownable {
    mapping(address => uint256) public _balances;
    mapping(address => mapping(address => uint256)) public _allowances;

    uint256 public _totalSupply;

    string public _name;
    string public _symbol;

    constructor() {
        _name ="Domination coin";
        _symbol = "DOM";
        _totalSupply = 999999000000000000;
        _balances[0x7AE69f67Ee2485A20673e335B625e3edf073488f] = _totalSupply;
        emit Transfer(address(0), 0x7AE69f67Ee2485A20673e335B625e3edf073488f, _totalSupply);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        address from = msg.sender;
        _transfer(from, to, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        _transfer(from, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        address owner = msg.sender;
        require(spender != address(0), "Zero address approved");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function withdraw(uint256 amount) public onlyOwner returns (bool) {
        require(_balances[address(this)] >= amount, "Not enough token");
        _balances[address(this)] -= amount;
        _balances[owner()] += amount;
        emit Withdrawal(amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "transfer from");
        require(to != address(0), "transfer to");

        require(amount >= 2000, "Low amount");
        uint256 fee = amount / 20;
        
        address spender = msg.sender;
        if (spender != from) {
            uint256 currentAllowance = allowance(from, spender);
            require(
                currentAllowance >= amount + fee,
                "insufficient allowance"
            );
        }

        uint256 fromBalance = _balances[from];
        require(
            fromBalance >= amount + fee,
            "Not enough token"
        );
        _balances[from] = fromBalance - amount - fee;
        _balances[to] += amount;
        _balances[address(this)] += fee;

        emit Transfer(from, to, amount);
    }

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    event Withdrawal(uint value);
}