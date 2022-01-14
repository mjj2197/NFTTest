const { ethers, upgrades } = require("hardhat");

async function main() {
    const baseInstance = await ethers.getContractFactory("C8CNFT");
    const C8CContract = await baseInstance.deploy();
    console.log("C8CNFT Contract is deployed to:", C8CContract.address);
}

main();