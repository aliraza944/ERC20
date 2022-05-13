// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./IERC20.sol";
import "./SafeMath.sol";

contract MyToken is IERC20 {
    using SafeMath for uint256;
    uint256 public _totalSupply;
    mapping(address => uint256) public _balanceOf;

    mapping(address => mapping(address => uint256)) public _allowance;
    string public name;
    string public symbol;
    uint8 public decimals;
    address payable public _owner;
    uint256 public tokenRateInWei;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 __totalSupply,
        uint256 _tokenRateInWei
    ) {
        _totalSupply = __totalSupply;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        _owner = payable(msg.sender);
        tokenRateInWei = _tokenRateInWei;
        // minted the totalSupply to the owner
        _balanceOf[msg.sender] = _totalSupply;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balanceOf[account];
    }

    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        require(
            recipient != address(0),
            "ERC20: transfer from the zero address"
        );
        require(
            _balanceOf[msg.sender] >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        _balanceOf[msg.sender] -= amount;
        _balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);

        return true;
    }

    function allowance(address owner, address spender)
        external
        view
        returns (uint256)
    {
        return _allowance[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "ERC20: transfer to the zero address");

        _allowance[msg.sender][spender] = amount;
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(
            amount <= _allowance[sender][msg.sender],
            "ERC20: insufficient allowance"
        );
        _allowance[sender][msg.sender] = _allowance[sender][msg.sender].sub(
            amount
        );
        _balanceOf[sender] -= amount;
        _balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint256 amount) external {
        require(msg.sender == _owner, "ERC20: mint not authorized");
        require(amount > 0, "ERC20: mint amount must be greater than 0");

        _totalSupply += amount;
        _balanceOf[msg.sender] += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint256 amount) external {
        require(amount > 0, "ERC20: burn amount must be greater than 0");
        require(
            _balanceOf[msg.sender] >= amount,
            "ERC20: insufficient balance"
        );
        _balanceOf[msg.sender] -= amount;
        _totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    function buyToken(uint256 amount) external payable {
        require(amount > 0, "ERC20: burn amount must be greater than 0");
        require(amount * tokenRateInWei <= msg.value, " insufficient balance");
        _balanceOf[msg.sender] = _balanceOf[msg.sender].add(amount);
        _totalSupply = _totalSupply.sub(amount);
        _owner.transfer(msg.value);
        emit Transfer(_owner, msg.sender, amount);
    }
}
