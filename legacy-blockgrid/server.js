'use strict';

const dotenv = require('dotenv'),
  ArtikCloud = require('artikcloud-js'),
  unixTime = require('unix-time'),
  sendTx = require('./sendTx');

const artikClient = ArtikCloud.ApiClient.instance,
  artikcloud_oauth = artikClient.authentications['artikcloud_oauth'],
  api = new ArtikCloud.MessagesApi();

dotenv.config();
artikcloud_oauth.accessToken = process.env.ARTIK_CLOUD_ACCESS_TOKEN;

const startTime = unixTime(new Date()) * 1000;
let last_cts = 0;

const cb = (error, data, response) => {
  if (error) {
    console.error(error);
  } else if (typeof data.data[0] !== 'undefined'
             && data.data[0].cts !== last_cts) {
    let action = data.data[0].data.actions[0];
    last_cts = data.data[0].cts;

    console.log('Request: ' + JSON.stringify(action));

    sendTx(action.name, action.parameters);
  }
}

function interval() {
  const opts = {
    'count': 1,
    'startDate': startTime,
    'endDate': unixTime(new Date())*1000,
    'order': "desc"
  };

  api.getNormalizedActions(opts, cb);
}

console.log('...running server');
console.log('...listening on artik cloud device: Smart Meter');
console.log('...device type id : ' + process.env.ARTIK_CLOUD_DEVICE_TYPE_ID);

setInterval(interval, 2000);

