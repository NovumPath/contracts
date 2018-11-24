const { Utilities, advertiserWalletAddress } = require('../config');

Utilities.methods.getDeposit(advertiserWalletAddress).call(function(error, result) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log(result);
	}
});