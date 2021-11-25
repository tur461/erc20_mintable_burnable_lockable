const ERC20_MBL = artifacts.require("ERC20_MBL");
const ERC20_TimeLocker = artifacts.require("ERC20_TimeLocker");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(ERC20_MBL, 'Thoritos', 'THOR', '100000');
  const token = await ERC20_MBL.deployed();
  const tAddress = token.address; // '0x886774B2F2545013419aB384514D15171A9dcA68';
  const benficiary = '0xF19250A3320bE69B80daf65D057aE05Bb12F0919';
  const duration = 24 * 60 * 60; // 24 hrs
  await deployer.deploy(ERC20_TimeLocker, tAddress, benficiary, duration);
  const timeLocker = await ERC20_TimeLocker.deployed();
  
  console.log('Deployes Time Locker Address: ' + timeLocker.address);
  console.log('now transfering tokens');
  token.transfer(timeLocker.address, await token.totalSupply())
};