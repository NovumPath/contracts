const { Creatives, contractAddressMembers, bidderWalletAddress, advertiserWalletAddress } = require('../config');

Creatives.methods.changeMembersAddress(contractAddressMembers).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});

