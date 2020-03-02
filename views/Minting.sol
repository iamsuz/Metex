pragma solidity ^0.5.12;

contract SafeMath {
    function safeAdd(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

contract cToken is SafeMath{
    string private name;
    uint8 private decimals;
    uint256 public totalSupply;
    address public admin;
    string private symbol;

    mapping(address => uint256) public balanceOf;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
        );

    event Burn(address indexed burner, uint256 value);

    constructor(string memory _name,string memory _symbol, address _admin) public{
        name = _name;
        decimals = 18;
        admin = _admin;
        totalSupply = 0;
        symbol = _symbol;
    }

    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }

    function mint(uint256 _amount) public onlyAdmin returns (bool){
        totalSupply += _amount;
        balanceOf[msg.sender] += _amount;
        emit Transfer(address(0),msg.sender,_amount);
        return true;
    }

    function redeem(uint256 _amount) public onlyAdmin returns(bool){
        _burn(msg.sender,_amount);
        return true;
    }

    function _burn(address _who, uint256 _value) internal {
        require(_value <= balanceOf[_who]);
        balanceOf[_who] = safeSub(balanceOf[_who],_value);
        totalSupply = safeSub(totalSupply,_value);
        emit Transfer(_who, address(0), _value);
        emit Burn(_who, _value);
    }
}
