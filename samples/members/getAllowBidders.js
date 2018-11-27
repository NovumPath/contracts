const {
	MembersV1
} = require('../config');

MembersV1.methods.getAllowBidders().call(function(error, result) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log(result);
	}
});