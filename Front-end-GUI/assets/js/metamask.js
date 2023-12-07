/*****************************************/
/* Detect the MetaMask Ethereum provider */
/*****************************************/

// import detectEthereumProvider from '@metamask/detect-provider';

// const provider = await detectEthereumProvider();

// if (provider) {
//   startApp(provider);
// } else {
//   console.log('Please install MetaMask!');
// }

// function startApp(provider) {
//   if (provider !== window.ethereum) {
//     console.error('Do you have multiple wallets installed?');
//   }
// }

// // /**********************************************************/
// // /* Handle chain (network) and chainChanged (per EIP-1193) */
// // /**********************************************************/

// const chainId = await window.ethereum.request({ method: 'eth_chainId' });

// window.ethereum.on('chainChanged', handleChainChanged);

// function handleChainChanged(chainId) {
//   window.location.reload();
// }

// // /***********************************************************/
// // /* Handle user accounts and accountsChanged (per EIP-1193) */
// // /***********************************************************/

// let currentAccount = null;
// window.ethereum.request({ method: 'eth_accounts' })
//   .then(handleAccountsChanged)
//   .catch((err) => {
//     console.error(err);
//   });

// window.ethereum.on('accountsChanged', handleAccountsChanged);

// function handleAccountsChanged(accounts) {
//   if (accounts.length === 0) {
//     console.log('Please connect to MetaMask.');
//   } else if (accounts[0] !== currentAccount) {
//     currentAccount = accounts[0];
//     showAccount.innerHTML = currentAccount;
//   }
// }

// // /*********************************************/
// // /* Access the user's accounts (per EIP-1102) */
// // /*********************************************/

// const ethereumButton = document.querySelector('.enableEthereumButton');
// const showAccount = document.querySelector('.showAccount');

// ethereumButton.addEventListener('click', () => {
//   getAccount();
// });

// async function getAccount() {
//   const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' })
//     .catch((err) => {
//       if (err.code === 4001) {
//         console.log('Please connect to MetaMask.');
//       } else {
//         console.error(err);
//       }
//     });
//   const account = accounts[0];
//   showAccount.innerHTML = account;
// }


// Init Web3
let web3 = new Web3(Web3.givenProvider || "ws://localhost:8545");

// Check if connected
web3.eth.net.isListening()
.catch(function (err) {		
	console.log("Couldn't connect to any node. Please install MetaMask");
	alert("No MetaMask extension detected. To enable Ledgermon please visit https://metamask.io/download");
});

//Web3 version > 1
console.log(web3.version)

var contractAddress = "0x38610f1b3606cebed6b8d38a6f23b9dcc772f6dd"; 

// Set the Contract
var contract = new web3.eth.Contract(abi,contractAddress);

//Connection function
function connectMeta() {
	const accounts = ethereum.request({ method: 'eth_requestAccounts' });
}

//Run the button click minting function
function mintNow() {
	//check metamsk is still connected. Press twice to mint if not.
	const accounts = ethereum.request({ method: 'eth_requestAccounts' });

	console.log("Minting!")
	// Time to reload your interface with accounts[0] if you change!
	window.ethereum.on('accountsChanged', function (accounts) {
		console.log(accounts[0])
	});

	//Get the current wallet address to use in contract
	var account = web3.currentProvider.selectedAddress;
	console.log("To account:",account);
	
	const cost=web3.utils.toWei('0.0001', 'ether');
	console.log("Total cost in wei:",cost)

  contract.methods.MINT().send({
    to: contractAddress,
    from: account,
    value: cost
  }).then(function(res){
    console.log(res);
  }).catch(function(err) {
    console.log(err);
  });
		
}