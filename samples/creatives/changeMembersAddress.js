const {
	CreativesV1,
	contractAddressMembersV1,
	bidderWalletAddress
} = require('../config');

CreativesV1.methods.changeMembersAddress(contractAddressMembersV1).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});
