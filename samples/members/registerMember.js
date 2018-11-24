const {
	Members,
	bidderWalletAddress,
	ROLE_BIDDER
} = require('../config');

Members.methods.registerMember(
	ROLE_BIDDER,
	"AdHash bidder",
	"http://bidder.adhash.org/protocol.php"
).send({
	from: bidderWalletAddress
}, function(error, transactionId) {
	if (error) {
		console.log('Error', error);
	} else {
		console.log('Transaction successful', transactionId);
	}
});