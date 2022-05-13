const MyToken = artifacts.require("MyToken");

let instance;
contract("token details", function (accounts) {
  beforeEach(async function () {
    instance = await MyToken.deployed();
  });

  it("has a owner", async function () {
    const owner = await instance._owner();
    assert.equal(owner, accounts[0]);
  });

  it("deploys the contract", async function () {
    const name = await instance.name();
    assert.equal(name, "My Token");
  });
  it("has the MTN as token symbol", async function () {
    const name = await instance.symbol();
    assert.equal(name, "MTN");
  });

  it("has 18 decimals", async function () {
    const decimals = await instance.decimals();
    assert.equal(decimals, 18);
  });

  it("has 1000000000000000000000 as total supply", async function () {
    const totalSupply = await instance.totalSupply();
    assert.equal(totalSupply.toString(), "1000000000000000000000");
  });

  it("has a fixed rate", async function () {
    const rate = await instance.tokenRateInWei();
    assert.equal(rate.toString(), "1000000000000000000");
  });
});

contract("application functionality", function (accounts) {
  it("has minted totalSupply tokens", async function () {
    const totalSupply = await instance.totalSupply();
    const balance = await instance.balanceOf(accounts[0]);
    assert.equal(totalSupply.toString(), balance.toString());
  });

  it("mints the new tokens and updates the totalSupply", async function () {
    await instance.mint("2000000000000000000", { from: accounts[0] });
    const totalSupply = await instance.totalSupply();
    const balance = await instance.balanceOf(accounts[0]);
    assert.equal(totalSupply.toString(), balance.toString());
  });

  it("approves the tokens for the supply", async function () {
    await instance.approve(accounts[1], "1000000000000000000", {
      from: accounts[0],
    });
    const allowance = await instance.allowance(accounts[0], accounts[1]);
    assert.equal(allowance.toString(), "1000000000000000000");
  });

  it("transfers the tokens", async function () {
    await instance.approve(accounts[1], "1000000000000000000", {
      from: accounts[0],
    });

    await instance.transfer(accounts[1], "1000000000000000000", {
      from: accounts[0],
    });

    const balance = await instance.balanceOf(accounts[1]);
    assert.equal(balance.toString(), "1000000000000000000");
  });

  it("lets user buy tokens", async function () {
    const balanceBefore = await instance.balanceOf(accounts[1]);

    await instance.buyToken("1", {
      from: accounts[1],
      value: web3.utils.toWei("1", "ether"),
    });

    const balanceAfter = await instance.balanceOf(accounts[1]);
  });
});
