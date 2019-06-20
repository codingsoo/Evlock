pragma solidity ^0.4.24;

import "./EIP20Interface.sol";
import "./SafeMath.sol";

contract EVlock is EIP20Interface {
    using SafeMath for uint256;
    uint256 constant private MAX_UINT256 = 2**256 - 1;
     
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;
    mapping (address => mapping (address => uint256)) public credit;
    
    mapping (uint256 => address) public user;
    mapping (address => uint256) public seqOfUser;
    mapping (address => bool) public premium = false;

    mapping (address => uint256) public sellingAmount;
    mapping (address => uint256) public sellingPrice;

    mapping (address => uint256) public succedTrade;
    mapping (address => uint256) public failTrade;

    mapping (address => mapping (address => uint256)) public proceeded;

    uint256 public constant RATE = 1000000;
    string public name;                     // fancy name: EVlock Token
    uint8 public decimals;                  // How many decimals to show.
    string public symbol;                   // EVT
    address public owner;                   // Contract PUblisher
    uint256 seq = 0;
    uint256 credit = 0;
    
    uint256 donatedEV = 0;
    
    function () payable {
        createTokens();
    }
    
    constructor() public{
        balances[msg.sender] = 1000000;               // Give the creator all initial tokens
        totalSupply = 1000000;                        // Update total supply
        name = "EVlock Token";                        // Set the name for display purposes
        decimals = 0;                                 // Amount of decimals for display purposes
        symbol = "EVTT";                              // Set the symbol for display purposes
        owner = msg.sender;                           // Owner is me!
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
        emit Transfer(_from, _to, _value);      //solhint-disable-line indent, no-unused-vars
        return true;
    }
    
    function balanceOf(address _owner) public view returns (uint256 balance) {
        
        return balances[_owner];
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {

        /* Allow account to send token to specific account  */

        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {

        /* View  allowance*/

        return allowed[_owner][_spender];
    }
    
    function registerUser() public returns(bool success){
        user[seq] = msg.sender;
        seqOfUser[msg.sender] = seq;
        seq = seq.add(1);
        credit = credit[seq].add(1);
        return true;
    }

    function registerSelling(uint256 _amount, uint256 _price) public returns (bool success) {
        /* Seller register sales amount and price. */
        require(_price > 0 &&& _amount > 0);
        sellingAmount[msg.sender] = _amount;
        sellingPrice[msg.sender] = _price;
        return true;
    }
    
    function buyEV(uint256 _seq, uint256 _amount) public returns (bool success) {

        /* Confirm the credit of the buyer and seller, 
        and the contract regards the creditworthiness of the transaction as lower credit. */

        require(_seq > 0 && _amount > 0 && sellingAmount[user[_seq]] >= _amount);
        sellingAmount[user[_seq]] = sellingAmount[user[_seq]].sub(_amount);
        balances[msg.sender] = balances[msg.sender].sub(sellingPrice[user[_seq]].mul(_amount));
        balances[user[_seq]] = balances[user[_seq]].add(sellingPrice[user[_seq]].mul(_amount));
        // After you make the deal, add credit scores on both sides!
        addCredit(msg.sender, user[_seq]);
        return true;
    }
    
    function donateEV(uint256 _amount) public returns (bool success) {
        require(_amount > 0);
        donatedEV = donatedEV.add(_amount);
        return true;
    }

    function creditPointOf(address _owner) public view returns(uint256 creditPoint) {
        if (failTrade[_owner] == 0 && succeedTrade[_owner] == 0) {
            return 50;
        }
        creditPoint = succeedTrade[_owner].mul(100).div(succeedTrade[_owner].add(failTrade[_owner]));
        return creditPoint;
    }

    function addCredit(address _from, address _to) public{
        credit[_from].add(1);
        credit[_to].add(1);
    }

    function refund(address _from, address _to, uint256 _value) public returns (bool succeed) {
        /* Refund the value of the remaind EV not transferred,
         and cut credit scores on both sides. */
        succedTrade[_from].sub(1);
        succedTrade[_to].sub(1);
        failTrade[_from].add(1);
        failTrade[_to].add(1);

        uint priceSold = _value.sub(_value.mul(proceeded[_from][_to]).div(100));
        transferFrom(_from, _to, priceSold);
        sellingAmount[_from] = 0;
        sellingPrice[_from] = 0;
        return succeed;
    }
}
