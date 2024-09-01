# VotingSystem Smart Contract
The VotingSystem smart contract is a Solidity-based implementation of a voting system with token-based voting. It allows the owner to manage candidates, conduct voting sessions, and handle token minting and burning. Users can vote for candidates using their tokens, and the contract tracks votes and manages the lifecycle of the voting process.
## Features
* Token Management: Mint and burn tokens.
* Candidate Management: Add candidates for voting.
* Voting Process: Start and end voting, vote for candidates.
* Token Voting: Vote using tokens, with balances updated accordingly.
* Events: Emit events for token minting, burning, candidate addition, voting start/end, and voting actions.
## Contract Details
### State Variables
* string public name: The name of the token.
* uint public totalSupply: Total supply of tokens.
* address public owner: Address of the contract owner.
* uint public votingStartTime: Start time of the voting period.
* uint public votingEndTime: End time of the voting period.
* bool public votingEnded: Indicates if the voting period has ended.
* mapping(address => uint) public balances: Token balances of users.
* mapping(address => uint) public candidateVotes: Votes for each candidate.
* address[] public candidates: List of candidates.
### Events
* event TokensMinted(address indexed to, uint value): Emitted when tokens are minted.
* event TokensBurned(address indexed from, uint value): Emitted when tokens are burned.
* event Voted(address indexed voter, address indexed candidate, uint value): Emitted when a vote is cast.
* event CandidateAdded(address indexed candidate): Emitted when a new candidate is added.
* event VotingStarted(uint startTime, uint endTime): Emitted when voting starts.
* event VotingEnded(uint endTime): Emitted when voting ends.
## Getting started
### Installing
This program runs on EVM along with ".sol" as extension. We can either run it on websites like Remix or even on Visual Studios.

### Executing program
We need a solidity compatible virtual machine in order to run this program. Create a new file with ".sol" extension
```
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
```
## How to Use
### Deployment
* Deploy the contract to the Ethereum blockchain by providing an initial supply of tokens to the constructor.
* The deploying address will become the owner of the contract and will have the initial supply of tokens.
### Managing the Voting Process
* Minting Tokens: The contract owner can mint additional tokens to specific addresses using the mintTokens function.
* Burning Tokens: The contract owner can burn tokens from specific addresses using the burnTokens function.
* Adding Candidates: The contract owner can add candidates to the election using the addCandidate function.
* Starting Voting: The contract owner can start the voting period by calling the startVoting function and specifying the * * duration of the voting period.
* Ending Voting: The contract owner can end the voting period by calling the endVoting function.
### Voting
* During the voting period, users can vote for a candidate by calling the vote function and specifying the candidate's * address and the amount of tokens to vote with.
* Users must have a sufficient token balance to vote.
* Voting can only occur during the active voting period.
## Usage
* Deploy the Contract: Deploy the contract with an initial token supply.
* Add Candidates: The owner adds candidates using addCandidate.
* Start Voting: The owner starts the voting period with startVoting.
* Vote: Users cast their votes with vote.
* End Voting: The owner ends the voting period using endVoting.
* Retrieve Results: Use getCandidates and getVotes to retrieve voting results.
## Author
Vageshwari Chaudhary vageshwari1062@gmail.com
## License
This project is licensed under the MIT License - see the LICENSE file for details.

