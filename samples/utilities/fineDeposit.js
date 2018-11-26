const {
	Utilities,
	advertiserWalletAddress,
	bidderWalletAddress
} = require('../config');

Utilities.methods.fineDeposit(
	advertiserWalletAddress,
	"100000000000000000"
).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});