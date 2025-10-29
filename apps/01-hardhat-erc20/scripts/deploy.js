const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying BaseToken with account:", deployer.address);

  const BaseToken = await ethers.getContractFactory("BaseToken");
  const initialSupply = ethers.parseUnits("1000000", 18);
  const token = await BaseToken.deploy(initialSupply);
  await token.waitForDeployment();

  console.log("BaseToken deployed to:", await token.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
