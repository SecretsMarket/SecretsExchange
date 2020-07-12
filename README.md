# Secrets Exchange Contracts for SecretsMkt

To get started, git clone this url.

`cd SecretsExchange`

`truffle compile`

If using Ganache or other test/prod environment, `truffle migrate` to deploy and test


## Overview

/contracts/SecretsExchange.sol contains getter and setter functions for setting and retrieving secrets.

The main characters here are authors of secrets, validators of secrets, appraisers of secrets and a DAO ownership group.

The validators, who are approved by the ownership DAO after applying via the smart contract, use 3Box confidential thread off-chain to validate the contents of the secret match the claim submitted by the submitting author/sharer.

The appraisers, who are approved by the ownership DAO after applying via the smart contract, use 3Box confidential thread to appraise the value above the minimum value of the submitting party's secret (if it meets the criteria)

All secrets descriptions are public and get be found directly via the smart contract.

Once a secret is appraised and validated, it can be purchased for higher than the appraisal price by anyone. 15% of funds are awarded to the validator, 15% awarded to the appraiser, 5% to the governance DAO (owner), and 65% to the sharer of the secret.

Ideally the owner of the contract is transferred to an Aragon DAO so onlyOwner modifier specifies a group rather than one address for decentralized governance if that is desired by deployer.



# TODO

- auction system (maybe?)
- tests
