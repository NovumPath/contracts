const {
	web3,
	abiUtilitiesV1,
	abiCreativesV1,
	abiMembersV1,
	abiToken
} = require('./config');

const abiDecoder = require('abi-decoder');
abiDecoder.addABI(abiUtilitiesV1);
abiDecoder.addABI(abiCreativesV1);
abiDecoder.addABI(abiMembersV1);
abiDecoder.addABI(abiToken);

web3.eth.getTransaction(process.argv[2]).then(
	function(dataRaw) {
		var data = abiDecoder.decodeMethod(dataRaw.input);
		console.log(dataRaw.input);
		console.log(data);
	}
);