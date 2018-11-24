const {
	Members,
	advertiserWalletAddress,
	bidderWalletAddress
} = require('../config');

Members.methods.blockMember(advertiserWalletAddress).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});