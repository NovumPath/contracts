const {
	MembersV1,
	bidderWalletAddress
} = require('../config');

MembersV1.methods.changeInformation(
	"AdHash bidder 2",
	"http://bidder.adhash.org/protocol2.php"
).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});