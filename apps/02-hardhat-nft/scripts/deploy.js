const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying BaseArt with account:", deployer.address);

  const BaseArt = await ethers.getContractFactory("BaseArt");
  const contract = await BaseArt.deploy();
  await contract.waitForDeployment();

  console.log("BaseArt deployed to:", await contract.getAddress());
  console.log("Mint komutunu çalıştırmak için örnek: hardhat console");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
