// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Testament{
    address _manager; 
    mapping(address => address) _heir;
    mapping(address => uint) _balance; 

    // for call to see of the owner and heir of this contract
    event Create(address indexed owner, address indexed heir, uint amount); 
    // report death and send of heritage
    event Report(address indexed owner, address indexed heir, uint amount);

    constructor(){
        _manager = msg.sender;
    }

    // owner create testament
    function create(address heir) public payable {
        require(msg.value > 0, "Please Enter Money More Than 0.");
        require(_balance[msg.sender] <= 0,"Already Testament Exist.");
        _heir[msg.sender] = heir; 
        _balance[msg.sender] = msg.value;

        // see owner, heir and balance of owner
        emit Create(msg.sender, heir, msg.value);
    }

    // check of the testament for see of all data
    function getTestament(address owner) public view returns(address heir, uint amount){
        return (_heir[owner], _balance[owner]); // get of address and amount of heir when send
    }

    // reportDeath
    function reportOfDeath(address owner) public{
        require(msg.sender == _manager, "Unzuthorized, only manager"); // check that manager are deploy this contract
        require(_balance[owner] > 0, "No Testament"); // check even coding this contract

        // report of death to send of heritage
        emit Report(owner, _heir[owner], _balance[owner]);

        // transfer
        payable(_heir[owner]).transfer(_balance[owner]);

        // reset of data 
        _balance[owner] = 0;
        _heir[owner] = address(0);

    } 
}