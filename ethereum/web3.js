import Web3 from 'web3';

let web3;

if (typeof window !== 'undefined' && typeof window.web3 !== 'undefined') {
  // Browser and Metamask is running
  web3 = new Web3(window.web3.currentProvider);
} else {
  // Server or browser without Metamask
  const provider = new Web3.providers.HttpProvider(
    'https://rinkeby.infura.io/2yCBWKlXvm4lchwqvmDQ'
  );

  web3 = new Web3(provider);
}

export default web3;
