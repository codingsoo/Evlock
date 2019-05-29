const fs = require('fs')
const EVlock = artifacts.require('./EVlock.sol')

module.exports = function (deployer) {
    deployer.deploy(EVlock)
        .then(() => {
            if (EVlock._json) {
                fs.writeFile('deployedABI', JSON.stringify(EVlock._json.abi),
                        (err) => {
                            if(err) throw err;
                            console.log("ABI 입력성공!");
                        }
                        )

                    fs.writeFile('deployedAddress', EVlock.address,
                            (err) => {
                                if (err) throw err;
                                console.log("파일에 주소 입력 성공!");
                            }
                            )
            }
        })
}
