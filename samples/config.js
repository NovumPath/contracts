const web3Library = require('web3');

const buildInfoMembersRegistry = require('../build/contracts/MembersRegistry.json');
const networkMembersRegistry = Object.keys(buildInfoMembersRegistry.networks)[Object.keys(buildInfoMembersRegistry.networks).length - 1];
exports.contractAddressMembersRegistry = buildInfoMembersRegistry.networks[networkMembersRegistry].address;
exports.abiMembersRegistry = buildInfoMembersRegistry.abi;

const buildInfoMembersV1 = require('../build/contracts/MembersV1.json');
const networkMembersV1 = Object.keys(buildInfoMembersV1.networks)[Object.keys(buildInfoMembersV1.networks).length - 1];
exports.contractAddressMembersV1 = buildInfoMembersV1.networks[networkMembersV1].address;
exports.abiMembersV1 = buildInfoMembersV1.abi;

const buildInfoCreativesRegistry = require('../build/contracts/CreativesRegistry.json');
const networkCreativesRegistry = Object.keys(buildInfoCreativesRegistry.networks)[Object.keys(buildInfoCreativesRegistry.networks).length - 1];
exports.contractAddressCreativesRegistry = buildInfoCreativesRegistry.networks[networkCreativesRegistry].address;
exports.abiCreativesRegistry = buildInfoCreativesRegistry.abi;

const buildInfoCreativesV1 = require('../build/contracts/CreativesV1.json');
const networkCreativesV1 = Object.keys(buildInfoCreativesV1.networks)[Object.keys(buildInfoCreativesV1.networks).length - 1];
exports.contractAddressCreativesV1 = buildInfoCreativesV1.networks[networkCreativesV1].address;
exports.abiCreativesV1 = buildInfoCreativesV1.abi;

const buildInfoUtilitiesRegistry = require('../build/contracts/UtilitiesRegistry.json');
const networkUtilitiesRegistry = Object.keys(buildInfoUtilitiesRegistry.networks)[Object.keys(buildInfoUtilitiesRegistry.networks).length - 1];
exports.contractAddressUtilitiesRegistry = buildInfoUtilitiesRegistry.networks[networkUtilitiesRegistry].address;
exports.abiUtilitiesRegistry = buildInfoUtilitiesRegistry.abi;

const buildInfoUtilitiesV1 = require('../build/contracts/UtilitiesV1.json');
const networkUtilitiesV1 = Object.keys(buildInfoUtilitiesV1.networks)[Object.keys(buildInfoUtilitiesV1.networks).length - 1];
exports.contractAddressUtilitiesV1 = buildInfoUtilitiesV1.networks[networkUtilitiesV1].address;
exports.abiUtilitiesV1 = buildInfoUtilitiesV1.abi;

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

exports.MembersRegistry = new web3.eth.Contract(
	exports.abiMembersRegistry,
	exports.contractAddressMembersRegistry,
	{ gas: 300000 }
);

exports.MembersV1 = new web3.eth.Contract(
	exports.abiMembersV1,
	exports.contractAddressMembersRegistry, //!
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

exports.UtilitiesRegistry = new web3.eth.Contract(
	exports.abiUtilitiesRegistry,
	exports.contractAddressUtilitiesRegistry,
	{ gas: 300000 }
);

exports.UtilitiesV1 = new web3.eth.Contract(
	exports.abiUtilitiesV1,
	exports.contractAddressUtilitiesRegistry, //!
	{ gas: 300000 }
);