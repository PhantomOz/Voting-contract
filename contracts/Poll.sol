// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Poll {
    string public question; 
    string[] public options;
    mapping(address => uint) public votes;
    mapping(address => bool) public voted;
    uint256 public endTime;

    constructor(string memory _question, string[] memory _options, uint256 _duration) {
        require(bytes(_question).length > 0, "Question cannot be empty");
        require(_options.length > 1, "Options must be more than one");
        require(_duration > 0, "Duration must be positive");
        uint256 _endTime = block.timestamp + _duration;
        question = _question;
        options = _options;
        endTime = _endTime;
    }
}