// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract VotingSystem {
    string public name = "VotingToken";
    uint public totalSupply;
    address public owner;
    
    // Voting details
    uint public votingStartTime;
    uint public votingEndTime;
    bool public votingEnded;
    
    // Token balances
    mapping(address => uint) public balances;
    
    // Candidates and votes
    mapping(address => uint) public candidateVotes;
    address[] public candidates;

    // Events
    event TokensMinted(address indexed to, uint value);
    event TokensBurned(address indexed from, uint value);
    event Voted(address indexed voter, address indexed candidate, uint value);
    event CandidateAdded(address indexed candidate);
    event VotingStarted(uint startTime, uint endTime);
    event VotingEnded(uint endTime);

    constructor(uint _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply;
        balances[owner] = _initialSupply;
        votingEnded = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyDuringVoting() {
        require(block.timestamp >= votingStartTime && block.timestamp <= votingEndTime, "Voting is not active");
        _;
    }

    modifier onlyAfterVoting() {
        require(votingEnded, "Voting has not ended yet");
        _;
    }

    function mintTokens(address _address, uint _value) public onlyOwner {
        totalSupply += _value;
        balances[_address] += _value;
        emit TokensMinted(_address, _value);
    }

    function burnTokens(address _address, uint _value) public onlyOwner {
        require(balances[_address] >= _value, "Insufficient balance");
        totalSupply -= _value;
        balances[_address] -= _value;
        emit TokensBurned(_address, _value);
    }

    function addCandidate(address _candidate) public onlyOwner {
        require(!votingEnded, "Voting has ended");
        candidates.push(_candidate);
        emit CandidateAdded(_candidate);
    }

    function startVoting(uint _duration) public onlyOwner {
        require(!votingEnded, "Voting has ended");
        votingStartTime = block.timestamp;
        votingEndTime = block.timestamp + _duration;
        emit VotingStarted(votingStartTime, votingEndTime);
    }

    function endVoting() public onlyOwner onlyDuringVoting {
        votingEnded = true;
        emit VotingEnded(block.timestamp);
    }

    function vote(address _candidate, uint _amount) public onlyDuringVoting {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        require(isCandidate(_candidate), "Not a valid candidate");

        balances[msg.sender] -= _amount;
        candidateVotes[_candidate] += _amount;
        emit Voted(msg.sender, _candidate, _amount);
    }

    function getCandidates() public view returns (address[] memory) {
        return candidates;
    }

    function getVotes(address _candidate) public view returns (uint) {
        return candidateVotes[_candidate];
    }

    function isCandidate(address _candidate) internal view returns (bool) {
        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i] == _candidate) {
                return true;
            }
        }
        return false;
    }
}
