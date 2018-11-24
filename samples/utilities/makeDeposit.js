const {
	Utilities,
	advertiserWalletAddress,
	bidderWalletAddress
} = require('../config');

Utilities.methods.makeDeposit(bidderWalletAddress).send({
	from: advertiserWalletAddress,
	value: 1000000000000000000
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});