const {
	UtilitiesV1,
	advertiserWalletAddress,
	bidderWalletAddress
} = require('../config');

UtilitiesV1.methods.withdrawDeposit(advertiserWalletAddress, "90000").send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});