'use strict';

const fs = require('fs'),
  Caver = require('caver-js'),
  gpio = require('./gpio');
require('dotenv').config();

const config = {
  rpcURL: 'https://api.baobab.klaytn.net:8651'
};

const cav = new Caver(config.rpcURL);
const gas_limit = '20000000';

const wallet = cav.klay.accounts.privateKeyToAccount(process.env.PRIVATE_KEY);
cav.klay.accounts.wallet.add(wallet);

const abi = JSON.parse(fs.readFileSync('./build/contracts/EVlock.json', 'utf8')).abi;
const contract = new cav.klay.Contract(abi, process.env.CONTRACT_ADDRESS);

module.exports = {
  getContactNmae: async () => {
    return await contract.methods.name().call();
  },
  createTokens: async (value) => {
    contract.methods.createTokens().send({
      from: wallet.address,
      gas: gas_limit,
      value: cav.utils.toPeb(value, 'KLAY')
    }).once('transactionHash', (data) => {
      console.log(`txHash: ${JSON.stringify(data.txHash)}`);
    }).once('error', error => {
      console.log(error)
    })
  },
  checkBalance: async (address) => {
    return await contract.methods.balanceOf(address).call();
  },
  sellEV: async (amount, price) => {
    contract.methods.registerSelling(amount, price).send({
      from: wallet.address,
      gas: gas_limit
    }).once('transactionHash', (data) => {
      console.log(`sellEV txHash: ${JSON.stringify(data.txHash)}`);
    }).once('error', error => {
      console.log(error)
    })
  },
  buyEV: async (seller, amount) => {
    contract.methods.buyEV(seller, amount).send({
      from: wallet.address,
      gas: gas_limit
    }).once('transactionHash', (data) => {
      console.log(`buyEV txHash: ${JSON.stringify(data.txHash)}`);
      gpio.setupRelep();
      gpio.startTransferEV(amount);
    }).once('error', error => {
      console.log(error)
    })
  }
};