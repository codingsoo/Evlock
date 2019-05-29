const PrivateKeyConnector = require('connect-privkey-to-provider');
require('dotenv').config();

const NETWORK_ID = '1001',
  GAS_LIMIT = '20000000',
  URL = 'https://api.baobab.klaytn.net:8651';

module.exports = {
  networks: {
    klaytn: {
      provider: new PrivateKeyConnector(process.env.PRIVATE_KEY, URL),
      network_id: NETWORK_ID,
      gas: GAS_LIMIT,
      gasPrice: null,
    }
  },
  compilers: {
    solc: {
      version: "0.4.24"
    }
  }
};
