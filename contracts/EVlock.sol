
pragma solidity ^0.4.24;

contract EIP20Interface {
    /* This is a slight change to the ERC20 base standard.
    function totalSupply() constant returns (uint256 supply);
    is replaced with:
    uint256 public totalSupply;
    This automatically creates a getter function for the totalSupply.
    This is moved to the base contract since public getter functions are not
    currently recognised as an implementation of the matching abstract
    function by the compiler.
    */
    /// total amount of tokens
    uint256 public totalSupply;

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) public view returns (uint256 balance);

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public returns (bool success);

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public returns (bool success);

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    // solhint-disable-next-line no-simple-event-func-name
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

contract EVlock is EIP20Interface{
    using SafeMath for uint256;
    uint256 constant private MAX_UINT256 = 2**256 - 1;
     
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;
    
    mapping (uint256 => address) public seller;
    mapping (address => uint256) public sellingAmount;
    mapping (address => uint256) public sellingPrice;
    
    uint256 public constant RATE = 1000000;
    string public name;                     // fancy name: EVlock Token
    uint8 public decimals;                  // How many decimals to show.
    string public symbol;                   // EVT
    address public owner;                   // Contract PUblisher
    uint256 seq = 0;
    uint256 donatedEV = 0;
    
    function () payable {
        createTokens();
    }
    
    function EVlock() public {
        balances[msg.sender] = 1000000;               // Give the creator all initial tokens
        totalSupply = 1000000;                        // Update total supply
        name = "EVlock Token";                                   // Set the name for display purposes
        decimals = 0;                            // Amount of decimals for display purposes
        symbol = "EVTT";                               // Set the symbol for display purposes
        owner = msg.sender;   // Owner is me!
    }
    
    function createTokens() payable{
        require(msg.value > 0);
        uint256 tokens = msg.value.mul(RATE);
        balances[msg.sender] = balances[msg.sender].add(tokens);
        totalSupply = totalSupply.add(tokens);
        owner.transfer(msg.value);
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value && _value > 0);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value && _value > 0);
        balances[_to] = balances[_to].add(_value);
        balances[_from] = balances[_from].sub(_value);
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        }
        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }
    
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    function registerSelling(uint256 _amount, uint256 _price) public returns (bool success) {
        require(_price > 0 && _amount > 0);
        seq = seq.add(1);
        seller[seq] = msg.sender;
        sellingAmount[msg.sender] = _amount;
        sellingPrice[msg.sender] = _price;
        return true;
    }
    
    function buyEV(uint256 _seq, uint256 _amount) public returns (bool success) {
        require(_seq > 0 && _amount > 0 && sellingAmount[seller[_seq]] >= _amount);
        sellingAmount[seller[_seq]] = sellingAmount[seller[_seq]].sub(_amount);
        balances[msg.sender] = balances[msg.sender].sub(sellingPrice[seller[_seq]]*_amount);
        balances[seller[_seq]] = balances[seller[_seq]].add(sellingPrice[seller[_seq]]*_amount);
        return true;
    }
    
    function donateEV(uint256 _amount) public returns (bool success) {
        require(_amount > 0);
        donatedEV = donatedEV.add(_amount);
        return true;
    }
}

