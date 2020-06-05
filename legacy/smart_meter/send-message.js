// This is a modified code snip from the SDK sample:
// https://github.com/artikcloud/artikcloud-js/blob/master/docs/MessagesApi.md#sendMessage

// import the ARTIKCloud library
var ArtikCloud = require('artikcloud-js');

// configuration file to simplify retrieving the device ID and device token
var Config = require('./config.json');

// configure client by setting credentials.   
// here we set the `accessToken` to value of `device_token`.
var client = ArtikCloud.ApiClient.instance;
var artikcloud_oauth = client.authentications['artikcloud_oauth'];
artikcloud_oauth.accessToken = Config['device_token'] 


// get a reference to the Messages API
var api = new ArtikCloud.MessagesApi();

// `message` will set the request body when making an api call
var message = new ArtikCloud.Message();


/**
* Simple function to retrieve a value between min and max
* fixed to 1 precision floating point (ie:  27.5)
* 
* @param min - min value
* @param max - max value
* 
* @return value between min and max
*/

var getRandomBetween = function (min, max) {

	var random = Math.random() * (max - min) + min;
	
	return random.toFixed(1);

}

/**
* Callback function after making API call
* 
* @param error - error object
* @param data - response data from server
* @param response - header response data
* 
* Example Response:
* 
* { "data": { "mid": "a9b4982c708540cd9742adddef902c15"  }}
* 
*/

var callback = function(error, data, response) {

  if (error) {
    console.error(error);
  } else {
    console.log('< API Response:');
    console.log(JSON.stringify(data, null, 2));
  }

}

// set the field:value to send to the device  
var sensor = {
	"seller1_amount": 998,
	"seller1_price": 1
};


message['data'] = sensor;
message['sdid'] = Config['device_id'];

console.log("> Making API call with data: " + JSON.stringify(message));
//make api call
api.sendMessage(message, callback);



