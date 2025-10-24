# PHP Referer Tracking Script

This repository contains a simple PHP script (`referer_tracker.php`) that logs
incoming HTTP referer information to `logs/referers.log`. Each request records
its timestamp, referer, IP address, and user agent, then returns the stored
entry as JSON.

## Usage

1. Upload `referer_tracker.php` to your PHP-enabled server.
2. Ensure the server can create and write to the `logs/` directory next to the
   script.
3. Include the script in pages you want to track or point forms/links to it.
4. Inspect `logs/referers.log` to review the collected entries (each stored as a
   JSON line).

The repository includes a `.gitignore` inside `logs/` so the log file itself is
not committed to version control.
