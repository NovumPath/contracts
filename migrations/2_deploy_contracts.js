var Token = artifacts.require("./Token.sol");
var MembersRegistry = artifacts.require("./MembersRegistry.sol");
var MembersV1 = artifacts.require("./MembersV1.sol");
var CreativesRegistry = artifacts.require("./CreativesRegistry.sol");
var CreativesV1 = artifacts.require("./CreativesV1.sol");
var UtilitiesRegistry = artifacts.require("./UtilitiesRegistry.sol");
var UtilitiesV1 = artifacts.require("./UtilitiesV1.sol");

module.exports = function(deployer) {
	deployer.deploy(Token);
	deployer.deploy(MembersRegistry);
	deployer.deploy(MembersV1);
	deployer.deploy(CreativesRegistry);
	deployer.deploy(CreativesV1);
	deployer.deploy(UtilitiesRegistry);
	deployer.deploy(UtilitiesV1);
};