# Hardhat ERC-20 Token

Basit bir ERC-20 tokeni derlemek ve Base ana/a test ağında dağıtmak için Hardhat projesi. `@openzeppelin/contracts` kullanır.

## Kurulum

```bash
npm install
```

`.env` dosyası oluşturun:

```
PRIVATE_KEY=0x...
BASE_RPC_URL=https://mainnet.base.org
BASE_GOERLI_RPC_URL=https://goerli.base.org
BASESCAN_API_KEY=... # Opsiyonel
```

## Komutlar

Tokeni derlemek:

```bash
npm run build
```

Base Goerli test ağında dağıtmak:

```bash
npx hardhat run scripts/deploy.js --network base-goerli
```

Ana ağa dağıtmak için `--network base` kullanın.
