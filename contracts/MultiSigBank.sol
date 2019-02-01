pragma solidity ^0.5.0;

contract MultiSigBank{

    struct Person{
        address payable personAddr;
        bool isAllow;
    }

    struct Party{
        Person person1;
        Person person2;
        uint256 amount;
    }

    mapping(bytes32 => Party) partyId;

    event CreateParty(bytes32 indexed partyId, address person1, address person2, uint256 amount);
    event Deposit(bytes32 indexed partyId, uint256 amount);
    event Withdraw(bytes32 indexed partyId, uint256 person1Amount, uint256 person2Amount);

    function createParty(address payable _person2) external payable{
        require(msg.value > 0, "must greater than 0.");
        require(_person2 != address(0) && msg.sender != _person2);

        Party memory p = Party({
            person1: Person(msg.sender, false),
            person2: Person(_person2, false),
            amount: msg.value
        });

        bytes32 hashId = keccak256(abi.encode(msg.sender, _person2));
        partyId[hashId] = p;
    }
    
    function depositMoney(address _person2) external payable{
        require(msg.value > 0, "must greater than 0.");
        
    }
}