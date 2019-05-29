'use strict';

const fs = require('fs'),
  Caver = require('caver-js');
require('dotenv').config();

const config = {
  rpcURL: 'https://api.baobab.klaytn.net:8651'
};

const cav = new Caver(config.rpcURL);
const gas_limit = '20000000';

const wallet = cav.klay.accounts.privateKeyToAccount(process.env.CONTRACT_ADDRESS);
cav.klay.accounts.wallet.add(wallet);

const abi = JSON.parse(fs.readFileSync('./build/contracts/EVlock.json', 'utf8')).abi;
const contract = new cav.klay.Contract(abi, process.env.CONTRACT_ADDRESS);

module.exports = {
  getContactNmae: async () => {
    return await contract.methods.name().call();
  },
  sellEV: async (amount, price) => {
    contract.methods.registerSelling(amount, price).send({
      from: wallet.address,
      gas: gas_limit
    }).once('transactionHash', (txHash) => {
      console.log(`txHash: ${txHash}`);
    })
  }
};