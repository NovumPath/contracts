const {
	UtilitiesV1,
	advertiserWalletAddress,
	bidderWalletAddress
} = require('../config');

UtilitiesV1.methods.fineDeposit(
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