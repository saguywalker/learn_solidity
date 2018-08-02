pragma solidity ^0.4.22;

contract Faucet is Mortal{

  event Withdrawal(address indexed to, uint amount);
  event Deposit(address indexed from, uint amout);

  function withdraw(uint withdraw_amount) public{
    require(withdraw_amount <= 100000000000000000);
    require(this.balance >= withdraw_amount,"Insufficient balance for withdraw request");
    msg.sender.transfer(withdraw_amount);
    emit Withdrawal(msg.sender,msg.value);
  }

  function () public payable{
    emit Deposit(msg.sender,msg.value);
  }

}

contract Mortal is Owned{
  function destroy() public onlyOwner{
    selfdestruct(owner);
  }
}

contract Owned{

  address owner;

  constructor(){
    msg.sender = owner;
  }

  modifier onlyOwner(){
    require(msg.sender == owner,"only the contract owner can call this function");
    _;
  }
}
