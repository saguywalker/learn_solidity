pragma solidity ^0.4.22;

contract Faucet{

  address owner;

  constructor(){
    owner = msg.sender;
  }

  function withdraw(uint withdraw_amount) public{
    require(withdraw_amount <= 100000000000000000);
    msg.sender.transfer(withdraw_amount);
  }

  function () public payable{}

  function destroy() public onlyOwner{
    selfdestruct(owner);
  }

  modifier onlyOwner{
    require(msg.sender == owner);
    _;
  }
}
