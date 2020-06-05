var ArtikCloud = require('artikcloud-js');
var unixTime = require('unix-time');
var Config = require('./config.json');

// configure client to set the oauth2 access_token or use the device_token here
var defaultClient = ArtikCloud.ApiClient.instance;

var artikcloud_oauth = defaultClient.authentications['artikcloud_oauth'];
artikcloud_oauth.accessToken = "722ea9f552a344b89c5ee2fb31eef4f8"

var api = new ArtikCloud.MessagesApi()
var endtime = unixTime(new Date())*1000;
var opts = {
  //'uid': "28b209d1f01a458ebac81b9080acff7a",
  'count': 1, // {Number} count
  'startDate': 1527973962150, // {Number} startDate
  'endDate': endtime, // {Number} endDate
  'order': "desc" // {String} Desired sort order: 'asc' or 'desc'
};

var flag = 0;

// configure client to set the oauth2 access_token or use the device_token here
var defaultClient = ArtikCloud.ApiClient.instance;

// configure with oauth2 access_token or use the device_token
var artikcloud_oauth = defaultClient.authentications['artikcloud_oauth'];
artikcloud_oauth.accessToken = Config['device_token']


// get reference to Messages API
var api = new ArtikCloud.MessagesApi();


var callback = function(error, data, response) {

  if (error) {
    console.error(error);
    console.log("error occured");
  } else {
    console.log('< API Response:');
    console.log(JSON.stringify(data, null, 2));
  }

}
api.getNormalizedActions(opts, callback);
