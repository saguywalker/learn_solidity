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
