pragma solidity ^0.4.22;

contract Owned{

  address owner;

  constructor(){
    owner = msg.sender;
  }

  modifier onlyOwner(){
    require(msg.sender == owner,"only the contract owner can call this function");
    _;
  }
}

contract Mortal is Owned{
  function destroy() public onlyOwner{
    selfdestruct(owner);
  }
}

contract Faucet is Mortal{

  event Withdrawal(address indexed to, uint amount);
  event Deposit(address indexed from, uint amout);

  function withdraw(uint withdraw_amount) public{
    require(withdraw_amount <= 100000000000000000);
    require(address(this).balance >= withdraw_amount,"Insufficient balance for withdraw request");
    msg.sender.transfer(withdraw_amount);
    emit Withdrawal(msg.sender,withdraw_amount);
  }

  function () public payable{
    emit Deposit(msg.sender,msg.value);
  }

}
