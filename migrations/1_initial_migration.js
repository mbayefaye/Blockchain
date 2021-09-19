const Migrations = artifacts.require("Airlines");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
