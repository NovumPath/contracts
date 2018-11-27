const { CreativesV1, advertiserWalletAddress } = require('../config');

CreativesV1.methods.getCreatives(advertiserWalletAddress).call(function(error, result) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log(result);
	}
});