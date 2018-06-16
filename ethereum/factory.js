import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(
  JSON.parse(CampaignFactory.interface),
  '0x74336549a92A13b65334f631DeF8DbF55FB1BF21'
);

export default instance;
