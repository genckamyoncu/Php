import 'dotenv/config';
import { JsonRpcProvider, Wallet, Contract, parseUnits } from 'ethers';

const RPC_URL = process.env.BASE_RPC_URL || 'https://sepolia.base.org';
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const TO_ADDRESS = process.env.TO_ADDRESS;
const TOKEN_ADDRESS = process.env.TOKEN_ADDRESS;
const AMOUNT = process.env.AMOUNT || '1';
const DECIMALS = parseInt(process.env.DECIMALS || '18', 10);

if (!PRIVATE_KEY || !TO_ADDRESS || !TOKEN_ADDRESS) {
  throw new Error('PRIVATE_KEY, TO_ADDRESS ve TOKEN_ADDRESS zorunludur');
}

const erc20Abi = [
  'function balanceOf(address) view returns (uint256)',
  'function transfer(address to, uint256 amount) returns (bool)'
];

async function main() {
  const provider = new JsonRpcProvider(RPC_URL);
  const wallet = new Wallet(PRIVATE_KEY, provider);
  const token = new Contract(TOKEN_ADDRESS, erc20Abi, wallet);

  const balanceBefore = await token.balanceOf(wallet.address);
  console.log('Gönderen bakiye (önce):', balanceBefore.toString());

  const tx = await token.transfer(TO_ADDRESS, parseUnits(AMOUNT, DECIMALS));
  console.log('İşlem gönderildi:', tx.hash);
  await tx.wait();

  const balanceAfter = await token.balanceOf(wallet.address);
  console.log('Gönderen bakiye (sonra):', balanceAfter.toString());
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
