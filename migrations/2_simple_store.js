// 2_simple_storage.js
const fs = require('fs')
const path = require('path')

var SimpleStore = artifacts.require("./SimpleStore.sol");

const unityAddresses = path.resolve(__dirname, '../../unityclient/Assets/Resources/contracts/address')

module.exports = function(deployer) {
  deployer.deploy(SimpleStore).then(() => {
    // Write the abi to a new file in the unityAbis directory
    fs.writeFileSync(path.resolve(unityAddresses, "SimpleStore.address"), SimpleStore.address)
  });
  
};
