// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GameScoreToken is ERC20, Ownable {
    
    // 점수 공식 변수
    uint256 public scoreToTokenRate = 10; // 1 점 = 10 토큰 예시

    // 게임 점수 저장 (추후 확장 가능)
    mapping(address => uint256) public playerScores;

    // 이벤트
    event ScoreConverted(address indexed player, uint256 score, uint256 tokensIssued);

    // Ownable 생성자에서 msg.sender를 전달
    constructor() ERC20("GameScoreToken", "GST") Ownable(msg.sender) {
        // Ownable 생성자에 msg.sender를 전달하여 계약의 소유자 주소를 설정
    }

    // 점수를 토큰으로 변환하는 함수
    function convertScoreToToken(uint256 score) external {
        require(score > 0, "Score must be greater than 0");

        // 점수 변환 공식 (점수 * 변환비율)
        uint256 tokensToIssue = score * scoreToTokenRate;
        
        // 점수 저장 (추가적인 로직을 위해 사용)
        playerScores[msg.sender] += score;

        // 토큰 발행
        _mint(msg.sender, tokensToIssue);

        emit ScoreConverted(msg.sender, score, tokensToIssue);
    }

    // 점수 비율 변경 (게임 공식 조정)
    function setScoreToTokenRate(uint256 newRate) external onlyOwner {
        scoreToTokenRate = newRate;
    }
}

