import { ethers } from "hardhat";

async function main() {
    const lmaoAddy = "";
    const lmaoWrapAddy = ""

    const wLmao = await ethers.getContractAt("lmaoWrapper", lmaoWrapAddy);
    const lmao = await ethers.getContractAt("Lmao", lmaoAddy);

    const signer = await ethers.getImpersonatedSigner("");

    const approveAmt = ethers.parseEther("1000000");
    const depositAmt = ethers.parseEther("1");

    console.log("Approving tokens ");
    await lmao.connect(signer).approve(wLmao, approveAmt);

    console.log(`allowance is ${await lmao.allowance(signer, wLmao)} `);
    console.log("token approved");

    console.log(`Signers lmao balance before wrapping: ${await lmao.balanceOf(signer)}`);
    console.log(`Signers wLmao balance before wrapping: ${await wLmao.balanceOf(signer)}`);
    console.log("Token being deposited");

    await wLmao.connect(signer).wraplmao(depositAmt);
    
    console.log(`Signers lmao balance after wrapping: ${await lmao.balanceOf(signer)}`);
    console.log(`Signers wLmao balance after wrapping: ${await wLmao.balanceOf(signer)}`);
    console.log("Token has been Deposited");

    console.log(`lmao balance before Unwrapping: ${await lmao.balanceOf(signer)}`);
    console.log(`wLmao balance before Unwrapping : ${await wLmao.balanceOf(signer)}`);
    console.log("Wrapped");

    const Wrap = await wLmao.balanceOf(signer);
    await wLmao.connect(signer).unwraplmao(Wrap);

    console.log(`Signer balance after UnWrapping: ${await lmao.balanceOf(signer)}`);
    console.log(`Signers balance after Unwrapping: ${await wLmao.balanceOf(signer)}`);

    console.log("Unwrapped");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });

