param(
    [string]$Path,
    [switch]$NewestPackageFromDownloads,
    [switch]$RunWatcher
)

$ErrorActionPreference = "Stop"

$MailRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$Incoming = Join-Path $MailRoot "INCOMING_PACKAGES"
$Watcher = Join-Path $MailRoot "TOOLS\WATCH_INCOMING_PACKAGE_FILES_ONCE.ps1"

New-Item -ItemType Directory -Force -Path $Incoming | Out-Null

function Has-PackageMarker([string]$FilePath) {
    try {
        $Text = Get-Content -Raw -LiteralPath $FilePath -ErrorAction Stop
        return [bool]($Text -match "(?m)^PACKAGE_V0\s*$")
    } catch {
        return $false
    }
}

if ($NewestPackageFromDownloads) {
    $SearchRoots = @(
        "$env:USERPROFILE\Downloads",
        "$env:USERPROFILE\Desktop"
    ) | Where-Object { Test-Path -LiteralPath $_ }

    $Candidates = foreach ($Root in $SearchRoots) {
        Get-ChildItem -LiteralPath $Root -File -ErrorAction SilentlyContinue |
            Where-Object {
                $_.Name -notmatch '\.tmp$|\.partial$|\.crdownload$' -and
                (Has-PackageMarker $_.FullName)
            }
    }

    $Pick = $Candidates | Sort-Object LastWriteTimeUtc -Descending | Select-Object -First 1
    if (-not $Pick) {
        throw "No PACKAGE_V0 file found in Downloads/Desktop."
    }

    $Path = $Pick.FullName
}

if (-not $Path) {
    throw "Provide -Path or use -NewestPackageFromDownloads."
}

$Path = (Resolve-Path -LiteralPath $Path).Path

if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    throw "File not found: $Path"
}

$SourceName = [IO.Path]::GetFileName($Path)
$SafeName = $SourceName -replace '[\\/:*?"<>|]', '_'
$Dest = Join-Path $Incoming $SafeName

if (Test-Path -LiteralPath $Dest) {
    $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $Base = [IO.Path]::GetFileNameWithoutExtension($SafeName)
    $Ext = [IO.Path]::GetExtension($SafeName)
    $Dest = Join-Path $Incoming "$Base.$Stamp$Ext"
}

Copy-Item -LiteralPath $Path -Destination $Dest -Force

$SourceHash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
$DestHash = (Get-FileHash -LiteralPath $Dest -Algorithm SHA256).Hash

[ordered]@{
    verdict = "PASS / PICKED UP TO MAIL_ROOM INCOMING"
    source = $Path
    source_sha256 = $SourceHash
    incoming_path = $Dest
    incoming_sha256 = $DestHash
    copied_not_moved = $true
    run_watcher = [bool]$RunWatcher
} | ConvertTo-Json -Depth 5

if ($RunWatcher) {
    if (-not (Test-Path -LiteralPath $Watcher)) {
        throw "Watcher not found: $Watcher"
    }

    & $Watcher -InitialTimeoutSeconds 60 -IdleAfterFirstSeconds 5
}
