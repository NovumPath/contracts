const {
	UtilitiesV1,
	contractAddressToken,
	bidderWalletAddress
} = require('../config');

UtilitiesV1.methods.changeTokenAddress(contractAddressToken).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});
