import { ethers } from "hardhat";

async function main() {
    const [owner] = await ethers.getSigners();

    console.log("Deploying Contract at", owner.address);

    const token = await ethers.deployContract("Lmao", ["0x3D7a4E450B324E656E0F79fC4aFb5FEd72Bb5f68"]);

    await token.waitForDeployment();

    console.log("Contract Deployed at:", token.target);
};


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  