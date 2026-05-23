# THIS CODE IS FOR LOCAL.
# INSTALL_ASSISTANT_DOOR_RELAY_V1_20260521.ps1
# Purpose: install/prove a bounded chat-to-local "door relay" into 123 without disturbing existing files.
# Scope: creates new relay files/folders only, runs one safe Level 1 read-status test through Child Shell, writes new timestamped journal/deep-scan/proof files.
# Boundary: no overwrite, no delete, no cleanup, no broad crawl, no repo write, no git write.

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Stop-Custody {
    param([string]$Message)
    Write-Host "FOG / CUSTODY FAIL: STOP"
    Write-Host $Message
    exit 1
}

function New-DirectoryIfMissing {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Write-NewFileStrict {
    param(
        [string]$Path,
        [string]$Content
    )
    if (Test-Path -LiteralPath $Path) {
        Stop-Custody "Refusing to overwrite existing file: $Path"
    }
    $Parent = Split-Path -Parent $Path
    if ($Parent) { New-DirectoryIfMissing $Parent }
    Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
}

function Get-HashOrMissing {
    param([string]$Path)
    if (Test-Path -LiteralPath $Path) {
        return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
    }
    return "[missing]"
}

$UserLocalNow = Get-Date
$Stamp = $UserLocalNow.ToString("yyyyMMdd_HHmmss")
$IsoNow = $UserLocalNow.ToString("o")
$RunId = "ASSISTANT_DOOR_RELAY_V1_$Stamp"

$Root123 = Join-Path $env:USERPROFILE "Desktop\123"
$CommandCenter = Join-Path $Root123 "COMMAND_CENTER"
$ChildShell = Join-Path $CommandCenter "CHILD_SHELL"
$Dropzone = Join-Path $ChildShell "DROPZONE"
$Outbox = Join-Path $ChildShell "OUTBOX"
$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"

$RelayRoot = Join-Path $CommandCenter "ASSISTANT_DOOR_RELAY"
$RelayTools = Join-Path $RelayRoot "TOOLS"
$RelayNotes = Join-Path $RelayRoot "DOOR_NOTES"
$RelayInbox = Join-Path $RelayRoot "INBOX"
$RelayProcessed = Join-Path $RelayRoot "PROCESSED"
$RelayRejected = Join-Path $RelayRoot "REJECTED"
$RelayReceipts = Join-Path $RelayRoot "RECEIPTS"
$RelayRuns = Join-Path $RelayRoot "RUNS"
$RunDir = Join-Path $RelayRuns $RunId

$DoorNotePath = Join-Path $RelayNotes "ASSISTANT_DOOR_NOTE_$Stamp.md"
$JournalPath = Join-Path $RunDir "JOURNAL_ENTRY_$Stamp.md"
$ScanPath = Join-Path $RunDir "DEEP_SCAN_SUMMARY_$Stamp.md"
$InstallReceiptPath = Join-Path $RelayReceipts "ASSISTANT_DOOR_RELAY_V1_INSTALL_AND_TEST_RECEIPT_$Stamp.txt"
$RelayHelperPath = Join-Path $RelayTools "DROP_CHAT_JOB_FROM_CLIPBOARD_V1.ps1"

if (-not (Test-Path -LiteralPath $Root123)) { Stop-Custody "123 root missing: $Root123" }
if (-not (Test-Path -LiteralPath $CommandCenter)) { Stop-Custody "Command Center missing: $CommandCenter" }
if (-not (Test-Path -LiteralPath $ChildShell)) { Stop-Custody "Child Shell missing: $ChildShell" }
if (-not (Test-Path -LiteralPath $Dropzone)) { Stop-Custody "Child Shell DROPZONE missing: $Dropzone" }
if (-not (Test-Path -LiteralPath $Outbox)) { Stop-Custody "Child Shell OUTBOX missing: $Outbox" }
if (-not (Test-Path -LiteralPath (Join-Path $Repo ".git"))) { Stop-Custody "Mr.Kleen repo .git missing: $Repo" }

Push-Location $Repo
try {
    $RepoHeadShort = (git rev-parse --short HEAD).Trim()
    $RepoHeadFull = (git rev-parse HEAD).Trim()
    $RepoOriginFull = (git rev-parse origin/main).Trim()
    $RepoStatusRaw = (git status --short | Out-String).Trim()
    if ([string]::IsNullOrWhiteSpace($RepoStatusRaw)) {
        $RepoStatusText = "clean"
    } else {
        $RepoStatusText = $RepoStatusRaw
        Stop-Custody "Mr.Kleen repo is not clean before relay install/test. Status:`n$RepoStatusText"
    }
}
finally {
    Pop-Location
}

New-DirectoryIfMissing $RelayRoot
New-DirectoryIfMissing $RelayTools
New-DirectoryIfMissing $RelayNotes
New-DirectoryIfMissing $RelayInbox
New-DirectoryIfMissing $RelayProcessed
New-DirectoryIfMissing $RelayRejected
New-DirectoryIfMissing $RelayReceipts
New-DirectoryIfMissing $RelayRuns
New-DirectoryIfMissing $RunDir

$RelayHelperContent = @'
# THIS CODE IS FOR LOCAL.
# DROP_CHAT_JOB_FROM_CLIPBOARD_V1.ps1
# Purpose: bounded manual relay from ChatGPT copied JSON -> local Child Shell DROPZONE -> OUTBOX receipt.
# Boundary: accepts JSON from clipboard, permits only safe approved action names, writes one new childjob file, waits for receipt.

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Fail-Relay {
    param([string]$Message)
    Write-Host "ASSISTANT DOOR RELAY FAIL"
    Write-Host $Message
    exit 1
}

$Root123 = Join-Path $env:USERPROFILE "Desktop\123"
$CommandCenter = Join-Path $Root123 "COMMAND_CENTER"
$ChildShell = Join-Path $CommandCenter "CHILD_SHELL"
$Dropzone = Join-Path $ChildShell "DROPZONE"
$Outbox = Join-Path $ChildShell "OUTBOX"

if (-not (Test-Path -LiteralPath $Dropzone)) { Fail-Relay "DROPZONE missing: $Dropzone" }
if (-not (Test-Path -LiteralPath $Outbox)) { Fail-Relay "OUTBOX missing: $Outbox" }

$Raw = Get-Clipboard -Raw
if ([string]::IsNullOrWhiteSpace($Raw)) { Fail-Relay "Clipboard is empty." }

try {
    $Job = $Raw | ConvertFrom-Json -Depth 20
}
catch {
    Fail-Relay "Clipboard did not contain valid JSON. $($_.Exception.Message)"
}

if (-not $Job.job_id) { Fail-Relay "Missing job_id." }
if (-not $Job.allowed_action) { Fail-Relay "Missing allowed_action." }

$JobId = [string]$Job.job_id
if ($JobId -notmatch '^CHILDJOB-[0-9]{8}-[0-9]{6}-ASSISTANT-DOOR-[A-Z0-9-]+$') {
    Fail-Relay "Job ID does not match assistant door relay pattern: $JobId"
}

$AllowedActions = @(
    "read_command_center_status"
)

if ($AllowedActions -notcontains ([string]$Job.allowed_action)) {
    Fail-Relay "Action is not allowed by Assistant Door Relay V1: $($Job.allowed_action)"
}

$JobPath = Join-Path $Dropzone "$JobId.childjob.json"
$ReceiptPath = Join-Path $Outbox "$JobId.receipt.txt"

if (Test-Path -LiteralPath $JobPath) { Fail-Relay "Refusing duplicate childjob path: $JobPath" }
if (Test-Path -LiteralPath $ReceiptPath) { Fail-Relay "Refusing duplicate receipt path: $ReceiptPath" }

$Raw | Set-Content -LiteralPath $JobPath -Encoding UTF8

$Deadline = (Get-Date).AddSeconds(45)
while ((Get-Date) -lt $Deadline) {
    if (Test-Path -LiteralPath $ReceiptPath) { break }
    Start-Sleep -Seconds 1
}

if (Test-Path -LiteralPath $ReceiptPath) {
    $ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash
    Write-Host "ASSISTANT DOOR RELAY PASS"
    Write-Host "Job ID: $JobId"
    Write-Host "Job path: $JobPath"
    Write-Host "Receipt path: $ReceiptPath"
    Write-Host "Receipt SHA256: $ReceiptHash"
    exit 0
}

$KnownLocations = cmd /c dir /s /b "%USERPROFILE%\Desktop\123\COMMAND_CENTER\CHILD_SHELL\*$JobId*" 2>$null
Write-Host "ASSISTANT DOOR RELAY PARTIAL"
Write-Host "Job ID: $JobId"
Write-Host "Job path: $JobPath"
Write-Host "No OUTBOX receipt within wait window."
Write-Host "Known locations:"
Write-Host $KnownLocations
exit 2
'@

if (-not (Test-Path -LiteralPath $RelayHelperPath)) {
    Write-NewFileStrict -Path $RelayHelperPath -Content $RelayHelperContent
} else {
    $ExistingHelperHash = (Get-FileHash -LiteralPath $RelayHelperPath -Algorithm SHA256).Hash
    $TempHelper = Join-Path $RunDir "DROP_CHAT_JOB_FROM_CLIPBOARD_V1_EXPECTED_$Stamp.ps1"
    Write-NewFileStrict -Path $TempHelper -Content $RelayHelperContent
    $ExpectedHelperHash = (Get-FileHash -LiteralPath $TempHelper -Algorithm SHA256).Hash
    if ($ExistingHelperHash -ne $ExpectedHelperHash) {
        Stop-Custody "Existing relay helper differs from expected content. Existing: $RelayHelperPath Hash: $ExistingHelperHash Expected: $ExpectedHelperHash"
    }
}

$RelayHelperHash = (Get-FileHash -LiteralPath $RelayHelperPath -Algorithm SHA256).Hash

$DoorNote = @"
# Assistant Door Note — Door Relay V1

Created:

$IsoNow

Run ID:

$RunId

## Purpose

This note points future assistant work to the missing bridge piece:

ChatGPT cannot directly write to the Windows Child Shell DROPZONE from chat alone.

Assistant Door Relay V1 creates a bounded manual relay:

ChatGPT JSON -> clipboard -> DROP_CHAT_JOB_FROM_CLIPBOARD_V1.ps1 -> Child Shell DROPZONE -> watcher -> OUTBOX receipt.

## Local Door

Relay root:

$RelayRoot

Relay helper:

$RelayHelperPath

Child Shell DROPZONE:

$Dropzone

Child Shell OUTBOX:

$Outbox

## Allowed V1 Action

read_command_center_status

## Blocked V1 Powers

No arbitrary shell.
No raw command execution.
No broad crawl.
No delete.
No repo write.
No git write.
No Level 3 package.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No doctrine rewrite.

## How To Use

1. Ask the assistant for an Assistant Door Relay V1 childjob JSON.
2. Copy only the JSON to clipboard.
3. Run:

powershell -ExecutionPolicy Bypass -File "$RelayHelperPath"

4. Paste the relay output back to the assistant.

## Meaning

If the OUTBOX receipt appears, the chat-to-local manual relay works.

This does not prove zero-copy phone-to-PC execution.

For zero-copy phone-to-PC execution, a later Remote Door Relay needs a shared relay surface both chat and the PC watcher can touch.
"@

Write-NewFileStrict -Path $DoorNotePath -Content $DoorNote

$TestJobId = "CHILDJOB-$($UserLocalNow.ToString("yyyyMMdd"))-$($UserLocalNow.ToString("HHmmss"))-ASSISTANT-DOOR-READ-STATUS-TEST"
$TestExpectedReceipt = Join-Path $Outbox "$TestJobId.receipt.txt"

$TestJob = [ordered]@{
    job_id = $TestJobId
    created_at = (Get-Date -Format o)
    requested_by = "ChatGPT_Assistant_Door_Relay_V1_install_test"
    route = "ASSISTANT_DOOR_RELAY_V1_CLIPBOARD_TO_CHILD_SHELL"
    allowed_action = "read_command_center_status"
    target_path = $CommandCenter
    expected_receipt = $TestExpectedReceipt
    boundary = @(
        "manual clipboard relay only",
        "Level 1 read-status only",
        "no overwrite",
        "no delete",
        "no cleanup",
        "no broad crawl",
        "no repo write",
        "no git write",
        "no arbitrary shell",
        "no raw command",
        "no Level 3 save"
    )
    proof_requested = @(
        "OUTBOX receipt path",
        "OUTBOX receipt SHA256"
    )
}

$TestJson = $TestJob | ConvertTo-Json -Depth 20
$TestJobPacketPath = Join-Path $RunDir "$TestJobId.chatjob.json"
Write-NewFileStrict -Path $TestJobPacketPath -Content $TestJson
$TestJobPacketHash = (Get-FileHash -LiteralPath $TestJobPacketPath -Algorithm SHA256).Hash

Set-Clipboard -Value $TestJson

$RelayOutput = ""
$RelayExitCode = 0
try {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $RelayHelperPath *>&1 | ForEach-Object {
        $RelayOutput += ($_ | Out-String)
    }
    $RelayExitCode = $LASTEXITCODE
}
catch {
    $RelayOutput += $_.Exception.Message
    $RelayExitCode = 1
}

if (Test-Path -LiteralPath $TestExpectedReceipt) {
    $TestReceiptPath = $TestExpectedReceipt
    $TestReceiptHash = (Get-FileHash -LiteralPath $TestReceiptPath -Algorithm SHA256).Hash
    $TestVerdict = "PASS / ASSISTANT DOOR RELAY V1 CONSUMED CHILD SHELL JOB"
} else {
    $TestReceiptPath = "[missing]"
    $TestReceiptHash = "[missing]"
    if ($RelayExitCode -eq 2) {
        $TestVerdict = "PARTIAL / JOB DROPPED BUT NO OUTBOX RECEIPT WITHIN WAIT WINDOW"
    } else {
        $TestVerdict = "FAIL / ASSISTANT DOOR RELAY V1 TEST DID NOT PRODUCE RECEIPT"
    }
}

$KeyFiles = @(
    $RelayHelperPath,
    $DoorNotePath,
    (Join-Path $ChildShell "RUNNERS\RUN_CHILD_SHELL_DISPATCH_ONCE.ps1"),
    (Join-Path $ChildShell "RUNNERS\RUN_CHILD_SHELL_LEVEL1_ONCE.ps1"),
    (Join-Path $ChildShell "WATCHER\STATUS_CHILD_SHELL_BRIDGE.ps1"),
    (Join-Path $ChildShell "BRIDGE_CURRENT_STATE.md"),
    (Join-Path $ChildShell "BRIDGE_OPERATOR_GUIDE.md"),
    (Join-Path $Repo "ACTIVE_ANCHOR.txt"),
    (Join-Path $Repo "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md")
)

$KeyReport = foreach ($File in $KeyFiles) {
    if (Test-Path -LiteralPath $File) {
        "FOUND: $File`nSHA256: $((Get-FileHash -LiteralPath $File -Algorithm SHA256).Hash)"
    } else {
        "MISSING: $File"
    }
}

$LaneReport = foreach ($Lane in @("DROPZONE","OUTBOX","REJECTED","PROCESSED","WATCHER","RUNNERS","HELPERS","HOUSE_SAVE_PACKAGES")) {
    $LanePath = Join-Path $ChildShell $Lane
    if (Test-Path -LiteralPath $LanePath) {
        "$Lane : $(@(Get-ChildItem -LiteralPath $LanePath -File -Force -ErrorAction SilentlyContinue).Count) top-level files"
    } else {
        "$Lane : MISSING"
    }
}

$RecentOutbox = "[none]"
if (Test-Path -LiteralPath $Outbox) {
    $RecentOutbox = (Get-ChildItem -LiteralPath $Outbox -File -Force -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 10 FullName, LastWriteTime, Length | Format-List | Out-String).Trim()
    if ([string]::IsNullOrWhiteSpace($RecentOutbox)) { $RecentOutbox = "[none]" }
}

$Journal = @"
# Journal Entry — Assistant Door Relay V1 Install/Test

## Identity

Run ID:

$RunId

Created:

$IsoNow

User local machine time:

$($UserLocalNow.ToString("yyyy-MM-dd HH:mm:ss zzz"))

## Task

Finish the missing chat-to-local intake route enough to test it.

The bridge is already reported complete through bounded Level 3. The unresolved practical gap is that this ChatGPT thread cannot directly write into the Windows Child Shell DROPZONE.

Assistant Door Relay V1 is the smallest clean bridge piece:

ChatGPT output -> clipboard -> local relay helper -> Child Shell DROPZONE -> watcher/runner -> OUTBOX receipt.

## Safety Boundary

No overwrite.
No delete.
No cleanup.
No broad crawl.
No repo write.
No git write.
No arbitrary shell.
No raw command execution.
No Level 3 save package.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No doctrine rewrite.

Only new files/folders under Assistant Door Relay V1 lanes were created, except the Child Shell may move/receipt the new test job through its normal lanes.

## Repo Readback

Repo:

$Repo

HEAD:

$RepoHeadShort

Full HEAD:

$RepoHeadFull

Origin main:

$RepoOriginFull

Status:

$RepoStatusText

## Test Packet

Job ID:

$TestJobId

Packet path:

$TestJobPacketPath

Packet SHA256:

$TestJobPacketHash

## Result

Verdict:

$TestVerdict

Relay helper:

$RelayHelperPath

Relay helper SHA256:

$RelayHelperHash

Receipt path:

$TestReceiptPath

Receipt SHA256:

$TestReceiptHash

Relay output:

$RelayOutput

## Thought Record

This install/test proves the practical handoff route that was missing during the phone-side test. The local bridge could already act once a childjob arrived, but the assistant could not place a job there from chat. Assistant Door Relay V1 does not pretend to solve true zero-copy remote execution. It gives the system a clean door: assistant creates the job, user or later automation puts the job on the local machine, relay validates it, and Child Shell consumes it.

The important win is conceptual clarity. Child Shell does not need more power to be useful. It needs a clean intake boundary. The relay is intentionally narrow because intake is where dirty milk can enter. V1 allows only read_command_center_status. Stronger actions should be added only after separate proof.

## Verdict

$TestVerdict

## Next Clean Step

If PASS, use this as the manual assistant-door relay.

If phone/no-copy use is still desired, design Remote Door Relay V2 separately around a shared relay surface both ChatGPT and the PC can touch.
"@

$Scan = @"
# Deep Scan Summary — Assistant Door Relay V1

## Scan Identity

Run ID:

$RunId

Time:

$IsoNow

## Scope

This scan was bounded.

It checked:
- root presence,
- Mr.Kleen clean state,
- Child Shell core paths,
- Assistant Door Relay install lanes,
- key route file hashes,
- Child Shell lane counts,
- recent OUTBOX evidence,
- one Assistant Door Relay V1 test job.

It did not:
- crawl the whole repo,
- inspect unrelated Desktop folders,
- rewrite Mr.Kleen,
- use git write operations,
- delete/move/clean old evidence,
- run Level 3.

## Diagnosis

Before this relay, the bridge chain existed locally but this chat had no direct write path into Child Shell.

After this relay, the local manual path is:

ChatGPT JSON -> clipboard -> DROP_CHAT_JOB_FROM_CLIPBOARD_V1.ps1 -> DROPZONE -> Child Shell -> OUTBOX receipt.

That is not full remote autonomy, but it is a real working door if the test receipt appears.

## Key Route Files

$($KeyReport -join "`n`n")

## Child Shell Lane Counts

$($LaneReport -join "`n")

## Recent OUTBOX Files

$RecentOutbox

## Test Result

Verdict:

$TestVerdict

Job ID:

$TestJobId

Receipt:

$TestReceiptPath

Receipt SHA256:

$TestReceiptHash

## Boundary Held

No overwrite.
No delete.
No cleanup.
No broad crawl.
No repo write.
No git write.
No arbitrary shell.
No raw command.
No doctrine rewrite.

## Remaining Gap

True phone-to-PC no-copy execution remains blocked until a Remote Door Relay V2 exists.

Remote Door Relay V2 would need a shared relay surface accessible by both:
- ChatGPT side, and
- local PC watcher side.

Assistant Door Relay V1 is the correct local/manual foundation before designing that stronger route.
"@

Write-NewFileStrict -Path $JournalPath -Content $Journal
Write-NewFileStrict -Path $ScanPath -Content $Scan

$JournalHash = Get-HashOrMissing $JournalPath
$ScanHash = Get-HashOrMissing $ScanPath

$InstallReceipt = @"
ASSISTANT DOOR RELAY V1 INSTALL AND TEST RECEIPT

Run ID:
$RunId

Created:
$IsoNow

Verdict:
$TestVerdict

Repo:
$Repo

Repo HEAD:
$RepoHeadShort

Repo full HEAD:
$RepoHeadFull

Repo origin/main:
$RepoOriginFull

Repo status:
$RepoStatusText

Relay root:
$RelayRoot

Relay helper:
$RelayHelperPath

Relay helper SHA256:
$RelayHelperHash

Door note:
$DoorNotePath

Door note SHA256:
$(Get-HashOrMissing $DoorNotePath)

Test job ID:
$TestJobId

Test job packet:
$TestJobPacketPath

Test job packet SHA256:
$TestJobPacketHash

Test receipt:
$TestReceiptPath

Test receipt SHA256:
$TestReceiptHash

Journal:
$JournalPath

Journal SHA256:
$JournalHash

Deep scan:
$ScanPath

Deep scan SHA256:
$ScanHash

Boundary:
No overwrite. No delete. No cleanup. No broad crawl. No repo write. No git write. No arbitrary shell. No raw command. No Level 3 save. No ACTIVE_GUIDES rewrite. No CURRENT_TRUTH_INDEX rewrite. No doctrine rewrite.

Relay output:
$RelayOutput
"@

Write-NewFileStrict -Path $InstallReceiptPath -Content $InstallReceipt
$InstallReceiptHash = Get-HashOrMissing $InstallReceiptPath

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "ASSISTANT DOOR RELAY V1 INSTALL/TEST COMPLETE"
Write-Host "Verdict: $TestVerdict"
Write-Host "Run ID: $RunId"
Write-Host "Repo HEAD: $RepoHeadShort"
Write-Host "Repo origin/main: $RepoOriginFull"
Write-Host "Repo status: $RepoStatusText"
Write-Host "Relay root: $RelayRoot"
Write-Host "Relay helper: $RelayHelperPath"
Write-Host "Relay helper SHA256: $RelayHelperHash"
Write-Host "Door note: $DoorNotePath"
Write-Host "Test job ID: $TestJobId"
Write-Host "Test packet: $TestJobPacketPath"
Write-Host "Test packet SHA256: $TestJobPacketHash"
Write-Host "Test receipt: $TestReceiptPath"
Write-Host "Test receipt SHA256: $TestReceiptHash"
Write-Host "Journal: $JournalPath"
Write-Host "Journal SHA256: $JournalHash"
Write-Host "Deep scan: $ScanPath"
Write-Host "Deep scan SHA256: $ScanHash"
Write-Host "Install receipt: $InstallReceiptPath"
Write-Host "Install receipt SHA256: $InstallReceiptHash"
Write-Host "Boundary: new relay files only; no overwrite; no delete; no cleanup; no broad crawl; no repo write; no git write."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
