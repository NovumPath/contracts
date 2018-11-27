const {
	MembersV1,
	advertiserWalletAddress,
	bidderWalletAddress
} = require('../config');

MembersV1.methods.unblockMember(advertiserWalletAddress).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});