const Migrations = artifacts.require("MyToken");
const SafeMath = artifacts.require("SafeMath");
module.exports = function (deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, Migrations);
  deployer.deploy(
    Migrations,
    "My Token",
    "MTN",
    "18",
    "1000000000000000000000",
    "1000000000000000000"
  );
};
