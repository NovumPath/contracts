const {
	MembersRegistry,
	contractAddressMembersV1,
	bidderWalletAddress
} = require('../config');

MembersRegistry.methods.setContractAddress(contractAddressMembersV1).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});