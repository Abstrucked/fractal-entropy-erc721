require("@nomiclabs/hardhat-waffle");
require("dotenv").config();


const account = process.env.KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.12",
  settings: {
    optimizer: {
      enabled: true,
      runs: 90
    }
  },
  networks: {
    goerli: {
      id: 5,
      url: process.env.GOERLI,
      accounts: [account]
    }
  }
};
