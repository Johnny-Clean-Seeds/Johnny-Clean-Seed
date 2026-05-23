$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Stop-Clean {
    param([string]$Message)
    Write-Host "STOP / CLEAN GATE BLOCKED"
    Write-Host $Message
    exit 1
}

function New-DirIfMissing {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Get-HashStrict {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        Stop-Clean "Required proof file missing: $Path"
    }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Assert-Hash {
    param(
        [string]$Path,
        [string]$Expected,
        [string]$Label
    )
    $Actual = Get-HashStrict $Path
    if ($Actual -ne $Expected) {
        Stop-Clean "$Label hash mismatch.`nPath: $Path`nExpected: $Expected`nActual:   $Actual"
    }
    return $Actual
}

function Write-NewStrict {
    param(
        [string]$Path,
        [string]$Content
    )
    if (Test-Path -LiteralPath $Path) {
        Stop-Clean "Refusing to overwrite existing file: $Path"
    }
    $Parent = Split-Path -Parent $Path
    if ($Parent) { New-DirIfMissing $Parent }
    Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
}

$Now = Get-Date
$Stamp = $Now.ToString("yyyyMMdd_HHmmss")
$IsoNow = $Now.ToString("o")
$RunId = "ASSISTANT_DOOR_RELAY_LOCK_SAVE_$Stamp"

$Root123 = Join-Path $env:USERPROFILE "Desktop\123"
$CommandCenter = Join-Path $Root123 "COMMAND_CENTER"
$ChildShell = Join-Path $CommandCenter "CHILD_SHELL"
$RelayRoot = Join-Path $CommandCenter "ASSISTANT_DOOR_RELAY"
$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"

$ExpectedBaseFull = "a678af16ffa8af015cea6814976721bea284cea1"

$HotfixProof = Join-Path $RelayRoot "RECEIPTS\ASSISTANT_DOOR_RELAY_HOTFIX_RECEIPT_20260521_131015.txt"
$HotfixChildReceipt = Join-Path $ChildShell "OUTBOX\CHILDJOB-20260521-131016-ASSISTANT-DOOR-READ-STATUS-HOTFIX.receipt.txt"
$HotfixProcessed = Join-Path $ChildShell "PROCESSED\CHILDJOB-20260521-131016-ASSISTANT-DOOR-READ-STATUS-HOTFIX.childjob.json"

$FreshChildReceipt = Join-Path $ChildShell "OUTBOX\CHILDJOB-20260521-132249-ASSISTANT-DOOR-FRESH-PROBE.receipt.txt"
$FreshProcessed = Join-Path $ChildShell "PROCESSED\CHILDJOB-20260521-132249-ASSISTANT-DOOR-FRESH-PROBE.childjob.json"
$EnsureWatcherReceipt = Join-Path $ChildShell "WATCHER\ENSURE_CHILD_SHELL_WATCHER_LAST_RECEIPT.txt"

if (-not (Test-Path -LiteralPath (Join-Path $Repo ".git"))) {
    Stop-Clean "Mr.Kleen repo missing or not a git repo: $Repo"
}

Push-Location $Repo
try {
    $BaseHeadFull = (git rev-parse HEAD).Trim()
    $BaseHeadShort = (git rev-parse --short HEAD).Trim()
    $BaseOriginFull = (git rev-parse origin/main).Trim()
    $StatusRaw = (git status --short | Out-String).Trim()

    if ($BaseHeadFull -ne $ExpectedBaseFull) {
        Stop-Clean "Unexpected repo HEAD. This lock/save expects a678af1 before writing.`nExpected: $ExpectedBaseFull`nActual:   $BaseHeadFull"
    }

    if ($BaseOriginFull -ne $BaseHeadFull) {
        Stop-Clean "origin/main does not match HEAD before save.`nHEAD:   $BaseHeadFull`nOrigin: $BaseOriginFull"
    }

    if (-not [string]::IsNullOrWhiteSpace($StatusRaw)) {
        Stop-Clean "Repo is not clean before save.`n$StatusRaw"
    }
}
finally {
    Pop-Location
}

$HotfixProofHash = Assert-Hash -Path $HotfixProof -Expected "E9ABAF3F319C5B60A992DFF9CD0BB8F4D031120B2851E009AD4D45BF9740E1EE" -Label "Assistant Door Relay hotfix proof receipt"
$HotfixChildReceiptHash = Assert-Hash -Path $HotfixChildReceipt -Expected "79180819E3B810301D91AF1AAEBD97FFE76459B609BF799F2F8F0BAF8861195E" -Label "Hotfix Child Shell OUTBOX receipt"
if (-not (Test-Path -LiteralPath $HotfixProcessed)) {
    Stop-Clean "Hotfix processed childjob missing: $HotfixProcessed"
}

$FreshReceiptHash = Assert-Hash -Path $FreshChildReceipt -Expected "C5CB57106320141EEB2E1FF79B2DABE56058C0A3160DB935918C814E84722AB5" -Label "Fresh probe Child Shell OUTBOX receipt"
if (-not (Test-Path -LiteralPath $FreshProcessed)) {
    Stop-Clean "Fresh probe processed childjob missing: $FreshProcessed"
}

$EnsureWatcherHash = "[missing/not required]"
if (Test-Path -LiteralPath $EnsureWatcherReceipt) {
    $EnsureWatcherHash = (Get-FileHash -LiteralPath $EnsureWatcherReceipt -Algorithm SHA256).Hash
}

$LearningRel = "BRAIN_LEARNING\ASSISTANT_DOOR_RELAY_LOCAL_MANUAL_INTAKE_RULE_$Stamp.md"
$ReviewRel = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\ASSISTANT_DOOR_RELAY_HOTFIX_FRESH_PROBE_REVIEW_$Stamp.md"
$ReceiptRel = "PROOF_HISTORY\ASSISTANT_DOOR_RELAY_HOTFIX_FRESH_PROBE_LOCK_RECEIPT_$Stamp.txt"
$AnchorRel = "ACTIVE_ANCHOR.txt"
$StatusRel = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$LearningPath = Join-Path $Repo $LearningRel
$ReviewPath = Join-Path $Repo $ReviewRel
$LockReceiptPath = Join-Path $Repo $ReceiptRel
$AnchorPath = Join-Path $Repo $AnchorRel
$StatusPath = Join-Path $Repo $StatusRel

$Learning = @"
# Assistant Door Relay Local Manual Intake Rule

Created: $IsoNow

Run ID: $RunId

## Rule

The bridge is complete through bounded Level 3, but assistant-direct execution from chat remains blocked unless a transport exists.

Assistant Door Relay local manual intake is now a proved narrow bridge surface:

assistant-created job concept -> local PowerShell relay/drop -> Child Shell DROPZONE -> watcher/dispatcher -> OUTBOX receipt.

This proves local manual intake, not zero-copy phone-to-PC execution and not assistant-direct local execution from chat.

## What Passed

Hotfix job:

CHILDJOB-20260521-131016-ASSISTANT-DOOR-READ-STATUS-HOTFIX

Fresh probe job:

CHILDJOB-20260521-132249-ASSISTANT-DOOR-FRESH-PROBE

Both were Level 1 read-status only.

## Boundary

Allowed:

- bounded local manual relay,
- Child Shell DROPZONE intake,
- watcher/dispatcher consumption,
- OUTBOX receipt proof,
- Level 1 read-status probe.

Blocked:

- assistant-direct execution from chat,
- zero-copy phone-to-PC execution,
- arbitrary shell,
- raw command expansion,
- broad crawl,
- delete,
- cleanup,
- repo write through this proof,
- git write through this proof,
- Level 3 save through this proof,
- ACTIVE_GUIDES rewrite,
- CURRENT_TRUTH_INDEX rewrite,
- doctrine rewrite.

## Practical Meaning

The missing piece was not Child Shell capability. Child Shell worked. The missing piece was local intake from assistant output. The manual relay proved a safe local doorway.

Future growth should not widen this door casually. Any stronger remote/zero-copy relay needs separate design, threat boundary, proof, and lock/save.
"@

$Review = @"
# Assistant Door Relay Hotfix + Fresh Probe Proof Review

Created: $IsoNow

Run ID: $RunId

## Starting Repo State

Repo:

$Repo

Base HEAD:

$BaseHeadShort

Base full HEAD:

$BaseHeadFull

Origin main:

$BaseOriginFull

Base status:

clean

## Why This Review Exists

After the mule finished the full bridge through bounded Level 3, the remaining gap was not bridge power. It was the lack of a chat-to-local intake route.

The first Assistant Door Relay V1 installed a relay lane and wrote journal/deep-scan material, but did not produce a Child Shell receipt.

V1B and V1C repair attempts exposed script issues:
- V1B used a native cmd search that failed on "File Not Found";
- V1C used strict mode against a single search result and failed before testing.

The hotfix then bypassed those issues and proved the actual local intake route.

## Proof 1 — Hotfix

Run ID:

ASSISTANT_DOOR_RELAY_HOTFIX_20260521_131015

Job ID:

CHILDJOB-20260521-131016-ASSISTANT-DOOR-READ-STATUS-HOTFIX

Hotfix proof receipt:

$HotfixProof

Hotfix proof receipt SHA256:

$HotfixProofHash

Child Shell OUTBOX receipt:

$HotfixChildReceipt

Child Shell OUTBOX receipt SHA256:

$HotfixChildReceiptHash

Processed childjob:

$HotfixProcessed

Verdict:

PASS / ASSISTANT DOOR RELAY HOTFIX CONSUMED CHILD SHELL JOB

## Proof 2 — Fresh Probe

Job ID:

CHILDJOB-20260521-132249-ASSISTANT-DOOR-FRESH-PROBE

Child Shell OUTBOX receipt:

$FreshChildReceipt

Child Shell OUTBOX receipt SHA256:

$FreshReceiptHash

Processed childjob:

$FreshProcessed

Watcher ensure:

PASS / WATCHER IS RUNNING

Watcher PID:

10380

Watcher action:

KEPT_RUNNING

Watcher receipt:

$EnsureWatcherReceipt

Watcher receipt SHA256:

$EnsureWatcherHash

Verdict:

PASS / fresh assistant-door probe consumed by Child Shell

## Judgment

PASS AS LOCAL MANUAL ASSISTANT-DOOR RELAY.

This does not prove assistant-direct execution from chat.

This does not prove zero-copy phone-to-PC execution.

This does prove that an assistant-shaped bounded job can be placed locally and consumed through Child Shell, leaving receipt evidence.

## Boundary Held

No repo write during the probe tests.

No git write during the probe tests.

No delete.

No cleanup.

No broad crawl.

No arbitrary shell.

No raw command.

No Level 3 save.

No ACTIVE_GUIDES rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No doctrine rewrite.

## Next Clean Step

If zero-copy phone-to-PC use is desired, design Remote Door Relay V2 separately.

Remote Door Relay V2 requires a shared relay surface both sides can touch and must not inherit more power than the local manual relay has proved.
"@

$StatusUpdate = @"

---

## Assistant Door Relay Local Manual Intake Proof — $IsoNow

State: PASS / LOCAL MANUAL ASSISTANT-DOOR RELAY PROVED

Bridge remains complete through bounded Level 3 at base `a678af1`.

New proof added: Assistant Door Relay hotfix and fresh probe proved local manual intake into Child Shell.

Hotfix job: `CHILDJOB-20260521-131016-ASSISTANT-DOOR-READ-STATUS-HOTFIX`
Hotfix receipt SHA256: `$HotfixChildReceiptHash`

Fresh probe job: `CHILDJOB-20260521-132249-ASSISTANT-DOOR-FRESH-PROBE`
Fresh probe receipt SHA256: `$FreshReceiptHash`

Meaning: assistant-created/local-relayed Level 1 read-status jobs can enter Child Shell and produce OUTBOX receipts.

Boundary: this is not assistant-direct execution from chat and not zero-copy phone-to-PC execution. Arbitrary shell, raw command expansion, broad crawl, delete, uncontrolled git, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, and doctrine rewrite remain blocked.
"@

$AnchorUpdate = @"

---

# Active Anchor Update — Assistant Door Relay Local Manual Intake Proof — $IsoNow

Current position before this save:

main @ $BaseHeadShort

Current active fact:

Assistant Door Relay local manual intake is proved by hotfix job `CHILDJOB-20260521-131016-ASSISTANT-DOOR-READ-STATUS-HOTFIX` and fresh probe job `CHILDJOB-20260521-132249-ASSISTANT-DOOR-FRESH-PROBE`.

Clean meaning:

The bridge can now consume a bounded assistant-door local manual relay job through Child Shell and produce an OUTBOX receipt.

Still blocked:

assistant-direct execution from chat, zero-copy phone-to-PC execution, arbitrary shell, raw command expansion, broad crawl, delete, permission expansion, unrestricted repo write, uncontrolled git, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, doctrine rewrite, and junction/symlink teleporter.

Next clean step:

Either stop/pause, or design Remote Door Relay V2 as a separate boss if no-copy phone-to-PC use is desired.
"@

$LockReceipt = @"
ASSISTANT DOOR RELAY HOTFIX + FRESH PROBE LOCK RECEIPT

Created:
$IsoNow

Run ID:
$RunId

Verdict:
PASS / LOCAL MANUAL ASSISTANT-DOOR RELAY PROOF LOCKED

Repo:
$Repo

Base HEAD:
$BaseHeadShort

Base full HEAD:
$BaseHeadFull

Base origin/main:
$BaseOriginFull

Base status:
clean

Hotfix job:
CHILDJOB-20260521-131016-ASSISTANT-DOOR-READ-STATUS-HOTFIX

Hotfix proof receipt:
$HotfixProof

Hotfix proof receipt SHA256:
$HotfixProofHash

Hotfix Child Shell OUTBOX receipt:
$HotfixChildReceipt

Hotfix Child Shell OUTBOX receipt SHA256:
$HotfixChildReceiptHash

Hotfix processed childjob:
$HotfixProcessed

Fresh probe job:
CHILDJOB-20260521-132249-ASSISTANT-DOOR-FRESH-PROBE

Fresh probe OUTBOX receipt:
$FreshChildReceipt

Fresh probe OUTBOX receipt SHA256:
$FreshReceiptHash

Fresh probe processed childjob:
$FreshProcessed

Watcher ensure receipt:
$EnsureWatcherReceipt

Watcher ensure receipt SHA256:
$EnsureWatcherHash

Files created in Mr.Kleen:
$LearningRel
$ReviewRel
$ReceiptRel

Files updated in Mr.Kleen:
$AnchorRel
$StatusRel

Boundary:
No bridge power expansion. No arbitrary shell. No raw command. No broad crawl. No delete. No cleanup. No ACTIVE_GUIDES rewrite. No CURRENT_TRUTH_INDEX rewrite. No doctrine rewrite. This lock/save records local manual assistant-door relay proof only.

Meaning:
Local manual assistant-door relay passed. Assistant-direct chat execution and zero-copy phone-to-PC execution remain separate unsolved bosses.
"@

Write-NewStrict -Path $LearningPath -Content $Learning
Write-NewStrict -Path $ReviewPath -Content $Review
Write-NewStrict -Path $LockReceiptPath -Content $LockReceipt

Add-Content -LiteralPath $AnchorPath -Value $AnchorUpdate -Encoding UTF8
Add-Content -LiteralPath $StatusPath -Value $StatusUpdate -Encoding UTF8

$LearningHash = Get-HashStrict $LearningPath
$ReviewHash = Get-HashStrict $ReviewPath
$LockReceiptHash = Get-HashStrict $LockReceiptPath

Push-Location $Repo
try {
    git add -- $LearningRel $ReviewRel $AnchorRel $StatusRel
    git add -f -- $ReceiptRel

    $Staged = (git diff --cached --name-status | Out-String).Trim()
    if ([string]::IsNullOrWhiteSpace($Staged)) {
        Stop-Clean "Nothing staged; lock/save would be empty."
    }

    git commit -m "Lock assistant door relay proof"

    $CommitShort = (git rev-parse --short HEAD).Trim()
    $CommitFull = (git rev-parse HEAD).Trim()

    git push origin main

    $FinalOriginFull = (git rev-parse origin/main).Trim()
    $FinalStatusRaw = (git status --short | Out-String).Trim()
    if ($FinalOriginFull -ne $CommitFull) {
        Stop-Clean "Push verification failed. origin/main does not match HEAD.`nHEAD: $CommitFull`nOrigin: $FinalOriginFull"
    }
    if (-not [string]::IsNullOrWhiteSpace($FinalStatusRaw)) {
        Stop-Clean "Final repo status is not clean.`n$FinalStatusRaw"
    }
}
finally {
    Pop-Location
}

Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "ASSISTANT DOOR RELAY PROOF LOCK/SAVE COMPLETE"
Write-Host "Verdict: PASS / LOCAL MANUAL ASSISTANT-DOOR RELAY PROOF LOCKED"
Write-Host "Run ID: $RunId"
Write-Host "Base HEAD: $BaseHeadShort"
Write-Host "Commit: $CommitShort"
Write-Host "Commit full: $CommitFull"
Write-Host "Origin main: $FinalOriginFull"
Write-Host "Final status: clean"
Write-Host "Learning file: $LearningRel"
Write-Host "Learning SHA256: $LearningHash"
Write-Host "Review file: $ReviewRel"
Write-Host "Review SHA256: $ReviewHash"
Write-Host "Lock receipt: $ReceiptRel"
Write-Host "Lock receipt SHA256: $LockReceiptHash"
Write-Host "Hotfix receipt SHA256: $HotfixChildReceiptHash"
Write-Host "Fresh probe receipt SHA256: $FreshReceiptHash"
Write-Host "Boundary: local manual relay proof only; no bridge power expansion; assistant-direct and zero-copy remote execution still blocked."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
