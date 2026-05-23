$ErrorActionPreference = "Stop"

function Stop-Fail {
    param([Parameter(Mandatory=$true)][string]$Message)
    throw "STOP. $Message"
}

function Write-Utf8 {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Value
    )
    $Parent = Split-Path -Parent $Path
    if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
        New-Item -ItemType Directory -Force -Path $Parent | Out-Null
    }
    Set-Content -LiteralPath $Path -Value $Value -Encoding UTF8
}

$Root123 = "$env:USERPROFILE\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$Dropzone = Join-Path $ChildRoot "DROPZONE"
$Inbox = Join-Path $ChildRoot "INBOX"
$Outbox = Join-Path $ChildRoot "OUTBOX"
$Rejected = Join-Path $ChildRoot "REJECTED"
$Processed = Join-Path $ChildRoot "PROCESSED"
$WatchDir = Join-Path $ChildRoot "WATCHER"
$Runners = Join-Path $ChildRoot "RUNNERS"
$Helpers = Join-Path $ChildRoot "HELPERS"
$HelperOutput = Join-Path $ChildRoot "HELPER_OUTPUT"
$Receipts = Join-Path $CC "RECEIPTS"

if (-not (Test-Path -LiteralPath $CC)) {
    Stop-Fail "Command Center not found: $CC"
}

New-Item -ItemType Directory -Force -Path $Dropzone, $Inbox, $Outbox, $Rejected, $Processed, $WatchDir, $Runners, $Helpers, $HelperOutput, $Receipts | Out-Null

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Date = Get-Date -Format "yyyyMMdd"

$Level1Runner = Join-Path $Runners "RUN_CHILD_SHELL_LEVEL1_ONCE.ps1"
$StopWatcher = Join-Path $WatchDir "STOP_CHILD_SHELL_WATCHER.ps1"
$EnsureWatcher = Join-Path $WatchDir "ENSURE_CHILD_SHELL_WATCHER_RUNNING.ps1"
$PidFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER.pid"

foreach ($Needed in @($Level1Runner, $StopWatcher, $EnsureWatcher)) {
    if (-not (Test-Path -LiteralPath $Needed)) {
        Stop-Fail "Missing required route file: $Needed"
    }
}

$HelperName = "read_child_shell_status_summary"
$HelperPath = Join-Path $Helpers "HELPER_READ_CHILD_SHELL_STATUS_SUMMARY_LEVEL2.ps1"
$AllowlistPath = Join-Path $ChildRoot "ALLOWLIST_LEVEL2_APPROVED_HELPERS.json"
$Level2Runner = Join-Path $Runners "RUN_CHILD_SHELL_LEVEL2_APPROVED_HELPER_ONCE.ps1"
$Dispatcher = Join-Path $Runners "RUN_CHILD_SHELL_DISPATCH_ONCE.ps1"
$WatcherLoop = Join-Path $WatchDir "CHILD_SHELL_WATCHER_LOOP.ps1"

$HelperContent = @'
param(
    [Parameter(Mandatory=$true)][string]$CommandCenterPath,
    [Parameter(Mandatory=$true)][string]$JobId,
    [Parameter(Mandatory=$true)][string]$OutputPath
)

$ErrorActionPreference = "Stop"

$AllowedFiles = @(
    "README_START_HERE.md",
    "CURRENT_CONTEXT_CART.md",
    "NEXT_ON_THE_PLATE.md",
    "BLOCKED_MOVES.md",
    "ROOM_INDEX.md"
)

$Lines = New-Object System.Collections.Generic.List[string]
$Lines.Add("LEVEL2 APPROVED HELPER OUTPUT")
$Lines.Add("Helper: read_child_shell_status_summary")
$Lines.Add("Job ID: $JobId")
$Lines.Add("Date: $(Get-Date -Format o)")
$Lines.Add("Command Center: $CommandCenterPath")
$Lines.Add("")
$Lines.Add("Allowed read files:")

foreach ($Name in $AllowedFiles) {
    $Path = Join-Path $CommandCenterPath $Name
    if (Test-Path -LiteralPath $Path) {
        $Hash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
        $Raw = Get-Content -LiteralPath $Path -Raw
        $Length = $Raw.Length
        $Preview = $Raw
        if ($Preview.Length -gt 600) {
            $Preview = $Preview.Substring(0, 600) + "`n[TRUNCATED BY LEVEL2 HELPER]"
        }
        $Lines.Add("----- $Name -----")
        $Lines.Add("Path: $Path")
        $Lines.Add("SHA256: $Hash")
        $Lines.Add("Length: $Length")
        $Lines.Add("Preview:")
        $Lines.Add($Preview)
        $Lines.Add("")
    }
    else {
        $Lines.Add("----- $Name -----")
        $Lines.Add("Path: $Path")
        $Lines.Add("MISSING")
        $Lines.Add("")
    }
}

$Parent = Split-Path -Parent $OutputPath
if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
    New-Item -ItemType Directory -Force -Path $Parent | Out-Null
}

Set-Content -LiteralPath $OutputPath -Value ($Lines -join "`n") -Encoding UTF8
'@

Write-Utf8 -Path $HelperPath -Value $HelperContent
$HelperHash = (Get-FileHash -LiteralPath $HelperPath -Algorithm SHA256).Hash

$AllowlistObject = [ordered]@{
    level = 2
    allowed_action = "run_approved_helper"
    helpers = @(
        [ordered]@{
            helper_name = $HelperName
            helper_path = $HelperPath
            helper_sha256 = $HelperHash
            description = "Read a bounded summary of selected Command Center status files and write helper output only."
            allowed_write_root = $HelperOutput
            blocked = @(
                "arbitrary_shell",
                "raw_shell_expansion",
                "git",
                "mr_kleen_repo_write",
                "doctrine_install",
                "active_guides_rewrite",
                "current_truth_index_rewrite",
                "delete",
                "broad_filesystem_crawl",
                "permission_expansion",
                "junction_symlink_teleporter"
            )
        }
    )
}
$AllowlistObject | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $AllowlistPath -Encoding UTF8
$AllowlistHash = (Get-FileHash -LiteralPath $AllowlistPath -Algorithm SHA256).Hash

$Level2RunnerContent = @'
$ErrorActionPreference = "Stop"

function Reject-Job {
    param(
        [Parameter(Mandatory=$true)][string]$Reason,
        [Parameter(Mandatory=$true)][System.IO.FileInfo]$JobFile,
        [Parameter(Mandatory=$false)][string]$JobId = ""
    )

    $Root123 = "$env:USERPROFILE\Desktop\123"
    $CC = Join-Path $Root123 "COMMAND_CENTER"
    $ChildRoot = Join-Path $CC "CHILD_SHELL"
    $Rejected = Join-Path $ChildRoot "REJECTED"

    if ([string]::IsNullOrWhiteSpace($JobId)) {
        $JobId = $JobFile.BaseName
    }

    $RejectNote = Join-Path $Rejected "$JobId.level2.rejected.txt"
    Set-Content -LiteralPath $RejectNote -Value "Rejected Level2 job: $Reason`nJob file: $($JobFile.FullName)`nDate: $(Get-Date -Format o)" -Encoding UTF8
    Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Rejected $JobFile.Name) -Force
    throw "STOP. Rejected Level2 job: $Reason"
}

$Root123 = "$env:USERPROFILE\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$Inbox = Join-Path $ChildRoot "INBOX"
$Outbox = Join-Path $ChildRoot "OUTBOX"
$Rejected = Join-Path $ChildRoot "REJECTED"
$Processed = Join-Path $ChildRoot "PROCESSED"
$HelperOutput = Join-Path $ChildRoot "HELPER_OUTPUT"
$AllowlistPath = Join-Path $ChildRoot "ALLOWLIST_LEVEL2_APPROVED_HELPERS.json"

New-Item -ItemType Directory -Force -Path $Inbox, $Outbox, $Rejected, $Processed, $HelperOutput | Out-Null

if (-not (Test-Path -LiteralPath $AllowlistPath)) {
    throw "STOP. Level2 allowlist missing: $AllowlistPath"
}

$Jobs = @(Get-ChildItem -LiteralPath $Inbox -File -Filter "*.childjob.json" -ErrorAction SilentlyContinue | Sort-Object Name)
if ($Jobs.Count -eq 0) {
    Write-Host "CHILD SHELL LEVEL2 RUNNER: NO JOB FOUND"
    return
}

$JobFile = $Jobs[0]
$JobRaw = Get-Content -LiteralPath $JobFile.FullName -Raw

try {
    $Job = $JobRaw | ConvertFrom-Json
}
catch {
    Reject-Job -Reason "malformed JSON: $($_.Exception.Message)" -JobFile $JobFile
}

$JobId = [string]$Job.job_id
$Action = [string]$Job.allowed_action
$HelperName = [string]$Job.helper_name

if ([string]::IsNullOrWhiteSpace($JobId)) {
    Reject-Job -Reason "missing job_id" -JobFile $JobFile
}

if ($Action -ne "run_approved_helper") {
    Reject-Job -Reason "blocked action: $Action" -JobFile $JobFile -JobId $JobId
}

if ([string]::IsNullOrWhiteSpace($HelperName)) {
    Reject-Job -Reason "missing helper_name" -JobFile $JobFile -JobId $JobId
}

$ReceiptPath = Join-Path $Outbox "$JobId.receipt.txt"
if (Test-Path -LiteralPath $ReceiptPath) {
    Reject-Job -Reason "receipt already exists: $ReceiptPath" -JobFile $JobFile -JobId $JobId
}

$Allowlist = Get-Content -LiteralPath $AllowlistPath -Raw | ConvertFrom-Json
$AllowedHelper = @($Allowlist.helpers | Where-Object { $_.helper_name -eq $HelperName }) | Select-Object -First 1

if ($null -eq $AllowedHelper) {
    Reject-Job -Reason "helper not allowlisted: $HelperName" -JobFile $JobFile -JobId $JobId
}

$HelperPath = [string]$AllowedHelper.helper_path
$ExpectedHelperHash = [string]$AllowedHelper.helper_sha256
$AllowedWriteRoot = [string]$AllowedHelper.allowed_write_root

if (-not (Test-Path -LiteralPath $HelperPath)) {
    Reject-Job -Reason "allowlisted helper path missing: $HelperPath" -JobFile $JobFile -JobId $JobId
}

$ActualHelperHash = (Get-FileHash -LiteralPath $HelperPath -Algorithm SHA256).Hash
if ($ActualHelperHash -ne $ExpectedHelperHash) {
    Reject-Job -Reason "helper hash mismatch. Expected $ExpectedHelperHash actual $ActualHelperHash" -JobFile $JobFile -JobId $JobId
}

$AllowlistHash = (Get-FileHash -LiteralPath $AllowlistPath -Algorithm SHA256).Hash
$JobHash = (Get-FileHash -LiteralPath $JobFile.FullName -Algorithm SHA256).Hash

$OutputPath = Join-Path $HelperOutput "$JobId.helper-output.txt"
if (Test-Path -LiteralPath $OutputPath) {
    Reject-Job -Reason "helper output already exists: $OutputPath" -JobFile $JobFile -JobId $JobId
}

$OutputParent = Split-Path -Parent $OutputPath
$ResolvedOutputParent = [System.IO.Path]::GetFullPath($OutputParent)
$ResolvedAllowedRoot = [System.IO.Path]::GetFullPath($AllowedWriteRoot)
if (-not $ResolvedOutputParent.StartsWith($ResolvedAllowedRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    Reject-Job -Reason "helper output path outside allowed root" -JobFile $JobFile -JobId $JobId
}

& $HelperPath -CommandCenterPath $CC -JobId $JobId -OutputPath $OutputPath
if ($LASTEXITCODE -ne 0) {
    Reject-Job -Reason "helper process returned nonzero exit code $LASTEXITCODE" -JobFile $JobFile -JobId $JobId
}

if (-not (Test-Path -LiteralPath $OutputPath)) {
    Reject-Job -Reason "helper did not create expected output: $OutputPath" -JobFile $JobFile -JobId $JobId
}

$OutputHash = (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash

$Receipt = @"
CHILD SHELL LEVEL2 APPROVED HELPER RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PASS / LEVEL2 APPROVED HELPER JOB CONSUMED

Job ID:
$JobId

Action:
$Action

Helper name:
$HelperName

Helper path:
$HelperPath

Helper SHA256:
$ActualHelperHash

Allowlist:
$AllowlistPath

Allowlist SHA256:
$AllowlistHash

Job file:
$($JobFile.FullName)

Job SHA256:
$JobHash

Helper output:
$OutputPath

Helper output SHA256:
$OutputHash

Boundary:
Command Center Child Shell Level2 approved-helper only.
No arbitrary shell.
No raw shell expansion.
No Mr.Kleen repo write.
No git.
No doctrine install.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No delete.
No broad filesystem crawl.
No permission expansion.
No junction/symlink teleporter.

What this proves:
A watcher-dispatched Level2 job can run one named allowlisted helper after helper hash validation and produce an OUTBOX receipt.

What this does not prove:
Assistant-direct local execution from chat.
Level3 Mr.Kleen house-save execution.
Arbitrary command execution.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8
Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Processed $JobFile.Name) -Force

$ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL LEVEL2 APPROVED HELPER CONSUMED"
Write-Host "Verdict: PASS / LEVEL2 APPROVED HELPER JOB CONSUMED"
Write-Host "Job ID: $JobId"
Write-Host "Action: $Action"
Write-Host "Helper name: $HelperName"
Write-Host "Helper SHA256: $ActualHelperHash"
Write-Host "Allowlist SHA256: $AllowlistHash"
Write-Host "Helper output: $OutputPath"
Write-Host "Helper output SHA256: $OutputHash"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Boundary: Command Center Child Shell Level2 approved-helper only; no arbitrary shell; no raw shell expansion; no Mr.Kleen repo write; no git; no doctrine install; no delete; no broad filesystem crawl; no permission expansion; no junction/symlink teleporter."
Write-Host "Next: assistant may judge Level2 approved-helper proof only; Level3 remains blocked."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
'@

Write-Utf8 -Path $Level2Runner -Value $Level2RunnerContent
$Level2RunnerHash = (Get-FileHash -LiteralPath $Level2Runner -Algorithm SHA256).Hash

$DispatcherContent = @'
$ErrorActionPreference = "Stop"

$Root123 = "$env:USERPROFILE\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$Inbox = Join-Path $ChildRoot "INBOX"
$Rejected = Join-Path $ChildRoot "REJECTED"
$Runners = Join-Path $ChildRoot "RUNNERS"
$Level1Runner = Join-Path $Runners "RUN_CHILD_SHELL_LEVEL1_ONCE.ps1"
$Level2Runner = Join-Path $Runners "RUN_CHILD_SHELL_LEVEL2_APPROVED_HELPER_ONCE.ps1"

$Jobs = @(Get-ChildItem -LiteralPath $Inbox -File -Filter "*.childjob.json" -ErrorAction SilentlyContinue | Sort-Object Name)
if ($Jobs.Count -eq 0) {
    Write-Host "CHILD SHELL DISPATCH: NO JOB FOUND"
    return
}

$JobFile = $Jobs[0]
try {
    $Job = Get-Content -LiteralPath $JobFile.FullName -Raw | ConvertFrom-Json
}
catch {
    $RejectNote = Join-Path $Rejected "$($JobFile.BaseName).dispatch.rejected.txt"
    Set-Content -LiteralPath $RejectNote -Value "Dispatch rejected malformed JSON: $($_.Exception.Message)" -Encoding UTF8
    Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Rejected $JobFile.Name) -Force
    throw "STOP. Dispatch rejected malformed JSON."
}

$Action = [string]$Job.allowed_action

if ($Action -eq "read_command_center_status") {
    & $Level1Runner
}
elseif ($Action -eq "run_approved_helper") {
    & $Level2Runner
}
else {
    $JobId = [string]$Job.job_id
    if ([string]::IsNullOrWhiteSpace($JobId)) { $JobId = $JobFile.BaseName }
    $RejectNote = Join-Path $Rejected "$JobId.dispatch.rejected.txt"
    Set-Content -LiteralPath $RejectNote -Value "Dispatch rejected blocked action: $Action" -Encoding UTF8
    Move-Item -LiteralPath $JobFile.FullName -Destination (Join-Path $Rejected $JobFile.Name) -Force
    throw "STOP. Dispatch rejected blocked action: $Action"
}
'@

Write-Utf8 -Path $Dispatcher -Value $DispatcherContent
$DispatcherHash = (Get-FileHash -LiteralPath $Dispatcher -Algorithm SHA256).Hash

$WatcherLoopContent = @'
$ErrorActionPreference = "Stop"

$Root123 = "$env:USERPROFILE\Desktop\123"
$CC = Join-Path $Root123 "COMMAND_CENTER"
$ChildRoot = Join-Path $CC "CHILD_SHELL"
$Inbox = Join-Path $ChildRoot "INBOX"
$Outbox = Join-Path $ChildRoot "OUTBOX"
$Rejected = Join-Path $ChildRoot "REJECTED"
$Processed = Join-Path $ChildRoot "PROCESSED"
$Dropzone = Join-Path $ChildRoot "DROPZONE"
$WatchDir = Join-Path $ChildRoot "WATCHER"
$Runners = Join-Path $ChildRoot "RUNNERS"
$Dispatcher = Join-Path $Runners "RUN_CHILD_SHELL_DISPATCH_ONCE.ps1"
$PidFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER.pid"
$HeartbeatFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER_HEARTBEAT.txt"
$StopSignal = Join-Path $WatchDir "STOP.signal"

New-Item -ItemType Directory -Force -Path $Inbox, $Outbox, $Rejected, $Processed, $Dropzone, $WatchDir | Out-Null

if (-not (Test-Path -LiteralPath $Dispatcher)) {
    throw "STOP. Dispatcher missing: $Dispatcher"
}

Set-Content -LiteralPath $PidFile -Value $PID -Encoding UTF8

while ($true) {
    if (Test-Path -LiteralPath $StopSignal) {
        Remove-Item -LiteralPath $StopSignal -Force -ErrorAction SilentlyContinue
        Add-Content -LiteralPath $HeartbeatFile -Value "$(Get-Date -Format o) | STOP SIGNAL RECEIVED | PID=$PID" -Encoding UTF8
        break
    }

    Add-Content -LiteralPath $HeartbeatFile -Value "$(Get-Date -Format o) | WATCHING DISPATCH | PID=$PID" -Encoding UTF8

    $DropJobs = @(Get-ChildItem -LiteralPath $Dropzone -File -Filter "*.childjob.json" -ErrorAction SilentlyContinue | Sort-Object Name)
    foreach ($Job in $DropJobs) {
        $Target = Join-Path $Inbox $Job.Name
        if (Test-Path -LiteralPath $Target) {
            $RejectTarget = Join-Path $Rejected "$($Job.BaseName).duplicate-drop.rejected.txt"
            Set-Content -LiteralPath $RejectTarget -Value "Rejected duplicate dropzone job because INBOX target already exists: $($Job.FullName)" -Encoding UTF8
            Move-Item -LiteralPath $Job.FullName -Destination (Join-Path $Rejected $Job.Name) -Force
        }
        else {
            Move-Item -LiteralPath $Job.FullName -Destination $Target -Force
            Add-Content -LiteralPath $HeartbeatFile -Value "$(Get-Date -Format o) | MOVED DROPZONE JOB TO INBOX | $($Job.Name)" -Encoding UTF8
        }
    }

    $InboxJobs = @(Get-ChildItem -LiteralPath $Inbox -File -Filter "*.childjob.json" -ErrorAction SilentlyContinue | Sort-Object Name)
    if ($InboxJobs.Count -gt 0) {
        try {
            & $Dispatcher | Out-File -FilePath (Join-Path $WatchDir "LAST_RUN_OUTPUT.txt") -Encoding UTF8
            Add-Content -LiteralPath $HeartbeatFile -Value "$(Get-Date -Format o) | DISPATCHER ATTEMPTED" -Encoding UTF8
        }
        catch {
            $ErrPath = Join-Path $WatchDir "LAST_RUN_ERROR.txt"
            Set-Content -LiteralPath $ErrPath -Value "$(Get-Date -Format o)`n$($_.Exception.Message)" -Encoding UTF8
            Add-Content -LiteralPath $HeartbeatFile -Value "$(Get-Date -Format o) | DISPATCHER ERROR | $($_.Exception.Message)" -Encoding UTF8
        }
    }

    Start-Sleep -Seconds 2
}

Remove-Item -LiteralPath $PidFile -Force -ErrorAction SilentlyContinue
'@

Write-Utf8 -Path $WatcherLoop -Value $WatcherLoopContent
$WatcherLoopHash = (Get-FileHash -LiteralPath $WatcherLoop -Algorithm SHA256).Hash

# Restart watcher so it uses dispatcher loop.
& $StopWatcher | Out-File -FilePath (Join-Path $WatchDir "LEVEL2_INSTALL_STOP_OUTPUT_$Stamp.txt") -Encoding UTF8
Start-Sleep -Seconds 5
& $EnsureWatcher | Out-File -FilePath (Join-Path $WatchDir "LEVEL2_INSTALL_ENSURE_OUTPUT_$Stamp.txt") -Encoding UTF8
Start-Sleep -Seconds 3

$WatcherPid = "[missing]"
$WatcherState = "UNKNOWN"
$PidFile = Join-Path $WatchDir "CHILD_SHELL_WATCHER.pid"
if (Test-Path -LiteralPath $PidFile) {
    $WatcherPid = (Get-Content -LiteralPath $PidFile -Raw).Trim()
    if ($WatcherPid -match '^\d+$') {
        $Proc = Get-Process -Id ([int]$WatcherPid) -ErrorAction SilentlyContinue
        if ($null -ne $Proc) { $WatcherState = "RUNNING" } else { $WatcherState = "STALE_OR_STOPPED" }
    }
}
if ($WatcherState -ne "RUNNING") {
    Stop-Fail "Watcher not running after Level2 install restart. State: $WatcherState PID: $WatcherPid"
}

$JobId = "CHILDJOB-$Date-000007-LEVEL2-APPROVED-HELPER-STATUS"
$JobPath = Join-Path $Dropzone "$JobId.childjob.json"
$ExpectedReceipt = Join-Path $Outbox "$JobId.receipt.txt"

if (Test-Path -LiteralPath $ExpectedReceipt) {
    Stop-Fail "Level2 self-test receipt already exists: $ExpectedReceipt"
}

$JobObject = [ordered]@{
    job_id = $JobId
    created_at = (Get-Date -Format o)
    requested_by = "level2_approved_helper_install_selftest"
    route = "COMMAND_CENTER/CHILD_SHELL/WATCHER/DISPATCH/LEVEL2"
    allowed_action = "run_approved_helper"
    helper_name = $HelperName
    expected_receipt = $ExpectedReceipt
    boundary = @(
        "Command Center Child Shell Level2 approved-helper only",
        "no arbitrary shell",
        "no raw shell expansion",
        "no Mr.Kleen repo write",
        "no git",
        "no doctrine install",
        "no ACTIVE_GUIDES rewrite",
        "no CURRENT_TRUTH_INDEX rewrite",
        "no delete",
        "no broad filesystem crawl",
        "no permission expansion",
        "no junction or symlink teleporter"
    )
    stop_conditions = @(
        "watcher not running",
        "dispatcher missing",
        "Level2 runner missing",
        "allowlist missing",
        "helper not allowlisted",
        "helper hash mismatch",
        "receipt already exists",
        "malformed job"
    )
}
$JobObject | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $JobPath -Encoding UTF8
$JobHash = (Get-FileHash -LiteralPath $JobPath -Algorithm SHA256).Hash

$Deadline = (Get-Date).AddSeconds(60)
while ((Get-Date) -lt $Deadline) {
    if (Test-Path -LiteralPath $ExpectedReceipt) {
        break
    }
    Start-Sleep -Seconds 1
}

if (-not (Test-Path -LiteralPath $ExpectedReceipt)) {
    Write-Host "NO LEVEL2 RECEIPT"
    cmd /c dir /s /b "%USERPROFILE%\Desktop\123\COMMAND_CENTER\CHILD_SHELL\*000007*"
    Write-Host "LAST WATCHER OUTPUT"
    Get-Content -LiteralPath (Join-Path $WatchDir "LAST_RUN_OUTPUT.txt") -Raw -ErrorAction SilentlyContinue
    Write-Host "LAST WATCHER ERROR"
    Get-Content -LiteralPath (Join-Path $WatchDir "LAST_RUN_ERROR.txt") -Raw -ErrorAction SilentlyContinue
    Stop-Fail "Level2 approved-helper receipt did not appear: $ExpectedReceipt"
}

$ReceiptHash = (Get-FileHash -LiteralPath $ExpectedReceipt -Algorithm SHA256).Hash

$InstallReceipt = Join-Path $Receipts "CHILD_SHELL_LEVEL2_APPROVED_HELPER_ROUTE_INSTALL_RECEIPT_$Stamp.txt"

$InstallText = @"
CHILD SHELL LEVEL2 APPROVED HELPER ROUTE INSTALL RECEIPT
Date: $(Get-Date -Format o)

Verdict:
PASS / LEVEL2 APPROVED HELPER ROUTE INSTALLED AND SELF-TESTED

Helper name:
$HelperName

Helper path:
$HelperPath

Helper SHA256:
$HelperHash

Allowlist:
$AllowlistPath

Allowlist SHA256:
$AllowlistHash

Level2 runner:
$Level2Runner

Level2 runner SHA256:
$Level2RunnerHash

Dispatcher:
$Dispatcher

Dispatcher SHA256:
$DispatcherHash

Watcher loop:
$WatcherLoop

Watcher loop SHA256:
$WatcherLoopHash

Watcher PID after install:
$WatcherPid

Watcher state after install:
$WatcherState

Self-test job:
$JobPath

Self-test job SHA256:
$JobHash

Self-test receipt:
$ExpectedReceipt

Self-test receipt SHA256:
$ReceiptHash

Boundary:
Command Center Child Shell Level2 approved-helper only.
No arbitrary shell.
No raw shell expansion.
No Mr.Kleen repo write.
No git.
No doctrine install.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No delete.
No broad filesystem crawl.
No permission expansion.
No junction/symlink teleporter.

Meaning:
A watcher-dispatched Level2 job can run one named allowlisted helper after helper hash validation and produce an OUTBOX receipt.

Not proved:
Assistant-direct local execution from chat.
Level3 Mr.Kleen house-save execution.
Arbitrary command execution.
"@

Write-Utf8 -Path $InstallReceipt -Value $InstallText
$InstallReceiptHash = (Get-FileHash -LiteralPath $InstallReceipt -Algorithm SHA256).Hash

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "CHILD SHELL LEVEL2 APPROVED HELPER ROUTE INSTALLED"
Write-Host "Verdict: PASS / LEVEL2 APPROVED HELPER ROUTE INSTALLED AND SELF-TESTED"
Write-Host "Helper name: $HelperName"
Write-Host "Helper path: $HelperPath"
Write-Host "Helper SHA256: $HelperHash"
Write-Host "Allowlist: $AllowlistPath"
Write-Host "Allowlist SHA256: $AllowlistHash"
Write-Host "Level2 runner: $Level2Runner"
Write-Host "Level2 runner SHA256: $Level2RunnerHash"
Write-Host "Dispatcher: $Dispatcher"
Write-Host "Dispatcher SHA256: $DispatcherHash"
Write-Host "Watcher loop SHA256: $WatcherLoopHash"
Write-Host "Watcher PID after install: $WatcherPid"
Write-Host "Watcher state after install: $WatcherState"
Write-Host "Self-test Job ID: $JobId"
Write-Host "Self-test Job SHA256: $JobHash"
Write-Host "Self-test Receipt: $ExpectedReceipt"
Write-Host "Self-test Receipt SHA256: $ReceiptHash"
Write-Host "Install Receipt: $InstallReceipt"
Write-Host "Install Receipt SHA256: $InstallReceiptHash"
Write-Host "Boundary: Command Center Child Shell Level2 approved-helper only; no arbitrary shell; no raw shell expansion; no Mr.Kleen repo write; no git; no doctrine install; no delete; no broad filesystem crawl; no permission expansion; no junction/symlink teleporter."
Write-Host "Next: assistant may judge Level2 approved-helper proof only; Level3 remains blocked."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
