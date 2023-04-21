//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Ownable
{
    address private _owner;

    constructor ()
    {
        _owner = msg.sender;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "Not owner");
        _;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Zero address");
        address previousOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(previousOwner, newOwner);
    }

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
}