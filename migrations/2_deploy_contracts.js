var Token = artifacts.require("./Token.sol");
var UtilitiesRegistry = artifacts.require("./UtilitiesRegistry.sol");
var UtilitiesV1 = artifacts.require("./UtilitiesV1.sol");
var Members = artifacts.require("./Members.sol");
var CreativesRegistry = artifacts.require("./CreativesRegistry.sol");
var CreativesV1 = artifacts.require("./CreativesV1.sol");

module.exports = function(deployer) {
	deployer.deploy(Token);
	deployer.deploy(UtilitiesRegistry);
	deployer.deploy(UtilitiesV1);
	deployer.deploy(Members);
	deployer.deploy(CreativesRegistry);
	deployer.deploy(CreativesV1);
};