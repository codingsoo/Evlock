var http = require('http');
var fs = require('fs');
var url = require('url');
var qs = require('querystring');
var Caver = require("caver-js");

//http://175.192.140.18/sell?id=1&2

const config = {
  rpcURL: 'https://api.baobab.klaytn.net:8651'
}

var EV_abi = fs.readFileSync('./deployedABI', 'utf8');
var EV_address = fs.readFileSync('./deployedAddress', 'utf8');

const cav = new Caver(config.rpcURL);

var myContract = new cav.klay.Contract(JSON.parse(EV_abi),EV_address);			

console.log("Now Sever is running...");

var app = http.createServer(function(request,response){
    var _url = request.url;
    var queryData = url.parse(_url, true).query;
    var pathname = url.parse(_url, true).pathname;
    
    if(pathname == '/info'){ // GET info
        /* Call SmartContract's Data and write JSON */
        var sellerList = {
            info: []
		};

     /* Get Seller List Info from Smart Contract */
     /*
          for ($SellerListNumber) {
            sellerList.info.push({"id": "0x12345","price": "10","Amount": "2000","Credit": "8"} );
        } */

        /* response.writeHead(200); */
        /* response.end(sellerList); */

	} else if(pathname == '/sell'){ // GET by query
		/* Query URL Example) http://175.192.140.18/sell?id=$(SellAmount)&$(SellPrice) */
		var urlData = queryData.id.split('&');
		var sellAmount = urlData[0];
		var price = urlData[1];

        /* Call smartContract's registerSelling(uint256 _amount, uint256 _price) */
    
        response.writeHead(200);

    } else if(pathname == '/buy'){ // GET by query
		/* http://175.192.140.18/buy?id=$(SellIdx)&$(BuyAmount) */

		var urlData = queryData.id.split('&');
		var sellIdx = urlData[0];
		var buyAmount = urlData[1];

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
        response.writeHead(200);

    } else {
        response.writeHead(404);
        response.end('Not found');
    }
});
app.listen(80);
