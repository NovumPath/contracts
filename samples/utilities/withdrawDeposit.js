const {
	UtilitiesV1,
	advertiserWalletAddress,
	bidderWalletAddress
} = require('../config');

UtilitiesV1.methods.withdrawDeposit(
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