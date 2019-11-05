const {
	UtilitiesV1,
	contractAddressMembersRegistry,
	bidderWalletAddress
} = require('../config');

UtilitiesV1.methods.changeMembersAddress(contractAddressMembersRegistry).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});
