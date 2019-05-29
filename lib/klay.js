'use strict';

const fs = require('fs'),
  Caver = require('caver-js');
require('dotenv').config();

const config = {
  rpcURL: 'https://api.baobab.klaytn.net:8651'
};

const cav = new Caver(config.rpcURL);

const abi = JSON.parse(fs.readFileSync('./build/contracts/EVlock.json', 'utf8')).abi;
const contract = new cav.klay.Contract(abi, process.env.CONTRACT_ADDRESS);

module.exports = {
  getContactNmae: async function () {
    return await contract.methods.name().call();
  }
};