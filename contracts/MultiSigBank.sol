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
    event Deposit(bytes32 indexed partyId, uint256 depositAmount);
    event Withdraw(bytes32 indexed partyId, uint256 person1Amount, uint256 person2Amount);

    modifier onlyInParty(bytes32 _partyId){
        require(
            party[_partyId].isCreate,
            "Party has not created yet."
        );
        require(
            msg.sender == party[_partyId].person1.personAddr || msg.sender == party[_partyId].person2.personAddr,
            "caller address must be in party."
        );
        
        _;
    }

    function createParty(address payable _person2) external payable{
        require(msg.value > 0, "must greater than 0.");
        require(
            _person2 != address(0) && msg.sender != _person2,
            "must not be same person and must not be empty address."
        );

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
    
    function depositMoney(bytes32 _partyId) external onlyInParty(_partyId) payable{
        require(msg.value > 0, "must greater than 0.");

        party[_partyId].amount += msg.value;

        emit Deposit(_partyId, msg.value);
    }

    function allowWithdraw(bytes32 _partyId) external onlyInParty(_partyId){
        if(msg.sender == party[_partyId].person1.personAddr){
            party[_partyId].person1.isAllowWithdraw = true;
        }else{
            party[_partyId].person2.isAllowWithdraw = true;
        }
    }

    function withdraw(bytes32 _partyId) external onlyInParty(_partyId){
        require(
            party[_partyId].person1.isAllowWithdraw && party[_partyId].person2.isAllowWithdraw,
            "both people must be allow."
        );

        uint256 person2Amount = party[_partyId].amount / 2;
        uint256 person1Amount = party[_partyId].amount - person2Amount;

        party[_partyId].amount = 0;
        party[_partyId].person1.isAllowWithdraw = false;
        party[_partyId].person2.isAllowWithdraw = false;

        party[_partyId].person1.personAddr.transfer(person1Amount);
        party[_partyId].person2.personAddr.transfer(person2Amount);
        
        emit Withdraw(_partyId, person1Amount, person2Amount);
    }
}