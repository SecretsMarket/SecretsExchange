
//SecretsMarket Testnet Contact: this has not been audited and is under constant development. Do not use yet.

pragma experimental ABIEncoderV2;


pragma solidity 0.6.6;

contract SecretsExchange {
  using SafeMath
    for uint256;

  address payable public  owner;


  //variables for searching/ discovery
  string [] public allSecretsByIPFSAddress;
  string [] public allSecretsByTitle;
  address [] public allSecretsByAuthor;

  mapping (string => address) secretsOwners ;
  mapping(string=>address payable) validatedSecretsMappedToKeyValidator;
  mapping (string => address payable) validatedSecretsMappedToAppraiser;
  mapping(string=>uint256) appraisals;
  mapping(address=>uint256) validatorApplicants;
  mapping(address=>uint256) appraiserApplicants;
  mapping(string => string) secretStatuses;


  mapping(address=>uint256) validators; //ratingis the uint256
  mapping(address=>uint256) appraisers; //the appraisers rating is the uint256

  struct SecretDetails{
    uint256 uploadTime;
    string title;
    string description;
    address author;
    string ipfsDataAddress;
    string status;
    uint256 minimumPrice;
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


  function createSecret(string memory submissionTitle, string memory submissionIPFSAddress, string memory submissionDescription, uint256 submissionMinimumPrice, string memory submissionContentType) public returns(bool){

    require (secretsOwners[submissionIPFSAddress] != address(0x0), "This IPFS address has already been registered");
    secretsOwners[submissionIPFSAddress] = msg.sender;
    allSecretsByIPFSAddress.push(submissionIPFSAddress);
    allSecretsByTitle.push(submissionTitle);
    allSecretsByAuthor.push(msg.sender);
    secretStatuses[submissionIPFSAddress] = 'pending';

    secretsDetails[submissionIPFSAddress] = SecretDetails(
        {
            uploadTime: block.timestamp,
            title: submissionTitle,
            description: submissionDescription,
            author:msg.sender,
            ipfsDataAddress: submissionIPFSAddress,
            status:  secretStatuses[submissionIPFSAddress],
            minimumPrice: submissionMinimumPrice,
            contentType: submissionContentType
        }
    );
    return true;
  }

  function applyToBecomeValidator() public returns (bool){
    validatorApplicants[msg.sender] = block.timestamp;
  }

  function applyToBecomeAppraiser() public returns (bool){
    appraiserApplicants[msg.sender] = block.timestamp;
  }


  function confirmApplicantValidator(uint rating, address applicantAddress) public onlyOwner returns(bool){
      validators[applicantAddress] = rating;
      return true;
  }

  function confirmApplicationAppraiser(uint rating, address applicantAddress) public onlyOwner returns(bool){
      appraisers[applicantAddress] = rating;
      return true;
  }


  function verifySecret(string memory ipfsAddress) onlyValidators payable public returns(bool) {
    validatedSecretsMappedToKeyValidator[ipfsAddress] = msg.sender;
    return true;
  }

  function appraiseSecret(string memory ipfsAddress, uint256 amount ) public onlyAppraisers returns(bool){
      appraisals[ipfsAddress] = amount;
      return true;
  }

  function buySecret(bool exclusiveBool, string memory ipfsAddress) payable public returns(bool){

    uint256 totalAmount = msg.value;
    //15 percent each
    uint256 valAndAppraiserShare = totalAmount.mul(1000).div(6666);
    //5 percent
    uint256 ownerShare =  totalAmount.mul(1000).div(2000);

    uint256 uploaderShare = totalAmount.sub((ownerShare.add(valAndAppraiserShare).add(valAndAppraiserShare)));

    msg.sender.send(uploaderShare);
    validatedSecretsMappedToAppraiser[ipfsAddress].send(valAndAppraiserShare);
    validatedSecretsMappedToKeyValidator[ipfsAddress].send(valAndAppraiserShare);
    owner.send(ownerShare);

    secretsOwners[ipfsAddress] = msg.sender;
    return true;


  }

  function makeSecretPublicAfterPurchase(string memory ipfsAddress) public{
    if(secretsOwners[ipfsAddress] == msg.sender){
      secretStatuses[ipfsAddress] = 'public';
    }
  }

  function rateAppraiser(address appraiserAddress, uint256 rating) public onlyOwner{
    appraisers[appraiserAddress] = rating;
  }
  function rateValidator(address validatorAddress, uint256 rating) public onlyOwner{
    validators[validatorAddress] = rating;
  }
}


library SafeMath {
    function mul(uint256 a, uint256 b) internal view returns(uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal view returns(uint256) {
        assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal view returns(uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal view returns(uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}
