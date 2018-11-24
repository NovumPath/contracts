const { Members, bidderWalletAddress } = require('../config');

Members.methods.allowBidders(true).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});