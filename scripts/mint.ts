import { ethers } from "hardhat";

async function main() {
    const [owner] = await ethers.getSigners();

    console.log("Deploying Contract at", owner.address);

    const token = await ethers.deployContract("Lmao");

    await token.waitForDeployment();

    console.log("Contract Deployed at:", token.target);
};


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  