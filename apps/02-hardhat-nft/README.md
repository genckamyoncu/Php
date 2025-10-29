# Hardhat ERC-721 NFT Koleksiyonu

Base ağına özel küçük bir NFT koleksiyonu. Metadata URI'lerini doğrudan mint sırasında ayarlayabilirsiniz.

## Kurulum

```bash
npm install
```

`.env` içeriği `01-hardhat-erc20` projesi ile aynıdır.

## Kullanım

```bash
npm run build
npx hardhat run scripts/deploy.js --network base-sepolia
```

Dağıtım sonrası Hardhat konsolu veya scriptler ile `mintTo` fonksiyonunu çağırabilirsiniz.
