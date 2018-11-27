const { UtilitiesV1, advertiserWalletAddress } = require('../config');

UtilitiesV1.methods.getDeposit(advertiserWalletAddress).call(function(error, result) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log(result);
	}
});