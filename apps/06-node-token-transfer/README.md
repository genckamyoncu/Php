# Node.js Token Transfer

Base ağında ERC-20 token transferi göndermek için `ethers.js` kullanan basit bir komut satırı aracı.

## Kurulum

```bash
npm install
```

`.env` oluşturun:

```
PRIVATE_KEY=0x...
BASE_RPC_URL=https://sepolia.base.org
TO_ADDRESS=0x...
TOKEN_ADDRESS=0x...
AMOUNT=10
DECIMALS=18
```

Çalıştırmak için:

```bash
npm run send
```
