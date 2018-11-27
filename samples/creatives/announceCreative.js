const {
	CreativesV1,
	advertiserWalletAddress
} = require('../config');

CreativesV1.methods.announceCreative('0x356a192b7913b04c54574d18c28d46e6395428ab').send({
	from: advertiserWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});