// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {

  const ACDMToken = await ethers.getContractFactory("ACDMToken");
  const acdmToken = await ACDMToken.deploy();
  await acdmToken.deployed();

  const POPToken = await ethers.getContractFactory("POPToken");
  const popToken = await POPToken.deploy();
  await popToken.deployed();

  const TSTToken = await ethers.getContractFactory("TSTToken");
  const tstToken = await TSTToken.deploy();
  await tstToken.deployed();

  const UniswapAdapter = await ethers.getContractFactory("UniswapAdapter");
  const uniswapAdapter = await UniswapAdapter.deploy(acdmToken.address, popToken.address, tstToken.address);
  await uniswapAdapter.deployed();

  console.log("ACDMToken deployed to:", acdmToken.address);
  console.log("POPToken deployed to:", popToken.address);
  console.log("TSTToken deployed to:", tstToken.address);
  console.log("UniswapAdapter deployed to:", uniswapAdapter.address);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
