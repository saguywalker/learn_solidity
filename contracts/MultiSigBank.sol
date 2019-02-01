pragma solidity ^0.5.0;

contract MultiSigBank{

    struct Person{
        address payable personAddr;
        bool isAllowWithdraw;
    }

    struct Party{
        Person person1;
        Person person2;
        uint256 amount;
        bool isCreate;
    }

    mapping(bytes32 => Party) party;

    event CreateParty(bytes32 indexed partyId, address person1, address person2, uint256 amount);
    event Deposit(bytes32 indexed partyId, uint256 amount);
    event Withdraw(bytes32 indexed partyId, uint256 person1Amount, uint256 person2Amount);

    function createParty(address payable _person2) external payable{
        require(msg.value > 0, "must greater than 0.");
        require(_person2 != address(0) && msg.sender != _person2);

        Party memory p = Party({
            person1: Person(msg.sender, false),
            person2: Person(_person2, false),
            amount: msg.value,
            isCreate: true
        });

        bytes32 partyId = keccak256(abi.encode(msg.sender, _person2));
        party[partyId] = p;

        emit CreateParty(partyId, msg.sender, _person2, msg.value);
    }
    
    function depositMoney(bytes32 _partyId) external payable{
        require(msg.value > 0, "must greater than 0.");
        require(party[_partyId].isCreate);
        require(msg.sender == party[_partyId].person1.personAddr || msg.sender == party[_partyId].person2.personAddr);

        party[_partyId].amount += msg.value;

        emit Deposit(_partyId, msg.value);
    }

    function allowWithdraw(bytes32 _partyId) external{
        require(party[_partyId].isCreate);
        require(msg.sender == party[_partyId].person1.personAddr || msg.sender == party[_partyId].person2.personAddr);

        if(msg.sender == party[_partyId].person1.personAddr){
            party[_partyId].person1.isAllowWithdraw = true;
        }else{
            party[_partyId].person2.isAllowWithdraw = true;
        }
    }
}