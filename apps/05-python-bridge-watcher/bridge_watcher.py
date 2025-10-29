import asyncio
import os
from datetime import datetime, timezone

from dotenv import load_dotenv
from rich.console import Console
from web3 import AsyncHTTPProvider, AsyncWeb3
from web3.middleware import async_geth_poa_middleware

load_dotenv()

RPC_URL = os.getenv("BASE_RPC_URL", "https://mainnet.base.org")
START_BLOCK = os.getenv("START_BLOCK")
BRIDGE_ADDRESS = os.getenv("BRIDGE_ADDRESS", "0x3154Cf16CCdb4C6d922629664174b904d80F2C35")
EVENT_TOPIC = "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"  # Transfer

console = Console()


def human_time(ts: int) -> str:
    return datetime.fromtimestamp(ts, tz=timezone.utc).isoformat()


async def watch_bridge():
    w3 = AsyncWeb3(AsyncHTTPProvider(RPC_URL))
    w3.middleware_onion.inject(async_geth_poa_middleware, layer=0)

    latest = await w3.eth.block_number
    if START_BLOCK is not None:
        from_block = int(START_BLOCK)
    else:
        from_block = latest - 5000 if latest > 5000 else 0
    console.log(f"Starting bridge watch from block {from_block} on {RPC_URL}")

    while True:
        to_block = await w3.eth.block_number
        logs = await w3.eth.get_logs(
            {
                "fromBlock": from_block,
                "toBlock": to_block,
                "address": BRIDGE_ADDRESS,
                "topics": [EVENT_TOPIC],
            }
        )
        for entry in logs:
            block = await w3.eth.get_block(entry["blockNumber"])
            console.log(
                {
                    "block": entry["blockNumber"],
                    "tx": entry["transactionHash"].hex(),
                    "timestamp": human_time(block["timestamp"]),
                    "data": entry["data"],
                }
            )
        from_block = to_block + 1
        await asyncio.sleep(10)


if __name__ == "__main__":
    try:
        asyncio.run(watch_bridge())
    except KeyboardInterrupt:
        console.log("Stopped bridge watcher")
