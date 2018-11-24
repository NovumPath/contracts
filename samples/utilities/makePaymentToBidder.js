const {
	Utilities,
	advertiserWalletAddress,
	bidderWalletAddress
} = require('../config');

Utilities.methods.makePaymentToBidder(
	bidderWalletAddress,
	18000,
	'356a192b7913b04c54574d18c28d46e6395428ab',
	'da4b9237bacccdf19c0760cab7aec4a8359010b0'
).send({
	from: advertiserWalletAddress,
	value: 1000000000000000000
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});