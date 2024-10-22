// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    mapping(address => bool) public voters;
    Candidate[] public candidates;
    uint256 public votingStart;
    uint256 public votingEnd;

    event VoteCast(address indexed voter, uint256 candidateId);

    constructor(string[] memory candidateNames, uint256 durationInMinutes) {
        for (uint256 i = 0; i < candidateNames.length; i++) {
            candidates.push(Candidate({
                id: i,
                name: candidateNames[i],
                voteCount: 0
            }));
        }
        votingStart = block.timestamp;
        votingEnd = block.timestamp + (durationInMinutes * 1 minutes);
    }

    function vote(uint256 candidateId) external {
        require(!voters[msg.sender], "You have already voted.");
        require(block.timestamp >= votingStart && block.timestamp < votingEnd, "Voting is not currently open.");
        require(candidateId < candidates.length, "Invalid candidate ID.");

        voters[msg.sender] = true;
        candidates[candidateId].voteCount++;

        emit VoteCast(msg.sender, candidateId);
    }

    function getCandidateCount() external view returns (uint256) {
        return candidates.length;
    }

    function getCandidate(uint256 candidateId) external view returns (uint256, string memory, uint256) {
        require(candidateId < candidates.length, "Invalid candidate ID.");
        Candidate memory candidate = candidates[candidateId];
        return (candidate.id, candidate.name, candidate.voteCount);
    }

    function getVotingStatus() external view returns (bool) {
        return (block.timestamp >= votingStart && block.timestamp < votingEnd);
    }

    function getRemainingTime() external view returns (uint256) {
        if (block.timestamp >= votingEnd) return 0;
        return votingEnd - block.timestamp;
    }
}