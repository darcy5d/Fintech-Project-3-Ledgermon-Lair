// Init Web3
let web3 = new Web3(Web3.givenProvider || "ws://localhost:8545");

// Check if connected
web3.eth.net.isListening()
.catch(function (err) {		
	console.log("Couldn't connect to any node. Please install MetaMask");
	alert("No MetaMask extension detected. To enable minting please visit https://metamask.io/download");
});

//Web3 version > 1
console.log(web3.version)

// Set Contract Address Test: "0xFDb1EaC680658E343673cb0518cE6618ac4875f6"
var contractAddress = "0xc67A55C009Fd516CBda4502dE26d1326eb0028F2"; 

// Set the Contract
var contract = new web3.eth.Contract(abi,contractAddress);

//Connection function
function connectMeta() {
	const accounts = ethereum.request({ method: 'eth_requestAccounts' });
}

//Run the button click minting function
function mintNow(amt) {
	//check metamsk is still connected. Press twice to mint if not.
	const accounts = ethereum.request({ method: 'eth_requestAccounts' });

	console.log("Minting:", amt)
	// Time to reload your interface with accounts[0] if you change!
	window.ethereum.on('accountsChanged', function (accounts) {
		console.log(accounts[0])
	});

	//Get the current wallet address to use in contract
	var account = web3.currentProvider.selectedAddress;
	console.log("To account:",account);
	
	const cost=web3.utils.toWei('0.15', 'ether');
	console.log("Total cost in wei:",cost*amt)

	//check totalsupply, if okay mint the nft!
	contract.methods.totalSupply().call().then(function(res){
		console.log("Total Minted:",res);

		if ((+res + +amt) >= 433) {
			
			alert("Mint exhausted. Look out for Geneverse V2. In the meantime check out the collection on the OpenSea secondary market. Thank you everyone!");

		} else {
			contract.methods.mint(amt).send({
				to: contractAddress,
				from: account,
				value: cost*amt
			}).then(function(res){
				console.log(res);
			}).catch(function(err) {
				console.log(err);
			});
		}

		})

}