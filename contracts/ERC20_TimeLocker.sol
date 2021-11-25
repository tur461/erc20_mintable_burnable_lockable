pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./ERC20_MBL.sol";

contract ERC20_TimeLocker {
    address private _token;
    address private _beneficiary;
    uint256 private _releaseTime;

    event Released(address beneficiary, uint256 amount);

    modifier notEarly() {
        require(
            block.timestamp >= _releaseTime,
            "Too early to release the tokens!."
        );
        _;
    }

    constructor(
        address tokenAddress_,
        address beneficiary_,
        uint256 durationInSeconds_
    ) public {
        require(durationInSeconds_ > 0, "Invalid duration provided!.");

        _token = tokenAddress_;
        _beneficiary = beneficiary_;
        _releaseTime = block.timestamp + durationInSeconds_;
    }

    function deposit(uint256 amount_, uint256 durationInSeconds_)
        public
        returns (bool success)
    {
        require(amount_ > 0, "Invalid amount of tokens.");
        // this contract must be allowed to transfer tokens on behalf of sender
        SafeERC20.safeTransferFrom(
            ERC20_MBL(_token),
            msg.sender,
            address(this),
            amount_
        );
    }

    function release() public notEarly {
        uint256 amount = ERC20_MBL(_token).balanceOf(address(this));
        require(amount > 0, "No token balance in locker.");

        SafeERC20.safeTransfer(ERC20_MBL(_token), beneficiary(), amount);

        emit Released(beneficiary(), amount);
    }

    function token() public view returns (address token) {
        token = _token;
    }

    function beneficiary() public view returns (address bnf) {
        bnf = _beneficiary;
    }

    function releaseTime() public view returns (uint256 rTime) {
        rTime = _releaseTime;
    }
}
