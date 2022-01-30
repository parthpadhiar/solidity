// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address public manager;
    address[] public players;

    constructor() {
        // ? Contract creator address
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > 1 ether);

        players.push(msg.sender);
    }

    function getAllPlayers() external view returns (address[] memory) {
      return players;
    }
    

    function getRandom() private view returns (uint) {
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }

    function getAmount() public restricted view returns (uint) {
        return address(this).balance;
    }

    function getPlayerBalance(address playerAddress) public view returns (uint) {
        return playerAddress.balance;
    }

    function pickWinner() public restricted {
        uint index = getRandom() % players.length;
        // ? Transfer amount to winner
        payable(players[index]).transfer(address(this).balance);
        players = new address[](0);
    }
    
    // ? modifier to remove duplication
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
}