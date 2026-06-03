# Console Severity Color Checklist

Saved: 20260603_140117

## For console-facing scripts

Use Write-Host with foreground colors for high-level labels.

Keep plain text values intact.

Required visual lanes:

- PASS -> green
- PASS_WITH_WATCH -> yellow plus green proof details when appropriate
- WATCH_WARNING_COUNT > 0 -> yellow
- BLOCKING_WARNING_COUNT > 0 -> red
- UNKNOWN_WARNING_COUNT > 0 -> magenta or red
- FAILURE_COUNT > 0 -> red
- NEXT_LEGAL_ACTION allowed -> cyan
- NEXT_LEGAL_ACTION watch -> yellow
- NEXT_LEGAL_ACTION blocked -> red
- paths and hashes -> cyan or gray
- DoesNotProve and StopLine -> gray/yellow labels

## Do not

- remove plain text
- hide hashes
- replace classification with color only
- make color the authority
- mix color-only changes with logic changes without labeling it
