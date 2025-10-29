# Foundry Role Gating

Topluluk üyelerini Base üzerinde doğrulamak için rol bazlı bir registry sözleşmesi.

## Kurulum

```bash
forge install foundry-rs/forge-std@v1.7.6
```

## Dağıtım

```bash
export PRIVATE_KEY=0x...
forge script script/Deploy.s.sol:DeployIdentityRegistry --rpc-url https://sepolia.base.org --broadcast
```

Dağıtımdan sonra `grantRole` ile yaratıcılara rol verebilir ve metadata güncelleyebilirsiniz.
