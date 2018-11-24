const {
	Utilities,
	advertiserWalletAddress
} = require('../config');

Utilities.methods.announceCreative('356a192b7913b04c54574d18c28d46e6395428ab').send({
	from: advertiserWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});

Utilities.methods.announceCreative('da4b9237bacccdf19c0760cab7aec4a8359010b0').send({
	from: advertiserWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});