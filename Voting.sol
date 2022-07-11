// SPDX-License-Identifier: MIT

// incomplete
pragma solidity ^0.8.0;

// candidate name and amount of vote
struct Candidate{
    string name; 
    uint voteCount; 
}

// voting 
struct Voter{
    bool isRegister; 
    bool isVoted; 
    uint voteIndex; // what index of candidate that vote
}

contract Voting{
    address public manager;
    Candidate [] public candidates; // get from struct to use candididates array
    mapping(address => Voter) public voter; // show status of voter | register, voted, index candidate

    constructor(){
        manager = msg.sender; // set manager of who deploy this contract
    }

    // require when use 
    modifier onlyManager{
        require(msg.sender == manager, "Unauthorized, only manager");
        _;
    }

    // add candidate to array
    function addCandidate(string memory name) onlyManager public{
        candidates.push(Candidate(name, 0)); // name and voteCount to push in this array
    }

    // register voter
    // can register by manager only
    function register(address person) onlyManager public{
        voter[person].isRegister = true; // when vote bool change to true
    }

    function vote(uint index) public{
        require(voter[msg.sender].isRegister, "Must register first");
        require(!voter[msg.sender].isVoted, "Can vote for one time"); // not even to vote 
        voter[msg.sender].voteIndex = index; // get index of candidate for voting
        voter[msg.sender].isVoted = true; // when vote that change to true

        // use system similar mode when use i.first many times that add i.second++
        // vote for this index 
        candidates[index].voteCount++;
    }

}