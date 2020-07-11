const SecretsExchange = artifacts.require("SecretsExchange");

module.exports = function(deployer) {
  deployer.deploy(SecretsExchange);
};
