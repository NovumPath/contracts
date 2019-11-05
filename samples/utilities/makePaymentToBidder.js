const {
	UtilitiesV1,
	advertiserWalletAddress,
	bidderWalletAddress
} = require('../config');

UtilitiesV1.methods.makePaymentToBidder(
	bidderWalletAddress,
	80000,
	12345,
	'0x0000000000000000000000000000000000000001',
	'0x0000000000000000000000000000000000000002'
).send({
	from: advertiserWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});