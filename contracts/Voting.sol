// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Poll} from "./Poll.sol";

contract Voting {
    

    // An array to store all the polls
    Poll[] public polls;

    // An event to emit when a new poll is created
    event PollCreated(uint pollId, string question, string[] options, uint endTime);

    // An event to emit when a vote is cast
    event PollVoted(uint pollId, address voter, uint option);

    // A modifier to check if the poll exists
    modifier pollExists(uint pollId) {
        require(pollId < polls.length, "Poll does not exist");
        _;
    }

    // A modifier to check if the poll is open
    modifier pollOpen(uint pollId) {
        require(block.timestamp < polls[pollId].endTime, "Poll is closed");
        _;
    }

    // A modifier to check if the voter has not voted
    modifier notVoted(uint pollId, address voter) {
        require(!polls[pollId].voted[voter], "Already voted");
        _;
    }

    // A modifier to check if the option is valid
    modifier validOption(uint pollId, uint option) {
        require(option < polls[pollId].options.length, "Invalid option");
        _;
    }

    // A function to create a new poll
    function createPoll(string memory _question, string[] memory _options, uint256 _duration) public {
        Poll newPoll = new Poll(_question, _options, _duration);
        polls.push(newPoll);
        uint pollId = polls.length - 1;
        emit PollCreated(pollId, _question, _options, (block.timestamp + _duration));
    }

    // A function to vote on a poll
    function votePoll(uint pollId, uint option) public pollExists(pollId) pollOpen(pollId) notVoted(pollId, msg.sender) validOption(pollId, option) {
        polls[pollId].votes[option]++;
        polls[pollId].voted[msg.sender] = true;
        emit PollVoted(pollId, msg.sender, option);
    }

    // A function to get the total votes for an option
    function getVotes(uint pollId, uint option) public view pollExists(pollId) validOption(pollId, option) returns (uint) {
        return polls[pollId].votes[option];
    }

    // A function to get the winner of a poll
    function getWinner(uint pollId) public view pollExists(pollId) returns (uint) {
        require(block.timestamp >= polls[pollId].endTime, "Poll is not over yet");
        uint maxVotes = 0;
        uint winner = 0;
        for (uint i = 0; i < polls[pollId].options.length; i++) {
            if (polls[pollId].votes[i] > maxVotes) {
                maxVotes = polls[pollId].votes[i];
                winner = i;
            }
        }
        return winner;
    }
}