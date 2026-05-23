$ErrorActionPreference = "Stop"

$Root = Join-Path $env:USERPROFILE "Desktop\GPT_Prompts"
$Ready = Join-Path $Root "READY_TO_DROP_IN_CHAT"
$Current = Join-Path $Root "CURRENT"
$Custody = Join-Path $env:USERPROFILE "Desktop\123\GPT_PROMPTS_CUSTODY"
$ReceiptDir = Join-Path $Custody "RECEIPTS"
$BackupRoot = Join-Path $Custody "CURRENT_BACKUPS_BEFORE_CHAT_WEIGHT_RELEASE_LOCK"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

$PackageDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$MapSource = Join-Path $PackageDir "CHAT_SOFT_SUIT_MAP.md"
$LedgerSource = Join-Path $PackageDir "CHAT_SOFT_SUIT_IDEA_LEDGER.md"

if (!(Test-Path -LiteralPath $MapSource)) { throw "Missing package file: $MapSource" }
if (!(Test-Path -LiteralPath $LedgerSource)) { throw "Missing package file: $LedgerSource" }

New-Item -ItemType Directory -Path $Ready,$Current,$ReceiptDir,$BackupRoot -Force | Out-Null

$Backup = Join-Path $BackupRoot $Stamp
New-Item -ItemType Directory -Path $Backup -Force | Out-Null

$Files = @("CHAT_SOFT_SUIT_MAP.md","CHAT_SOFT_SUIT_IDEA_LEDGER.md")
$BackedUp = @()
$WrittenReady = @()
$WrittenCurrent = @()

foreach ($Name in $Files) {
    $CurrentPath = Join-Path $Current $Name
    if (Test-Path -LiteralPath $CurrentPath) {
        Copy-Item -LiteralPath $CurrentPath -Destination (Join-Path $Backup $Name) -Force
        $BackedUp += $Name
    }
}

Copy-Item -LiteralPath $MapSource -Destination (Join-Path $Ready "CHAT_SOFT_SUIT_MAP.md") -Force
$WrittenReady += "CHAT_SOFT_SUIT_MAP.md"
Copy-Item -LiteralPath $LedgerSource -Destination (Join-Path $Ready "CHAT_SOFT_SUIT_IDEA_LEDGER.md") -Force
$WrittenReady += "CHAT_SOFT_SUIT_IDEA_LEDGER.md"

Copy-Item -LiteralPath (Join-Path $Ready "CHAT_SOFT_SUIT_MAP.md") -Destination (Join-Path $Current "CHAT_SOFT_SUIT_MAP.md") -Force
$WrittenCurrent += "CHAT_SOFT_SUIT_MAP.md"
Copy-Item -LiteralPath (Join-Path $Ready "CHAT_SOFT_SUIT_IDEA_LEDGER.md") -Destination (Join-Path $Current "CHAT_SOFT_SUIT_IDEA_LEDGER.md") -Force
$WrittenCurrent += "CHAT_SOFT_SUIT_IDEA_LEDGER.md"

$MapHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Current "CHAT_SOFT_SUIT_MAP.md")).Hash
$LedgerHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $Current "CHAT_SOFT_SUIT_IDEA_LEDGER.md")).Hash

$Receipt = Join-Path $ReceiptDir "CHAT_SOFT_SUIT_CHAT_WEIGHT_RELEASE_LOCK_$Stamp.txt"

@(
"CHAT SOFT SUIT CHAT WEIGHT RELEASE LOCK",
"Timestamp: $Stamp",
"Root: $Root",
"Ready: $Ready",
"Current: $Current",
"Backup: $Backup",
"",
"Backed up from CURRENT count: $($BackedUp.Count)",
($BackedUp -join [Environment]::NewLine),
"",
"Written to READY count: $($WrittenReady.Count)",
($WrittenReady -join [Environment]::NewLine),
"",
"Written to CURRENT count: $($WrittenCurrent.Count)",
($WrittenCurrent -join [Environment]::NewLine),
"",
"Current map SHA256: $MapHash",
"Current ledger SHA256: $LedgerHash",
"",
"Locked ideas:",
"- Chat Weight Release / hold active only",
"- Fog Bell warning",
"- Let-Go Algorithm",
"- Condense/dissect working order",
"- Move/sort authorization carried forward",
"",
"Boundary: local-only; no Git; no public export; no doctrine promotion; old CURRENT copies backed up, not deleted.",
"Verdict: PASS / CHAT WEIGHT RELEASE AND FOG BELL LOCKED INTO CURRENT"
) | Set-Content -LiteralPath $Receipt -Encoding UTF8

Get-Content -LiteralPath $Receipt -Raw
