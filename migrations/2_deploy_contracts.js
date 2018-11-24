var Token = artifacts.require("./Token.sol");
var Utilities = artifacts.require("./Utilities.sol");
var Members = artifacts.require("./Members.sol");

module.exports = function(deployer) {
	deployer.deploy(Token);
	deployer.deploy(Utilities);
	deployer.deploy(Members);
};