// metamask_connect.js

async function detectMetaMask() {
  const provider = await detectEthereumProvider();

  if (provider) {
    startApp(provider);
  } else {
    console.log("Please install MetaMask!");
  }
}

function startApp(provider) {
  if (provider !== window.ethereum) {
    console.error("Do you have multiple wallets installed?");
  }
  // Other initialization code
}

async function setupChain() {
  const chainId = await window.ethereum.request({
    method: "eth_chainId",
  });
  window.ethereum.on("chainChanged", handleChainChanged);
}

function handleChainChanged(chainId) {
  // Handle the chain changing
}

async function setupAccounts() {
  let currentAccount = null;

  window.ethereum
    .request({ method: "eth_accounts" })
    .then(handleAccountsChanged)
    .catch((err) => {
      console.error(err);
    });

  window.ethereum.on("accountsChanged", handleAccountsChanged);

  function handleAccountsChanged(accounts) {
    if (accounts.length === 0) {
      console.log("Please connect to MetaMask.");
    } else if (accounts[0] !== currentAccount) {
      currentAccount = accounts[0];
      // Update the account display here
    }
  }
}

async function getAccount() {
  const accounts = await window.ethereum
    .request({ method: "eth_requestAccounts" })
    .catch((err) => {
      if (err.code === 4001) {
        console.log("Please connect to MetaMask.");
      } else {
        console.error(err);
      }
    });

  if (accounts) {
    const account = accounts[0];
    // Update the account display here
  }
}

let web3;
async function initWeb3() {
  web3 = new Web3(Web3.givenProvider || "ws://localhost:8545");

  web3.eth.net.isListening().catch(function (err) {
    console.log("Couldn't connect to any node. Please install MetaMask");
  });

  console.log(web3.version);
}

// Attach the event listener to the appropriate element
document.addEventListener("DOMContentLoaded", (event) => {
  const button = document.querySelector(".tg-btn-5");
  if (button) {
    button.addEventListener("click", (e) => {
      e.preventDefault();
      getAccount();
    });
  } else {
    console.error("Button not found");
  }
});
