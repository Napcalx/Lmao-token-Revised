import { ethers } from "hardhat";

async function main() {
    const lmaoAddy = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
    const lmaoWrapAddy = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512"
 
    const wLmao = await ethers.getContractAt("lmaoWrapper", lmaoWrapAddy);
    const lmao = await ethers.getContractAt("Lmao", lmaoAddy);

    const signer = await ethers.getImpersonatedSigner("0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f");

    const approveAmt = ethers.parseEther("100000000");
    const depositAmt = ethers.parseEther("10");
    const withdrawAmt = ethers.parseEther("10");

    console.log("Approving tokens ");
    await lmao.connect(signer).approve(wLmao, approveAmt);

    console.log(`allowance is ${await lmao.allowance(signer, wLmao)} `);
    console.log("token approved");

    console.log(`Signers lmao balance before wrapping: ${await lmao.balanceOf(signer)}`);
    console.log(`Signers wLmao balance before wrapping: ${await wLmao.balanceOf(signer)}`);
    console.log("Token being deposited");

    await wLmao.connect(signer).wrap(signer.address, depositAmt);
    
    console.log(`Signers lmao after wrapping: ${await lmao.balanceOf(signer)}`);
    console.log(`Signers wLmao after wrapping: ${await wLmao.balanceOf(signer)}`);
    console.log("Token has been Deposited");

    console.log(`lmao balance before Unwrapping: ${await lmao.balanceOf(signer)}`);
    console.log(`wLmao balance before Unwrapping : ${await wLmao.balanceOf(signer)}`);
    console.log("Wrapped");

    const Wrap = await wLmao.balanceOf(signer);
    await wLmao.connect(signer).unwrap(signer.address, withdrawAmt);

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

