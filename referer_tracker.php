<?php

declare(strict_types=1);

/**
 * Simple referer tracking script.
 *
 * Logs information about the request's referer, IP address, and user agent
 * to logs/referers.log relative to this script. Creates the log directory if
 * it does not exist. Returns a JSON response summarizing the stored entry.
 */

date_default_timezone_set('UTC');

$logDirectory = __DIR__ . DIRECTORY_SEPARATOR . 'logs';
$logFile = $logDirectory . DIRECTORY_SEPARATOR . 'referers.log';

if (!is_dir($logDirectory)) {
    mkdir($logDirectory, 0775, true);
}

$referer = $_SERVER['HTTP_REFERER'] ?? 'DIRECT';
$ipAddress = $_SERVER['REMOTE_ADDR'] ?? 'UNKNOWN';
$userAgent = $_SERVER['HTTP_USER_AGENT'] ?? 'UNKNOWN';
$timestamp = date('c');

$entry = [
    'timestamp' => $timestamp,
    'referer' => $referer,
    'ip' => $ipAddress,
    'user_agent' => $userAgent,
];

$encodedEntry = json_encode($entry, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);

if ($encodedEntry === false) {
    http_response_code(500);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'status' => 'error',
        'message' => 'Failed to encode log entry.',
    ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    exit;
}

file_put_contents($logFile, $encodedEntry . PHP_EOL, FILE_APPEND | LOCK_EX);

header('Content-Type: application/json; charset=utf-8');
echo json_encode([
    'status' => 'ok',
    'logged' => $entry,
], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
