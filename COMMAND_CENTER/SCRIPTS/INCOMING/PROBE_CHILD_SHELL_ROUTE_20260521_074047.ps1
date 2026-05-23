$ErrorActionPreference = "Stop"

$Root123 = "C:\Users\13527\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$BridgeRoot = Join-Path $Root123 "TOOLS\LOCAL_HARD_BRIDGE_V1"
$House = "C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ReceiptDir = Join-Path $CC "RECEIPTS"
$ProbeDir = Join-Path $CC "CHILD_SHELL_PROBES"
New-Item -ItemType Directory -Force -Path $ReceiptDir, $ProbeDir | Out-Null

$ReceiptPath = Join-Path $ReceiptDir "CHILD_SHELL_ROUTE_PROBE_RECEIPT_$Stamp.txt"
$ProbePath = Join-Path $ProbeDir "CHILD_SHELL_ROUTE_PROBE_$Stamp.md"

$KnownRunner = Join-Path $BridgeRoot "RUN_BRIDGE_ONCE.ps1"
$BridgeFiles = @()
if (Test-Path -LiteralPath $BridgeRoot) {
    $BridgeFiles = @(Get-ChildItem -LiteralPath $BridgeRoot -Recurse -File -ErrorAction SilentlyContinue |
        Select-Object -First 80 FullName, Length, LastWriteTime)
}

$LikelyRunners = @()
if (Test-Path -LiteralPath $BridgeRoot) {
    $LikelyRunners = @(Get-ChildItem -LiteralPath $BridgeRoot -Recurse -File -Include "*.ps1","*.cmd","*.bat","*.js","*.json" -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match "RUN|BRIDGE|SHELL|CHILD|ONCE|START|STATUS|MANIFEST" } |
        Sort-Object FullName |
        Select-Object FullName, Length, LastWriteTime)
}

$KnownRunnerHash = "MISSING"
$KnownRunnerHead = "[missing]"
if (Test-Path -LiteralPath $KnownRunner) {
    $KnownRunnerHash = (Get-FileHash -LiteralPath $KnownRunner -Algorithm SHA256).Hash
    $KnownRunnerHead = (Get-Content -LiteralPath $KnownRunner -TotalCount 80) -join "`n"
}

$Probe = @"
# Child Shell Route Probe

## Purpose

Prove what local Child Shell / Local Hard Bridge route exists before claiming the assistant can use it.

## Boundary

Read/probe only.
No Mr.Kleen repo write.
No git add/commit/push.
No doctrine install.
No bridge permission expansion.
No raw shell expansion.
No delete.
No overwrite.
No junction/symlink teleporter.

## Known Paths

123 Root: $Root123
Command Center: $CC
Bridge Root: $BridgeRoot
House: $House

## Exists

123 Root exists: $(Test-Path -LiteralPath $Root123)
Command Center exists: $(Test-Path -LiteralPath $CC)
Bridge Root exists: $(Test-Path -LiteralPath $BridgeRoot)
House exists: $(Test-Path -LiteralPath $House)
Known RUN_BRIDGE_ONCE.ps1 exists: $(Test-Path -LiteralPath $KnownRunner)

## Known Runner

Path:
$KnownRunner

SHA256:
$KnownRunnerHash

## Known Runner First 80 Lines

````powershell
$KnownRunnerHead
````

## Likely Runner / Control Files

$($LikelyRunners | ForEach-Object { "- $($_.FullName) | bytes=$($_.Length) | modified=$($_.LastWriteTime)" } | Out-String)

## Bridge File Sample

$($BridgeFiles | ForEach-Object { "- $($_.FullName) | bytes=$($_.Length) | modified=$($_.LastWriteTime)" } | Out-String)

## Result

This probe does not prove assistant-run local execution.

It proves whether there is a local bridge/child-shell route file available and what its safe visible interface appears to be.

## Next Needed

If RUN_BRIDGE_ONCE.ps1 exists and exposes an approved action interface, the next step is a controlled one-action readback test, preferably house_front_door/status only.
"@

Set-Content -LiteralPath $ProbePath -Value $Probe -Encoding UTF8
$ProbeHash = (Get-FileHash -LiteralPath $ProbePath -Algorithm SHA256).Hash

$Receipt = @"
CHILD SHELL ROUTE PROBE RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PROBE COMPLETE / READ ONLY

Probe:
$ProbePath

Probe SHA256:
$ProbeHash

Known runner:
$KnownRunner

Known runner exists:
$(Test-Path -LiteralPath $KnownRunner)

Known runner SHA256:
$KnownRunnerHash

Boundary:
Command Center local probe only.
No Mr.Kleen repo write.
No git add/commit/push.
No doctrine install.
No bridge permission expansion.
No raw shell expansion.
No delete.
No overwrite.
No junction/symlink teleporter.

Next:
Use the probe file to decide whether a controlled one-action Child Shell test is available.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8
$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL ROUTE PROBE COMPLETE"
Write-Host "Verdict: PROBE COMPLETE / READ ONLY"
Write-Host "Probe: $ProbePath"
Write-Host "Probe SHA256: $ProbeHash"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Known runner: $KnownRunner"
Write-Host "Known runner exists: $(Test-Path -LiteralPath $KnownRunner)"
Write-Host "Known runner SHA256: $KnownRunnerHash"
Write-Host "Boundary: no Mr.Kleen repo write; no git add/commit/push; no doctrine install; no bridge permission expansion; no raw shell expansion; no delete; no overwrite; no junction/symlink teleporter."
Write-Host "Next: send the probe file or receipt back so the assistant can pick the first controlled Child Shell action."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
