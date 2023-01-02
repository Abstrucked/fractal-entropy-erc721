// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const COL = await hre.ethers.getContractFactory("ColorConverter");
  const col = await COL.deploy();
  await col.deployed();
  const libColoreAddr = col.address;
  const PAL = await hre.ethers.getContractFactory("Palette");
  const palette = await PAL.deploy();
  await palette.deployed();
  const libPaletteAddr = palette.address;
  const AEF = await hre.ethers.getContractFactory("FractalEntropy");
  const aef = await AEF.deploy();

  await aef.deployed();

  console.log("EntropicFractals deployed to:", aef.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
