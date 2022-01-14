const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BigNumber } = require('ethers');
const minters = require('../minters.json');
const {
	expectRevert
} = require('@openzeppelin/test-helpers');

let NFTContract;
let owner;
let addrs;
let startTime = 1642093000;
let endTime = 1643000000;

const URI_BASE = 'https://ipfs.io/ipfs/';

beforeEach(async function () {
	[owner, ...addrs] = await ethers.getSigners();
	NFTContract = await ethers.getContractFactory("NFT");
	NFTContract = await NFTContract.deploy(URI_BASE, minters, startTime, endTime);
  await NFTContract.deployed();
});


describe("Mint Function", function () {
  it("should mint from address in list", async function () {
    const transaction = await NFTContract.mintNFT();
    const tx = await transaction.wait()
    const event = tx.events[0];
    const value = event.args[2];
    const tokenId = value.toNumber();
    const tokenOwner = await NFTContract.ownerOf(tokenId)
  
    expect(tokenOwner).to.be.equal(owner.address);
  });

  it("should return error if mint from address not in list", async function () {
    await expectRevert(
      NFTContract.connect(addrs[18]).mintNFT(),
      "not allowed to mint"
    )
  });

  it("should return error if mint multiple times from same address", async function () {
    await NFTContract.connect(addrs[0]).mintNFT();
    await expectRevert(
      NFTContract.connect(addrs[0]).mintNFT(),
      "not allowed to mint"
    )
  });

  it("should mint multiple times from different addresses", async function () {
    // mint from address 1
    const transaction1 = await NFTContract.connect(addrs[0]).mintNFT();
    const tx1 = await transaction1.wait()
    const event1 = tx1.events[0];
    const value1 = event1.args[2];
    const tokenId1 = value1.toNumber();
    const tokenOwner1 = await NFTContract.ownerOf(tokenId1)
  
    expect(tokenOwner1).to.be.equal(addrs[0].address);

    // mint from address 2
    const transaction2 = await NFTContract.connect(addrs[1]).mintNFT();
    const tx2 = await transaction2.wait()
    const event2 = tx2.events[0];
    const value2 = event2.args[2];
    const tokenId2 = value2.toNumber();
    const tokenOwner2 = await NFTContract.ownerOf(tokenId2)
  
    expect(tokenOwner2).to.be.equal(addrs[1].address);
  });

  it("should return error if mint before start/end time", async function () {
    await NFTContract.setStartTime(1742093000);
    await NFTContract.setEndTime(1842093000);
    await expectRevert(
      NFTContract.connect(addrs[0]).mintNFT(),
      "!block"
    )
  });

  it("should return error if mint after start/end time", async function () {
    await NFTContract.setStartTime(1442093000);
    await NFTContract.setEndTime(1542093000);
    await expectRevert(
      NFTContract.connect(addrs[0]).mintNFT(),
      "!block"
    )
  });

  it("should transfer NFT ownership", async function () {
    const transaction = await NFTContract.connect(addrs[0]).mintNFT();
    const tx = await transaction.wait()
    const event = tx.events[0];
    const value = event.args[2];
    const tokenId = value.toNumber();
    await NFTContract.connect(addrs[0]).transferNFT(addrs[1].address, tokenId);
    const newOwner = await NFTContract.ownerOf(tokenId);
    expect(newOwner).to.be.equal(addrs[1].address);
  });
});

