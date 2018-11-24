const web3Library = require('web3');
const config = require('./config');

const web3 = new web3Library();
const web3HttpProvider = new web3.providers.HttpProvider(config.httpProvider);
web3.setProvider(web3HttpProvider);

const myContract = new web3.eth.Contract(config.abi, config.contractAddress);

myContract.methods.getAllowBidders().call(function(error, result) {
	if (error) {
		console.log('Error: ' + error);
	} else {
		console.log(result);
	}
});