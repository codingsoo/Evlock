'use strict';

const express = require('express'),
  asyncify = require('express-asyncify'),
  logger = require('morgan'),
  klay = require("./lib/klay");

const app = asyncify(express());
const port = process.env.PORT || 5000;

app.get('/', async function(req, res) {
  res.end(`${await klay.getContactNmae()} healthy`);
});

app.get('/info', function(req, res) {
  /* Get Seller List Info from Smart Contract */
  res.end('todo');
});

app.get('/sell', function(req, res) {
  const amount = req.query.amount;
  const price = req.query.price;
  /* Call smartContract's registerSelling(uint256 _amount, uint256 _price) */
});

app.get('/buy', function(req, res) {
  const amount = req.query.seller;
  const price = req.query.amount;

  /* Call SmartContract's buyEV(uint256 _seq, uint256 _amount) */

  /* call gpio */
  /* Check each Electricity */
  /* for ( i < $credit) {
          sellerSent = Check Seller's Smart Meters
          buyerRecieve = Check Receiver's Smart Meters

          if ( sellerSent / precision != buyerRecieve / precision ) {
              Call SmartContract's Refund Function
          }
     }*/
});

app.use(logger('dev'));
app.listen(port, function() {
  console.log('server listening on port', port);
});

function cb(res) {
  res.send('complete your request.')
}