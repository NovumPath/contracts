const { Members, bidderWalletAddress } = require('../config');

Members.methods.getMember(bidderWalletAddress).call(function(error, result) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log(result);
	}
});