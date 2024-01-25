require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
require("hardhat-gas-reporter");


const account = process.env.KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.12",
  settings: {
    optimizer: {
      enabled: true,
      runs: 90
    },
    gasReporter: {
      currency: 'USD',
      coinmarketcap: process.env.COINMARKETCAP_APIKEY,
      token: 'ETH',
      gasPriceApi: 'https://api.etherscan.io/api?module=proxy&action=eth_gasPrice',
      enabled: (process.env.REPORT_GAS) ? true : false
    },
    accounts: [account, process.env.USER]
  },
  networks: {
    goerli: {
      id: 5,
      url: process.env.GOERLI,
      
    }
  }
};

if (process.env.ETHERSCAN_APIKEY) {
  module.exports.etherscan = {
    apiKey: process.env.ETHERSCAN_APIKEY,
  }
}