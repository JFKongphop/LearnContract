// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyLottery{
    address _manager;
    address payable[] _players; //people who must to paid 

    constructor(){
        _manager = msg.sender;
    }

    // get of the belance of this contract
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    // buy lottery | payable for function that must to paid
    function buyLottery() public payable{
        require(msg.value == 100000000000000000 wei, "Lottery is 1 Ether");
        _players.push(payable(msg.sender)); // push players who buy to this array
    }

    // count number of buyer 
    function getLength() public view returns(uint){
        return _players.length;
    }

    // random number in _players
    function randomNumber() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, _players.length)));
    }

    // show winner
    function showWinner() public view returns(address, uint){
        require(msg.sender == _manager, "Unauthorized, only manager");
        require(getLength() > 1, "Participants is less than 2 players");
        uint pickRandom = randomNumber();
        uint selectIndex = pickRandom % _players.length; // random of number who is winner
        return (_players[selectIndex], selectIndex); // address and index        
    }

    // find winner and transfer to winner
    function selectWinner() public{
        require(msg.sender == _manager, "Unauthorized, only manager");
        require(getLength() > 1, "Participants is less than 2 players");
        uint pickRandom = randomNumber();
        uint selectIndex = pickRandom % _players.length; // random of number who is winner

        // transfer to winner
        address payable winner;
        winner = _players[selectIndex];
        // read back to front
        winner.transfer(getBalance()); // transfer all of money in getBalance() to winner 
        //reset data
        _players = new address payable[](0); // create new array for use new time
    }
}