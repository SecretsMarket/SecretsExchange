// SPDX-License-Identifier: MIT

//this contract has not been audited. Do not use yet.

pragma solidity 0.6.6;


contract Contract {

    string ipfsHash;
 
    function sendHash(string memory x) public {
       ipfsHash = x;
    }
    
    function getHash() public view returns (string memory x) {
       return ipfsHash;
    }
}
