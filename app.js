'use strict';

const express = require('express'),
  asyncify = require('express-asyncify'),
  logger = require('morgan'),
  klay = require("./lib/klay");

const app = asyncify(express());
const port = process.env.PORT || 5000;

app.get('/', async function(req, res) {
  res.end(`${await klay.getContactNmae()} is healthy`);
});

app.get('/create_token/:value', async function(req, res) {
  await klay.sellEV(req.params.value);
  res.send('complete your request.')
});

app.get('/balance/:address', async function(req, res) {
  res.end(`${req.params.address} balance: ${await klay.checkBalance(req.params.address)} EVTT`);
});

app.get('/sell/:amount/price/:price', async function(req, res) {
  await klay.sellEV(req.params.amount, req.params.price);
  res.send('complete your request.')
});

app.get('/buy/:seller/amount/:amount', async function(req, res) {
  await klay.buyEV(req.params.seller, req.params.amount);
  res.send('complete your request.')
});

app.use(logger('dev'));
app.listen(port, function() {
  console.log('server listening on port', port);
});
