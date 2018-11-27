const {
	MembersV1,
	bidderWalletAddress
} = require('../config');

MembersV1.methods.getMemberRole(bidderWalletAddress).call(function(error, result) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log(result);
	}
});