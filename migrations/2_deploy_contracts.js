var HelloBlockchain = artifacts.require("Airlines");
var Arg = 4;
module.exports = (deployer) => {
  deployer.deploy(HelloBlockchain);
};
