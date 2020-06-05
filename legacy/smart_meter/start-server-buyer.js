var ArtikCloud = require('artikcloud-js');
var unixTime = require('unix-time');
var Config = require('./config.json');
var Web3 = require('web3');
var util = require('ethereumjs-util');
var tx = require('ethereumjs-tx');
var lightwallet = require('eth-lightwallet');
var fs = require('fs');
var shell = require('shelljs');
var txutils = lightwallet.txutils;

var web3 = new Web3(
    new Web3.providers.HttpProvider('https://rinkeby.infura.io')
);
var address = '0xdC8a4165b90B7f802F8Ce5da394e26Db62e0b9ad';
var key = 'f6d353b1082c45e94f0ab730357e23e3d7987cd5d44b4457bb5cefbcfe4a01da';

var sell_string1 = "buying_amount";
var sell_string2 = "seller_number";
var sell_string3 = "}}]}";


const ADCPinNumber = 0;
const mVperAmp = 185;
const ACSoffset = 1650;

const GPIO_HIGH = 1;
const GPIO_LOW = 0;

const gpioPin = 128;

let total_mAh = 0;
let test_limit_mAh = 1;


setupRelep(gpioPin);

var bytecode = "60806040526000600a556000600b553480156200001b57600080fd5b50620f4240600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002081905550620f42406000819055506040805190810160405280600c81526020017f45566c6f636b20546f6b656e000000000000000000000000000000000000000081525060069080519060200190620000ba9291906200016c565b506000600760006101000a81548160ff021916908360ff1602179055506040805190810160405280600481526020017f455654540000000000000000000000000000000000000000000000000000000081525060089080519060200190620001249291906200016c565b5033600960006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055506200021b565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f10620001af57805160ff1916838001178555620001e0565b82800160010185558215620001e0579182015b82811115620001df578251825591602001919060010190620001c2565b5b509050620001ef9190620001f3565b5090565b6200021891905b8082111562000214576000816000905550600101620001fa565b5090565b90565b6118e7806200022b6000396000f300608060405260043610610112576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806306fdde031461011c578063095ea7b3146101ac57806318160ddd146102115780631b1caed61461023c5780631d6929901461028b57806323b872dd146102e257806327e235e314610367578063313ce567146103be5780635229299a146103ef5780635c65816514610434578063664e9704146104ab57806370a08231146104d65780638da5cb5b1461052d57806395d89b41146105845780639658f4bb14610614578063a9059cbb14610663578063aacdfe6f146106c8578063b442726314610735578063dd62ed3e1461073f578063e93ecfdf146107b6575b61011a61080d565b005b34801561012857600080fd5b50610131610951565b6040518080602001828103825283818151815260200191508051906020019080838360005b83811015610171578082015181840152602081019050610156565b50505050905090810190601f16801561019e5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b3480156101b857600080fd5b506101f7600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803590602001909291905050506109ef565b604051808215151515815260200191505060405180910390f35b34801561021d57600080fd5b50610226610ae1565b6040518082815260200191505060405180910390f35b34801561024857600080fd5b506102716004803603810190808035906020019092919080359060200190929190505050610ae7565b604051808215151515815260200191505060405180910390f35b34801561029757600080fd5b506102cc600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610c05565b6040518082815260200191505060405180910390f35b3480156102ee57600080fd5b5061034d600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610c1d565b604051808215151515815260200191505060405180910390f35b34801561037357600080fd5b506103a8600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610fd8565b6040518082815260200191505060405180910390f35b3480156103ca57600080fd5b506103d3610ff0565b604051808260ff1660ff16815260200191505060405180910390f35b3480156103fb57600080fd5b5061041a60048036038101908080359060200190929190505050611003565b604051808215151515815260200191505060405180910390f35b34801561044057600080fd5b50610495600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050611037565b6040518082815260200191505060405180910390f35b3480156104b757600080fd5b506104c061105c565b6040518082815260200191505060405180910390f35b3480156104e257600080fd5b50610517600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050611063565b6040518082815260200191505060405180910390f35b34801561053957600080fd5b506105426110ac565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b34801561059057600080fd5b506105996110d2565b6040518080602001828103825283818151815260200191508051906020019080838360005b838110156105d95780820151818401526020810190506105be565b50505050905090810190601f1680156106065780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561062057600080fd5b506106496004803603810190808035906020019092919080359060200190929190505050611170565b604051808215151515815260200191505060405180910390f35b34801561066f57600080fd5b506106ae600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050611587565b604051808215151515815260200191505060405180910390f35b3480156106d457600080fd5b506106f36004803603810190808035906020019092919050505061177c565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b61073d61080d565b005b34801561074b57600080fd5b506107a0600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506117af565b6040518082815260200191505060405180910390f35b3480156107c257600080fd5b506107f7600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050611836565b6040518082815260200191505060405180910390f35b6000803411151561081d57600080fd5b610833620f42403461184e90919063ffffffff16565b905061088781600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205461188690919063ffffffff16565b600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055506108df8160005461188690919063ffffffff16565b600081905550600960009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166108fc349081150290604051600060405180830381858888f1935050505015801561094d573d6000803e3d6000fd5b5050565b60068054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156109e75780601f106109bc576101008083540402835291602001916109e7565b820191906000526020600020905b8154815290600101906020018083116109ca57829003601f168201915b505050505081565b600081600260003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055508273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040518082815260200191505060405180910390a36001905092915050565b60005481565b60008082118015610af85750600083115b1515610b0357600080fd5b610b196001600a5461188690919063ffffffff16565b600a819055503360036000600a54815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555082600460003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000208190555081600560003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055506001905092915050565b60046020528060005260406000206000915090505481565b600080600260008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054905082600160008773ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410158015610cee5750828110155b8015610cfa5750600083115b1515610d0557600080fd5b610d5783600160008773ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205461188690919063ffffffff16565b600160008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002081905550610dec83600160008873ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020546118a290919063ffffffff16565b600160008773ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff811015610f6757610ee683600260008873ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020546118a290919063ffffffff16565b600260008773ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055505b8373ffffffffffffffffffffffffffffffffffffffff168573ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef856040518082815260200191505060405180910390a360019150509392505050565b60016020528060005260406000206000915090505481565b600760009054906101000a900460ff1681565b6000808211151561101357600080fd5b61102882600b5461188690919063ffffffff16565b600b8190555060019050919050565b6002602052816000526040600020602052806000526040600020600091509150505481565b620f424081565b6000600160008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050919050565b600960009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b60088054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156111685780601f1061113d57610100808354040283529160200191611168565b820191906000526020600020905b81548152906001019060200180831161114b57829003601f168201915b505050505081565b600080831180156111815750600082115b80156111ff575081600460006003600087815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410155b151561120a57600080fd5b61128f82600460006003600088815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020546118a290919063ffffffff16565b600460006003600087815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055506113cb82600560006003600088815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205402600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020546118a290919063ffffffff16565b600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000208190555061150782600560006003600088815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205402600160006003600088815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205461188690919063ffffffff16565b600160006003600087815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055506001905092915050565b600081600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054101580156115d85750600082115b15156115e357600080fd5b61163582600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020546118a290919063ffffffff16565b600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055506116ca82600160008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205461188690919063ffffffff16565b600160008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055508273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a36001905092915050565b60036020528060005260406000206000915054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6000600260008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054905092915050565b60056020528060005260406000206000915090505481565b6000808314156118615760009050611880565b818302905081838281151561187257fe5b0414151561187c57fe5b8090505b92915050565b6000818301905082811015151561189957fe5b80905092915050565b60008282111515156118b057fe5b8183039050929150505600a165627a7a72305820d3378a7ca927b310fbe56b3e9dc083c607e8de6ec08de3f9fd7152eba084c5ef0029"

var interface = [
	{
		"constant": true,
		"inputs": [],
		"name": "name",
		"outputs": [
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_spender",
				"type": "address"
			},
			{
				"name": "_value",
				"type": "uint256"
			}
		],
		"name": "approve",
		"outputs": [
			{
				"name": "success",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "totalSupply",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_amount",
				"type": "uint256"
			},
			{
				"name": "_price",
				"type": "uint256"
			}
		],
		"name": "registerSelling",
		"outputs": [
			{
				"name": "success",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "sellingAmount",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_from",
				"type": "address"
			},
			{
				"name": "_to",
				"type": "address"
			},
			{
				"name": "_value",
				"type": "uint256"
			}
		],
		"name": "transferFrom",
		"outputs": [
			{
				"name": "success",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "balances",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "decimals",
		"outputs": [
			{
				"name": "",
				"type": "uint8"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "donateEV",
		"outputs": [
			{
				"name": "success",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			},
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "allowed",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "RATE",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_owner",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"name": "balance",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "symbol",
		"outputs": [
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_seq",
				"type": "uint256"
			},
			{
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "buyEV",
		"outputs": [
			{
				"name": "success",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_to",
				"type": "address"
			},
			{
				"name": "_value",
				"type": "uint256"
			}
		],
		"name": "transfer",
		"outputs": [
			{
				"name": "success",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"name": "seller",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "createTokens",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_owner",
				"type": "address"
			},
			{
				"name": "_spender",
				"type": "address"
			}
		],
		"name": "allowance",
		"outputs": [
			{
				"name": "remaining",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "sellingPrice",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"payable": true,
		"stateMutability": "payable",
		"type": "fallback"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "_from",
				"type": "address"
			},
			{
				"indexed": true,
				"name": "_to",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "_value",
				"type": "uint256"
			}
		],
		"name": "Transfer",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"name": "_owner",
				"type": "address"
			},
			{
				"indexed": true,
				"name": "_spender",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "_value",
				"type": "uint256"
			}
		],
		"name": "Approval",
		"type": "event"
	}
];


var myContract = web3.eth.contract(interface);
var contractAddress = '0x5d03954f4770c6f291e68f3b83c2e215d63abab2';
var myContractInstance = myContract.at(contractAddress);

function sendRaw(rawTx) {
    var privateKey = new Buffer(key, 'hex');
    var transaction = new tx(rawTx);
    transaction.sign(privateKey);
    var serializedTx = transaction.serialize().toString('hex');
    web3.eth.sendRawTransaction(
    '0x' + serializedTx, function(err, result) {
        if(err) {
            console.log(err);
        } else {
            console.log(result);
        }
    });
}

var txOptions = {
    nonce: web3.toHex(web3.eth.getTransactionCount(address)),
    gasLimit: web3.toHex(800000),
    gasPrice: web3.toHex(20000000000),
    to: contractAddress
}

// Web3 examples
// var rawTx = txutils.functionTx(interface, 'ev_seq', [0], txOptions);
// sendRaw(rawTx);
// var result = myContractInstance.getTokenCount();
// console.log(result)



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
  } else {
    console.log('< API Response:');
    console.log(JSON.stringify(data, null, 2));
  }

}

// set the field:value to send to the device



var callback = function(error, data, response) {
  if (error) {
    console.error(error);
  } else {
    console.log('API called successfully. Returned data: ' + JSON.stringify(data));
   var user_data = JSON.stringify(data);
   var sell_idx1 = user_data.indexOf(sell_string1);
   var sell_idx2 = user_data.indexOf(sell_string2);
   var sell_idx3 = user_data.indexOf(sell_string3);
   var sell_amount = user_data.substring(sell_idx1+15,sell_idx2-2);
   var seller_num = user_data.substring(sell_idx2+15,sell_idx3);
   console.log(sell_amount);
   console.log(seller_num);
   var rawTx = txutils.functionTx(interface, 'buyEV', [seller_num, sell_amount], txOptions);
   sendRaw(rawTx);
   startTransferEV(sell_amount);
  }
};
api.getNormalizedActions(opts, callback);


// need only first time.
//setupRelep(gpioPin);

//startTransferEV(1);

function setupRelep(pin) {
    digitalPinMode(pin, 'out');
}

function startTransferEV(amount) {
    digitalWrite(gpioPin, GPIO_HIGH);

    while (true) {
        let aveAmps = averageAmps();
        if (aveAmps > 0.1) {
            total_mAh += aveAmps * 1000 * 5 / 3600;
        }
        console.log('total mAh : ' + total_mAh);

        if (total_mAh > amount) {
            digitalWrite(gpioPin, GPIO_LOW);
            return 
        }
    }
}

function averageAmps() {
    let Voltage, Amps = 0;
    for (let i = 0; i < 50; i++) {
        let RawValue = analogRead(ADCPinNumber);

        Voltage = RawValue * 0.439453125;
        Amps += ((Voltage - ACSoffset) / mVperAmp);
        sleep(100);
    }
    console.log('mV = ' + Voltage + '\t Amps : ' + Amps / 50);
    return Amps / 50;
}

function analogRead(pin) {
    return fs.readFileSync(
        '/sys/devices/platform/c0000000.soc/c0053000.adc/iio:device0/in_voltage'
        + pin + '_raw', 'utf8');
}

function digitalPinMode(pin, init_mode) {
    try {
        fs.writeFileSync('/sys/class/gpio/export', pin, 'utf-8');
    } catch(e) {
        console.log("Already Export gpio" + pin);
    }

    try {
        fs.writeFileSync('/sys/class/gpio/gpio' + pin + '/direction', init_mode, 'utf8');
    } catch(e) {
        console.log(e);
    }
}

function digitalWrite(pin, val) {
    try {
        fs.writeFileSync('/sys/class/gpio/gpio' + pin + '/value', val, 'utf8');
    } catch(e) {
        console.log('Error : can\'t open pin value');
    }
}

function sleep(milliseconds) {
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > milliseconds){
      break;
    }
  }
}
