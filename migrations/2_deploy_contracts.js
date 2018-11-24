var AdHashToken = artifacts.require("./AdHashToken.sol");

module.exports = function(deployer) {
	deployer.deploy(AdHashToken);
};