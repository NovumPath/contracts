const {
	UtilitiesRegistry,
	contractAddressUtilitiesV1,
	bidderWalletAddress
} = require('../config');

UtilitiesRegistry.methods.setContractAddress(contractAddressUtilitiesV1).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});