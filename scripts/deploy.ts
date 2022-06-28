// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  // const rewardToken = await ethers.getContractFactory("RewardToken");
  // const token = await rewardToken.deploy("Imme", "IMMES");
  // await token.deployed();
  // console.log("token deployed to:", token.address);

  // const stakingToken = await ethers.getContractFactory("StakingToken");
  // const busd = await stakingToken.deploy("Busd", "BUSD");
  // await busd.deployed();
  // console.log("busd deployed to:", busd.address);


  //0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
  //pancake 0x10ED43C718714eb63d5aA57B78B54704E256024E
  const Staking = await ethers.getContractFactory("ImmeStaking");
  const staking = await Staking.deploy(
    "0x9ad38251cD6B157B32C4D913b03165781bd2d019",
    "0xAD3E28dA2B1480cdB2D79C70764458AaBa1c57F3");

  await staking.deployed();

  console.log("Staking deployed to:", staking.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
