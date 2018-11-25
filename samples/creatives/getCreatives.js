const { Creatives, advertiserWalletAddress } = require('../config');

Creatives.methods.getCreatives(advertiserWalletAddress).call(function(error, result) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log(result);
	}
});