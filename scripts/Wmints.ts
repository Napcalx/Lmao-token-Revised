import { ethers } from "hardhat";

async function main() {
   const lmaoAddy = "";

    const lmaoWrap = await ethers.deployContract("Lmao", [lmaoAddy]);

    await lmaoWrap.waitForDeployment();

    console.log("Contract deployed at:", lmaoWrap.target);
};


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  