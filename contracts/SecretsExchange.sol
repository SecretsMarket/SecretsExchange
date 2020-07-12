
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.21 <0.7.0;

contract SecretsExchange {

  address public owner;


  string [] public allSecretsByIPFSAddress;
  string [] public allSecretsDescritpionsByIPFSAddress;
  mapping(string=>address) secretsOwners;

  mapping(string=>address) validatedSecrets;
  mapping(string=>uint256) appraisals;

  //timestamp of joined for uint256
  mapping(address=>uint256) validators;
  mapping(address=>uint256) appraisers;

  struct SecretDetails{
    uint25 uploadTime;
    string title;
    string description;
    address author;
    uint256 ipfsDataAddress;
    string status;
    string minimumPrice;
    string contentType;
  }

  mapping(string=>SecretDetails) secretsDetails;


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


  function createSecret(string memory submissionTitle, string submissionIPFSAddress, string submissionDescription, uint256 submissionMinimumPrice, string memory submissionContentType) public returns(bool){

    require (secretsOwners[submissionIPFSAddress] != address(0x0), "This IPFS address has already been registered");
    secretsOwners[submissionIPFSAddress] = msg.sender;
    allSecretsByIPFSAddress.push(submissionIPFSAddress);
    secretsDetails[submissionIPFSAddress] = SecretDetails(
        {
            title: submissionTitle,
            description: submissionDescription,
            author:msg.sender,
            ipfsDataAddress: submissionIPFSAddress,
            status: "pending",
            minimumPrice: submissionMinimumPrice,
            contentType: submissionContentType
        }
    );
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
