const {
	CreativesV1,
	bidderWalletAddress
} = require('../config');

CreativesV1.methods.changeThresholdStep(15).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});
