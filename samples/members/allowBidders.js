const {
	MembersV1,
	bidderWalletAddress
} = require('../config');

MembersV1.methods.allowBidders(process.argv[2] === "true").send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});