const {
	Utilities,
	advertiserWalletAddress,
	bidderWalletAddress
} = require('../config');

Utilities.methods.withdrawDeposit(bidderWalletAddress).send({
	from: advertiserWalletAddress,
	value: 1000000000000000000
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});