# Foundry Streaming Payments

Bu Foundry projesi, Base üzerinde anlık ödeme akışları oluşturmanızı sağlar. Kullanıcılar belirli süre ve saniye başına ücret belirleyerek fonlarını kilitler.

## Kurulum

```bash
forge install foundry-rs/forge-std@v1.7.6
```

## Dağıtım

```bash
export PRIVATE_KEY=0x...
forge script script/Deploy.s.sol:DeployStreamingPayments --rpc-url https://sepolia.base.org --broadcast
```

`forge test` komutu ile birim testleri ekleyip çalıştırabilirsiniz.
