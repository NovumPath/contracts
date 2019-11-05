const { UtilitiesV1, advertiserWalletAddress, bidderWalletAddress } = require('../config');

UtilitiesV1.methods.getDeposit(
	advertiserWalletAddress,
	bidderWalletAddress
).call(function(error, result) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log(result);
	}
});