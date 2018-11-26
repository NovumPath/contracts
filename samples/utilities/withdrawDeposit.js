const {
	Utilities,
	advertiserWalletAddress,
	bidderWalletAddress
} = require('../config');

Utilities.methods.withdrawDeposit(
	bidderWalletAddress,
	"100000000000000000"
).send({
	from: advertiserWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});