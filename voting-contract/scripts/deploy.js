const hre = require("hardhat");

async function main() {
  const candidateNames = ["Candidate 1", "Candidate 2", "Candidate 3"];
  const votingDurationInMinutes = 60; // 1 hour

  const Voting = await hre.ethers.getContractFactory("Voting");
  const voting = await Voting.deploy(candidateNames, votingDurationInMinutes);

  await voting.deployed();

  console.log("Voting contract deployed to:", voting.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});