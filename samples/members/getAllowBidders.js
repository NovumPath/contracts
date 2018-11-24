const { Members } = require('../config');

Members.methods.getAllowBidders().call(function(error, result) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log(result);
	}
});