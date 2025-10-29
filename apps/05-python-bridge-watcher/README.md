# Python Base Bridge Watcher

Base ana ağı köprü sözleşmesindeki Transfer olaylarını takip eden asenkron Python betiği.

## Kurulum

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

`.env` dosyası oluşturun:

```
BASE_RPC_URL=https://mainnet.base.org
BRIDGE_ADDRESS=0x3154Cf16CCdb4C6d922629664174b904d80F2C35
START_BLOCK=0  # opsiyonel
```

```bash
python bridge_watcher.py
```
