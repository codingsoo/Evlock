const fs = require('fs'),
  EVlock = artifacts.require('./EVlock.sol');

module.exports = function (deployer) {
  deployer.deploy(EVlock)
    .then(() => {
      if (EVlock._json) {
        fs.appendFile('.env', 'CONTRACT_ADDRESS=' + EVlock.address, (err) => {
          if (err) throw err;
        });
      }
    })
};
