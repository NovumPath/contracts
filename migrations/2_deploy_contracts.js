var Token = artifacts.require("./Token.sol");
var Utilities = artifacts.require("./Utilities.sol");
var Members = artifacts.require("./Members.sol");
var Creatives = artifacts.require("./Creatives.sol");

module.exports = function(deployer) {
	deployer.deploy(Token);
	deployer.deploy(Utilities);
	deployer.deploy(Members);
	deployer.deploy(Creatives);
};