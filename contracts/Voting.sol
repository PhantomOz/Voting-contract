// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Poll} from "./Poll.sol";

contract Voting {
    
    Poll[] public polls;

    event PollCreated(uint pollId, string question, string[] options, uint256 endTime);

    event PollVoted(uint pollId, address voter, uint option);
    
    modifier pollExists(uint256 pollId) {
        require(pollId < polls.length, "Poll does not exist");
        _;
    }

    function createPoll(string memory _question, string[] memory _options, uint256 _duration) public {
        Poll newPoll = new Poll(_question, _options, _duration);
        polls.push(newPoll);
        uint pollId = polls.length - 1;
        emit PollCreated(pollId, _question, _options, (block.timestamp + _duration));
    }

    function votePoll(uint256 _pollId, uint8 _option) public pollExists(_pollId){
        polls[_pollId].vote(_option, _pollId, msg.sender);
        emit PollVoted(pollId, msg.sender, option);
    }

    function getOptionVotes(uint256 _pollId, uint8 _option) public view pollExists(_pollId) returns (uint256) {
        return polls[_pollId].viewVotes(_option);
    }

    function getWinner(uint256 _pollId) public view pollExists(_pollId) returns (string memory) {
        return polls[_pollId].winner();
    }
}