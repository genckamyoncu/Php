use color_eyre::eyre::Result;
use ethers::providers::{Http, Middleware, Provider};
use serde::Serialize;
use std::{env, time::Instant};

#[derive(Serialize)]
struct HealthReport {
    rpc_url: String,
    latest_block: u64,
    latency_ms: u128,
    chain_id: u64,
}

#[tokio::main]
async fn main() -> Result<()> {
    color_eyre::install()?;

    let rpc_url = env::var("BASE_RPC_URL").unwrap_or_else(|_| "https://mainnet.base.org".to_string());
    let provider = Provider::<Http>::try_from(rpc_url.clone())?;

    let start = Instant::now();
    let latest_block = provider.get_block_number().await?.as_u64();
    let latency_ms = start.elapsed().as_millis();
    let chain_id = provider.get_chainid().await?.as_u64();

    let report = HealthReport {
        rpc_url,
        latest_block,
        latency_ms,
        chain_id,
    };

    println!("{}", serde_json::to_string_pretty(&report)?);

    Ok(())
}
