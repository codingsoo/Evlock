'use strict';

const Web3 = require('web3'),
  Tx = require('ethereumjs-tx'),
  Interface = require('./contracts/interface'),
  lightwallet = require('eth-lightwallet'),
  dotenv = require('dotenv'),
  gpio = require('./gpio');

dotenv.config();

const web3 = new Web3(new Web3.providers.HttpProvider('https://rinkeby.infura.io/v3/'+ process.env.INFURA_API_KEY));
const txutils = lightwallet.txutils;

function sendRaw(rawTx, privateKey, transfer) {
  const tx = new Tx(rawTx);
  tx.sign(privateKey);

  const serializedTx = tx.serialize().toString('hex');
  web3.eth.sendRawTransaction('0x' + serializedTx, 
  (err, result) => {
    if(err) {
      console.log(err);
    } else {
      console.log('\n...Transaction Send to: Rinkeby Testnet');
      console.log('Tx: ' + result);
      if (transfer != 0) {
        gpio.setupRelep();
        gpio.startTransferEV(transfer);
      }
    }
  });
}

module.exports = (name, parms) => {
  const txOptions = {
    gasLimit: web3.toHex(800000),
    gasPrice: web3.toHex(20000000000),
    to: process.env.CONTRACT_ADDR
  }
  let privateKey, rawTx, transfer = 0;

  switch (name) {
    case 'sell':
      txOptions.nonce = web3.toHex(web3.eth.getTransactionCount(process.env.SELLER_ADDR));
      privateKey = new Buffer(process.env.SELLER_PRIVATE_KEY, 'hex');
      rawTx = txutils.functionTx(Interface, 'registerSelling', 
                                [ parms.sellAmount,
                                  parms.sellPrice ], txOptions);
      break;
    case 'buy':
      txOptions.nonce = web3.toHex(web3.eth.getTransactionCount(process.env.BUYER_ADDR));
      privateKey = new Buffer(process.env.BUYER_PRIVATE_KEY, 'hex');
      rawTx = txutils.functionTx(Interface, 'buyEV',
                                [ parms.sellerNum,
                                  parms.sellAmount ], txOptions);
      transfer = parseInt(parms.sellAmount);
      break;
    default:
      console.log('Error: Unauthorized Actions.');
      process.exit(1)
  }

  sendRaw(rawTx, privateKey, transfer);
}
