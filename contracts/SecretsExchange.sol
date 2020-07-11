
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.21 <0.7.0;

contract SecretsExchange {

  address public owner;


  mapping(string=>address) pendingSecrets;
  mapping(string=>string) secretsDetails;
  mapping(string=>address) validatedSecrets;
  mapping(string=>uint256) appraisals;

  //timestamp of joined for uint256
  mapping(address=>uint256) validators;
  mapping(address=>uint256) appraisers;

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    if (msg.sender == owner) _;
  }


  modifier onlyValidators() {
    if (validators[msg.sender] != 0) _;
  }
  modifier onlyAppraisers() {
    if (appraisers[msg.sender] != 0) _;
  }


  //Template functions


  function createSecret(string memory ipfsAddress, string memory ipfsDetail) public returns(bool){

    pendingSecrets[ipfsAddress]= msg.sender;
    secretsDetails[ipfsAddress] = ipfsDetail;

    return true;
  }



  function verifySecret() onlyValidators payable public returns(bool) {

    return true;
  }

  function appraiseSecret() public onlyAppraisers returns(bool){

    return true;
  }

  function buySecret(bool exclusiveBool) payable public{

    return true;
  }
}
