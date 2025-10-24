<?php
/**
 * Ethereum Gas Fee Viewer
 *
 * Fetches the latest gas price recommendations from the Etherscan Gas Oracle
 * and prints them to the console. Optionally, you can provide a gas limit as
 * the first CLI argument to estimate the total cost of a transaction.
 */

const DEFAULT_GAS_LIMIT = 21000; // Typical gas limit for a simple ETH transfer.

$apiKey = getenv('ETHERSCAN_API_KEY');
if ($apiKey === false || $apiKey === '') {
    fwrite(STDERR, "ETHERSCAN_API_KEY environment variable is not set.\n");
    fwrite(STDERR, "Sign up for an API key at https://etherscan.io/apis and set the variable before running this script.\n");
    exit(1);
}

$gasLimit = DEFAULT_GAS_LIMIT;
if ($argc > 1) {
    if (!ctype_digit($argv[1])) {
        fwrite(STDERR, "The gas limit must be a positive integer.\n");
        exit(1);
    }
    $gasLimit = (int) $argv[1];
    if ($gasLimit <= 0) {
        fwrite(STDERR, "The gas limit must be greater than zero.\n");
        exit(1);
    }
}

$url = sprintf(
    'https://api.etherscan.io/api?module=gastracker&action=gasoracle&apikey=%s',
    urlencode($apiKey)
);

$response = @file_get_contents($url);
if ($response === false) {
    $error = error_get_last();
    $message = $error !== null ? $error['message'] : 'Unknown error';
    fwrite(STDERR, "Failed to fetch gas data: {$message}\n");
    exit(1);
}

$data = json_decode($response, true);
if ($data === null) {
    fwrite(STDERR, "Failed to decode JSON response.\n");
    exit(1);
}

if (!isset($data['status']) || $data['status'] !== '1') {
    $errorMessage = $data['message'] ?? 'Unknown error from API';
    fwrite(STDERR, "Etherscan API error: {$errorMessage}\n");
    exit(1);
}

$result = $data['result'] ?? [];

$gasPrices = [
    'Safe Gas Price' => $result['SafeGasPrice'] ?? null,
    'Proposed Gas Price' => $result['ProposeGasPrice'] ?? null,
    'Fast Gas Price' => $result['FastGasPrice'] ?? null,
    'Base Fee' => $result['suggestBaseFee'] ?? null,
];

foreach ($gasPrices as $label => $price) {
    if ($price === null) {
        fwrite(STDERR, "Missing {$label} in API response.\n");
        exit(1);
    }
}

$gasUsedSafe = calculateEthCost($gasPrices['Safe Gas Price'], $gasLimit);
$gasUsedProposed = calculateEthCost($gasPrices['Proposed Gas Price'], $gasLimit);
$gasUsedFast = calculateEthCost($gasPrices['Fast Gas Price'], $gasLimit);
$baseFeeEth = calculateEthCost($gasPrices['Base Fee'], $gasLimit);

print "Ethereum Gas Fee Estimates\n";
print str_repeat('=', 30) . "\n";

foreach ($gasPrices as $label => $price) {
    printf("%-20s: %8.2f Gwei\n", $label, (float) $price);
}

print "\nEstimated Cost for Gas Limit {$gasLimit}\n";
print str_repeat('-', 30) . "\n";
printf("Safe Tx Cost   : %0.8f ETH\n", $gasUsedSafe);
printf("Average Tx Cost: %0.8f ETH\n", $gasUsedProposed);
printf("Fast Tx Cost   : %0.8f ETH\n", $gasUsedFast);
printf("Base Fee Cost  : %0.8f ETH\n", $baseFeeEth);

if (isset($result['gasUsedRatio'])) {
    print "\nRecent Block Gas Usage Ratios\n";
    print str_repeat('-', 35) . "\n";
    $ratios = array_filter(array_map('trim', explode(',', $result['gasUsedRatio'])));
    foreach ($ratios as $index => $ratio) {
        printf("Block %2d: %5.2f%%\n", $index + 1, (float) $ratio * 100);
    }
}

/**
 * Converts a gas price in Gwei and gas limit to ETH.
 */
function calculateEthCost(string $gasPriceGwei, int $gasLimit): float
{
    $gasPrice = (float) $gasPriceGwei;
    // 1 Gwei = 10^-9 ETH
    return $gasPrice * $gasLimit * 1e-9;
}
