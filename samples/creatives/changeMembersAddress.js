const {
	CreativesV1,
	contractAddressMembers,
	bidderWalletAddress
} = require('../config');

CreativesV1.methods.changeMembersAddress(contractAddressMembers).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});