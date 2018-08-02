contract Mortal is Owned{
  function destroy() public onlyOwner{
    selfdestruct(owner);
  }
}
