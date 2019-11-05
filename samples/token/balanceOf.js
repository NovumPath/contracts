const { Token, bidderWalletAddress } = require('../config');

Token.methods.balanceOf(
	process.argv[2] || bidderWalletAddress
).call(function(error, result) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log(result);
	}
});