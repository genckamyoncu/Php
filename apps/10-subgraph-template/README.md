# Base Subgraph Template

Graph Protocol üzerinde Base ağı token transferlerini indekslemek için başlangıç projesi.

## Kurulum

```bash
npm install
npm run codegen
npm run build
```

`subgraph.yaml` içindeki `address` alanını kendi token adresiniz ile değiştirin. Deploy etmek için:

```bash
export SUBGRAPH_NAME=senin-username/base-token-transfers
npm run deploy
```
