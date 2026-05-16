$ErrorActionPreference = "Stop"

$ApprovedRoots = @(
    "$env:USERPROFILE\Desktop\Clean Milk not-BLOAT",
    "$env:USERPROFILE\Desktop\Shed"
)

$BridgeRoot = "$env:USERPROFILE\Desktop\CleanSeed_LiveBridge_V0"
$PublicRoot = Join-Path $BridgeRoot "PUBLIC_GATE"
$V0Script = "C:\CleanSeedsBuild\CLEANSEED_LIVE_BRIDGE_V0_PARKING_DELTA.ps1"

New-Item -ItemType Directory -Force -Path $PublicRoot | Out-Null

function Get-CleanSeed-Fingerprint {
    $rows = @()

    foreach ($root in $ApprovedRoots) {
        if (Test-Path -LiteralPath $root -PathType Container) {
            $rows += Get-ChildItem -LiteralPath $root -Recurse -Force -ErrorAction SilentlyContinue |
                Select-Object FullName, Length, LastWriteTimeUtc, PSIsContainer
        }
    }

    $text = ($rows | Sort-Object FullName | ConvertTo-Json -Compress -Depth 4)
    $bytes = [Text.Encoding]::UTF8.GetBytes($text)
    $sha = [Security.Cryptography.SHA256]::Create()
    return ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace("-","")
}

function Sync-CleanSeed-LatestBundle {
    $latestRun = Get-ChildItem -LiteralPath $BridgeRoot -Directory -Filter "RUN_*" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if (-not $latestRun) {
        return
    }

    $bundle = Join-Path $latestRun.FullName "CHATGPT_DELTA_UPLOAD_BUNDLE.txt"

    if (Test-Path -LiteralPath $bundle -PathType Leaf) {
        Copy-Item -LiteralPath $bundle -Destination (Join-Path $PublicRoot "LATEST_DELTA_UPLOAD_BUNDLE.txt") -Force

        $status = [pscustomobject]@{
            status = "OK"
            updated_local = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss zzz")
            latest_run = $latestRun.FullName
            latest_bundle = $bundle
            public_copy = (Join-Path $PublicRoot "LATEST_DELTA_UPLOAD_BUNDLE.txt")
        }

        $status | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $PublicRoot "STATUS.json") -Encoding UTF8
    }
}

Write-Host "============================================================"
Write-Host "CLEAN SEED PUBLIC GATE WATCHER"
Write-Host "============================================================"
Write-Host "Watching approved roots only:"
$ApprovedRoots | ForEach-Object { Write-Host " - $_" }
Write-Host ""
Write-Host "No delete. No move. No rename. No cleanup. No promotion."
Write-Host "This watcher only detects changes, runs V0, and updates PUBLIC_GATE."
Write-Host "Keep this window open."
Write-Host "============================================================"

Sync-CleanSeed-LatestBundle
$last = Get-CleanSeed-Fingerprint

while ($true) {
    Start-Sleep -Seconds 10

    try {
        $now = Get-CleanSeed-Fingerprint

        if ($now -ne $last) {
            Write-Host ""
            Write-Host "CHANGE DETECTED: running V0 delta scan..."
            Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
            & $V0Script
            Sync-CleanSeed-LatestBundle
            $last = $now
            Write-Host "PUBLIC_GATE updated."
        }
    }
    catch {
        Write-Host "WATCHER ERROR: $($_.Exception.Message)"
    }
}
