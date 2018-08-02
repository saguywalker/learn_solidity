contract Owned{

  address owner;

  constructor(){
    msg.sender = owner;
  }

  modifier onlyOwner(){
    require(msg.sender == owner);
    _;
  }
}
