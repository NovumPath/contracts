const web3Library = require('web3');
const config = require('./config');

const web3 = new web3Library();
const web3HttpProvider = new web3.providers.HttpProvider(config.httpProvider);
web3.setProvider(web3HttpProvider);

const myContract = new web3.eth.Contract(config.abi, config.contractAddress);

myContract.methods.getMember('0x19e7e376e7c213b7e7e7e46cc70a5dd086daff2a').call(function(error, result) {
	if (error) {
		console.log('Error: ' + error);
	} else {
		console.log(result);
	}
});