const { Token, bidderWalletAddress, advertiserWalletAddress } = require('../config');

Token.methods.transfer(advertiserWalletAddress, process.argv[2]).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});