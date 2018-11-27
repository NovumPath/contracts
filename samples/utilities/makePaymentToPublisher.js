const {
	UtilitiesV1,
	publisherWalletAddress,
	bidderWalletAddress
} = require('../config');

UtilitiesV1.methods.makePaymentToPublisher(
	publisherWalletAddress,
	18000,
	'0x356a192b7913b04c54574d18c28d46e6395428ab',
	'0xda4b9237bacccdf19c0760cab7aec4a8359010b0'
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