const web3Library = require('web3');

const buildInfoMembers = require('../build/contracts/Members.json');
const networkMembers = Object.keys(buildInfoMembers.networks)[Object.keys(buildInfoMembers.networks).length - 1];
exports.contractAddressMembers = buildInfoMembers.networks[networkMembers].address;
exports.abiMembers = buildInfoMembers.abi;

const buildInfoCreativesRegistry = require('../build/contracts/CreativesRegistry.json');
const networkCreativesRegistry = Object.keys(buildInfoCreativesRegistry.networks)[Object.keys(buildInfoCreativesRegistry.networks).length - 1];
exports.contractAddressCreativesRegistry = buildInfoCreativesRegistry.networks[networkCreativesRegistry].address;
exports.abiCreativesRegistry = buildInfoCreativesRegistry.abi;

const buildInfoCreativesV1 = require('../build/contracts/CreativesV1.json');
const networkCreativesV1 = Object.keys(buildInfoCreativesV1.networks)[Object.keys(buildInfoCreativesV1.networks).length - 1];
exports.contractAddressCreativesV1 = buildInfoCreativesV1.networks[networkCreativesV1].address;
exports.abiCreativesV1 = buildInfoCreativesV1.abi;

const buildInfoUtilities = require('../build/contracts/Utilities.json');
const networkUtilities = Object.keys(buildInfoUtilities.networks)[Object.keys(buildInfoUtilities.networks).length - 1];
exports.contractAddressUtilities = buildInfoUtilities.networks[networkUtilities].address;
exports.abiUtilities = buildInfoUtilities.abi;

exports.httpProvider = 'http://localhost:8545';

exports.bidderWalletAddress = '0x19e7e376e7c213b7e7e7e46cc70a5dd086daff2a';
exports.advertiserWalletAddress = '0x1563915e194D8CfBA1943570603F7606A3115508';
exports.publisherWalletAddress = '0x5CbDd86a2FA8Dc4bDdd8a8f69dBa48572EeC07FB';

exports.ROLE_BIDDER = 1;
exports.ROLE_ADVERTISER = 2;
exports.ROLE_PUBLISHER = 3;
exports.ROLE_VOTER = 4;
exports.ROLE_OTHER = 5;

const web3 = new web3Library();
const web3HttpProvider = new web3.providers.HttpProvider(exports.httpProvider);
web3.setProvider(web3HttpProvider);
exports.web3 = web3;

exports.Members = new web3.eth.Contract(
	exports.abiMembers,
	exports.contractAddressMembers,
	{ gas: 300000 }
);

exports.CreativesRegistry = new web3.eth.Contract(
	exports.abiCreativesRegistry,
	exports.contractAddressCreativesRegistry,
	{ gas: 300000 }
);

exports.CreativesV1 = new web3.eth.Contract(
	exports.abiCreativesV1,
	exports.contractAddressCreativesRegistry, //!
	{ gas: 300000 }
);

exports.Utilities = new web3.eth.Contract(
	exports.abiUtilities,
	exports.contractAddressUtilities,
	{ gas: 300000 }
);