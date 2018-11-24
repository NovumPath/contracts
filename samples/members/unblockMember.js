const {
	Members,
	advertiserWalletAddress,
	bidderWalletAddress
} = require('../config');

Members.methods.unblockMember(advertiserWalletAddress).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});