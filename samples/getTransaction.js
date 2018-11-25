const { web3, abiUtilities } = require('./config');

const abiDecoder = require('abi-decoder');
abiDecoder.addABI(abiUtilities);

web3.eth.getTransaction('0x19359f20c32f12779aca447a615aa2fcac8d579ae65553f9ff0ba76d571c4276').then(
	function(dataRaw) {
		var data = abiDecoder.decodeMethod(dataRaw.input);
		console.log(data, dataRaw.input);
	}
);