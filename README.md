# PHP Utilities

## Ethereum Gas Fee Script

`ethereum_gas_fee.php` uses the [Etherscan Gas Oracle](https://etherscan.io/apis#gastracker) to fetch the latest gas price recommendations and prints a summary to the console.

### Requirements
- PHP 8.0 or newer
- An Etherscan API key available via the `ETHERSCAN_API_KEY` environment variable

### Usage
```bash
export ETHERSCAN_API_KEY="your_api_key"
php ethereum_gas_fee.php            # Uses the default gas limit of 21,000
php ethereum_gas_fee.php 50000      # Estimate cost for a custom gas limit
```
