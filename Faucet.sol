pragma solidity ^0.4.22;

contract Faucet is Mortal{

  function withdraw(uint withdraw_amount) public{
    require(withdraw_amount <= 100000000000000000);
    require(this.balance >= withdraw_amount,"Insufficient balance for withdraw request");
    msg.sender.transfer(withdraw_amount);
  }

  function () public payable{}

}
