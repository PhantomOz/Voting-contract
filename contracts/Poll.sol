// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Poll {
    string public question; 
    string[] public options;
    mapping(string => uint) public votes;
    mapping(address => bool) public voted;
    uint256 public endTime;


    modifier pollOpen() {
        require(block.timestamp < endTime, "Poll is closed");
        _;
    }

    modifier notVoted(address _voter) {
        require(!voted[_voter], "Already voted");
        _;
    }

    modifier validOption(uint8 _option) {
        require(_option < options.length, "Invalid option");
        _;
    }

    constructor(string memory _question, string[] memory _options, uint256 _duration) {
        require(bytes(_question).length > 0, "Question cannot be empty");
        require(_options.length > 1, "Options must be more than one");
        require(_duration > 0, "Duration must be positive");
        uint256 _endTime = block.timestamp + _duration;
        question = _question;
        options = _options;
        endTime = _endTime;'
    }

    function vote(uint8 _option, uint256 _id, address _address) public pollOpen notVoted(_address) validOption(_option) {
        votes[options[_option]]++;
        voted[msg.sender] = true;
        emit PollVoted(_id, msg.sender, _option);
    }

    function viewVotes(uint8 _option) external validOption(_option) returns(uint256){
        return votes[options[_option]];
    }

    function winner() external view returns(string memory) {
        require(block.timestamp >= endTime, "Poll is not over yet");
        uint maxVotes = 0;
        string memory winner;
        for (uint8 i = 0; i < options.length; i++) {
            if (votes[options[i]] > maxVotes) {
                maxVotes = votes[options[i]];
                winner = options[i];
            }
        }
        return winner;
    }
}