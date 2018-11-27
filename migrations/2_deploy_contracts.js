var Token = artifacts.require("./Token.sol");
var Utilities = artifacts.require("./Utilities.sol");
var Members = artifacts.require("./Members.sol");
var CreativesRegistry = artifacts.require("./CreativesRegistry.sol");
var CreativesV1 = artifacts.require("./CreativesV1.sol");

module.exports = function(deployer) {
	deployer.deploy(Token);
	deployer.deploy(Utilities);
	deployer.deploy(Members);
	deployer.deploy(CreativesRegistry);
	deployer.deploy(CreativesV1);
};