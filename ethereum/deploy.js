const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const compiledFactory = require('./build/CampaignFactory.json');

const provider = new HDWalletProvider(
  'decline poverty swift chalk popular warm hundred hair protect hundred arrive ability',
  'https://rinkeby.infura.io/2yCBWKlXvm4lchwqvmDQ'
);

const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();
  console.log('Attempting to deploy from account: ', accounts[0]);

  const result = await new web3.eth.Contract(
    JSON.parse(compiledFactory.interface)
  )
    .deploy({ data: '0x' + compiledFactory.bytecode })
    .send({
      gas: '1000000',
      from: accounts[0]
    });

  console.log('Contract deployed to: ', result.options.address);
};
deploy();
