const {
	CreativesV1,
	bidderWalletAddress
} = require('../config');

CreativesV1.methods.changeInitialThreshold(60).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});
