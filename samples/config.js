const buildInfo = require('../build/contracts/Members.json');
const lastNetworkId = Object.keys(buildInfo.networks)[Object.keys(buildInfo.networks).length - 1];

exports.abi = buildInfo.abi;
exports.contractAddress = buildInfo.networks[lastNetworkId].address;
exports.httpProvider = 'http://localhost:8545';
exports.walletAddress = '0x19e7e376e7c213b7e7e7e46cc70a5dd086daff2a';

exports.ROLE_BIDDER = 1;
exports.ROLE_ADVERTISER = 2;
exports.ROLE_PUBLISHER = 3;
exports.ROLE_VOTER = 4;
exports.ROLE_OTHER = 5;