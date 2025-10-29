require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");

const { BASE_RPC_URL, PRIVATE_KEY } = process.env;

module.exports = {
  solidity: "0.8.23",
  networks: {
    base: {
      url: BASE_RPC_URL || "https://mainnet.base.org",
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
      chainId: 8453
    },
    "base-goerli": {
      url: process.env.BASE_GOERLI_RPC_URL || "https://goerli.base.org",
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
      chainId: 84531
    }
  },
  etherscan: {
    apiKey: process.env.BASESCAN_API_KEY || ""
  }
};
