import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    eth: {
      url: process.env.URL,
      // @ts-ignore
      accounts: [process.env.ACCOUNTS],
    },
  },

  etherscan: {
    // Your API Key from Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: process.env.APIKEY, 
  },
};

export default config;
