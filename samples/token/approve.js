const { Token, contractAddressUtilitiesRegistry } = require('../config');

Token.methods.approve(contractAddressUtilitiesRegistry, process.argv[3]).send({
	from: process.argv[2]
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});