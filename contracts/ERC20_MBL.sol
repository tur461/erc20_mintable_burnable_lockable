pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract ERC20_MBL is ERC20, Ownable {
    uint8 private constant _DECIMALS = 8;
    address private _owner;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply_
    ) public ERC20(name_, symbol_) {
        _owner = msg.sender;
        _mint(_msgSender(), initialSupply_);
    }

    function mint(address to_, uint256 amount_) public onlyOwner {
        if (to_ == address(0)) to_ = _msgSender();
        _mint(to_, amount_);
    }

    function burn(address of_, uint256 amount_) public onlyOwner {
        if (of_ == address(0)) of_ = _msgSender();
        _burn(of_, amount_);
    }

    function decimals() public view override returns (uint8 dec) {
        dec = _DECIMALS;
    }

    function owner() public view override returns (address) {
        return _owner;
    }
}
