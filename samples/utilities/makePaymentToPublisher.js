const {
	UtilitiesV1,
	publisherWalletAddress,
	bidderWalletAddress
} = require('../config');

UtilitiesV1.methods.makePaymentToPublisher(
	publisherWalletAddress,
	75000,
	12345,
	'0x0000000000000000000000000000000000000001',
	'0x0000000000000000000000000000000000000001'
).send({
	from: bidderWalletAddress,
	value: 1000000000000000000
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});