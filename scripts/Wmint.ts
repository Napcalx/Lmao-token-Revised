import { ethers } from "hardhat";

async function main() {
   const lmaoAddy = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

    const lmaoWrap = await ethers.deployContract("lmaoWrapper", [lmaoAddy]);

    await lmaoWrap.waitForDeployment();

    console.log("Contract deployed at:", lmaoWrap.target);
};


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  