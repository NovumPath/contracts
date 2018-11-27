const {
	CreativesRegistry,
	contractAddressCreativesV1,
	bidderWalletAddress
} = require('../config');

CreativesRegistry.methods.setContractAddress(contractAddressCreativesV1).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});