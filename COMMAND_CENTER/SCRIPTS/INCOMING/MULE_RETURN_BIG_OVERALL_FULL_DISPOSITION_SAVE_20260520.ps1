$ErrorActionPreference = "Stop"

function Invoke-GitChecked {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $Output = @(& git @Args 2>&1)
    if ($LASTEXITCODE -ne 0) {
        $Output | ForEach-Object { Write-Host $_ }
        throw ("Git failed: git " + ($Args -join " "))
    }
    return $Output
}

function Get-GitLine {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    $Output = @(Invoke-GitChecked @Args)
    if ($Output.Count -lt 1) {
        throw ("Git returned no output: git " + ($Args -join " "))
    }
    return ([string]($Output | Select-Object -First 1)).Trim()
}

function Write-Utf8Text {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Text
    )
    $Parent = Split-Path -Parent $Path
    if ($Parent -and -not (Test-Path -LiteralPath $Parent)) {
        New-Item -ItemType Directory -Path $Parent -Force | Out-Null
    }
    Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($Raw)) { throw ("Wrote empty file: " + $Path) }
    if ($Raw.Contains([char]0)) { throw ("NUL byte found after write: " + $Path) }
    if ($Raw.Contains([char]0xFFFD)) { throw ("Replacement character found after write: " + $Path) }
}

function Append-IfMissing {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Needle,
        [Parameter(Mandatory = $true)][string]$Text
    )
    if (-not (Test-Path -LiteralPath $Path)) {
        Write-Utf8Text -Path $Path -Text $Text
        return
    }
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if (-not $Raw.Contains($Needle)) {
        Add-Content -LiteralPath $Path -Value $Text -Encoding UTF8
    }
}

function Assert-Needle {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Needle
    )
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if (-not $Raw.Contains($Needle)) {
        throw ("Verification needle missing in " + $Path + ": " + $Needle)
    }
}

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not inside Mr.Kleen repo home. Open Mr.Kleen first."
}

$Repo = (Get-Location).Path

Write-Host "XxXxX ===== MULE RETURN FULL DISPOSITION SAVE START ===== XxXxX"

Invoke-GitChecked fetch origin main | Out-Null

$Branch = Get-GitLine branch --show-current
$BaseHead = Get-GitLine rev-parse HEAD
$Origin = Get-GitLine rev-parse origin/main
$BaseShort = Get-GitLine rev-parse --short HEAD
$Status = @(Invoke-GitChecked status --short)

if ($Branch -ne "main") { throw ("Wrong branch: " + $Branch) }
if ($BaseHead -ne $Origin) { throw "HEAD does not match origin/main. Stop before save." }
if ($Status.Count -ne 0) {
    Write-Host "Dirty status:"
    $Status | ForEach-Object { Write-Host $_ }
    throw "Repo is dirty. Stop before save."
}

$ExpectedBase = "381c2ee383aba11517492768c68b6c4ae0c452ee"
if ($BaseHead -ne $ExpectedBase) {
    throw ("Base HEAD changed. Expected " + $ExpectedBase + " but found " + $BaseHead + ". Stop and reassess.")
}

$ReturnLane = "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\BIG_OVERALL_JOB_20260520_051710_RETURN_INTAKE_20260520_054120"
$Dump = Join-Path $ReturnLane "RAW_RETURN_DUMP"
$Context = Join-Path $ReturnLane "RAW_PACKET_CONTEXT"

$RequiredFiles = @(
    (Join-Path $ReturnLane "INTAKE_REPORT.md"),
    (Join-Path $ReturnLane "INITIAL_DISPOSITION_MATRIX.md"),
    (Join-Path $Dump "DISPOSITION_MATRIX.md"),
    (Join-Path $Dump "EXECUTIVE_SUMMARY.md"),
    (Join-Path $Dump "JOB_00_STALE_CHECKER_REVIEW.md"),
    (Join-Path $Dump "JOB_01_WHOLE_HOUSE_DRIFT_AND_META_LOOP_AUDIT.md"),
    (Join-Path $Dump "JOB_02_REAL_WORK_QUEUE_TOP_10.md"),
    (Join-Path $Dump "JOB_03_TODO_ROOM_BOSS_GHOST_COLLAPSE.md"),
    (Join-Path $Dump "JOB_04_TOOL_SUIT_RULE_LIFECYCLE_AUDIT.md"),
    (Join-Path $Dump "JOB_05_MULE_WORKSHOP_CONTRACT_UPGRADE.md"),
    (Join-Path $Dump "JOB_06_RECEIPT_AND_STALE_PROOF_HYGIENE.md"),
    (Join-Path $Dump "JOB_07_BIG_OVERALL_RECOMMENDATION.md"),
    (Join-Path $Dump "MANIFEST_RETURN.md"),
    (Join-Path $Dump "NEXT_ACTION_RECOMMENDATION.md"),
    (Join-Path $Dump "README_OUTPUT_DUMP_ONLY.md"),
    (Join-Path $Dump "RETURN_MANIFEST_TEMPLATE.md"),
    (Join-Path $Dump "STALE_CHECK_RESULT_20260520_051938.txt"),
    (Join-Path $Dump "STALE_CHECK_RESULT_20260520_054119.txt"),
    (Join-Path $Dump "STALE_CHECK_RESULT_SUMMARY.md"),
    (Join-Path $Context "MANIFEST.md")
)

foreach ($Path in $RequiredFiles) {
    if (-not (Test-Path -LiteralPath $Path)) { throw ("Required mule return file missing: " + $Path) }
    $Raw = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($Raw)) { throw ("Required mule return file empty: " + $Path) }
    if ($Raw.Contains([char]0)) { throw ("NUL byte in mule return file: " + $Path) }
    if ($Raw.Contains([char]0xFFFD)) { throw ("Replacement character in mule return file: " + $Path) }
}

Assert-Needle -Path (Join-Path $Dump "STALE_CHECK_RESULT_20260520_051938.txt") -Needle "RESULT: PASS"
Assert-Needle -Path (Join-Path $Dump "STALE_CHECK_RESULT_20260520_054119.txt") -Needle "RESULT: STALE/BLOCKED"
Assert-Needle -Path (Join-Path $Dump "JOB_07_BIG_OVERALL_RECOMMENDATION.md") -Needle "No save is justified by this mule output alone"
Assert-Needle -Path (Join-Path $Dump "NEXT_ACTION_RECOMMENDATION.md") -Needle "APPLY AS NEXT READ TARGET ONLY"

$RceTodoPath = "HOUSE_WORK\TODO\RULE_CONCEPT_EVENT_LINK_MAP_AND_REPORT_GATE_LIVE_USE_TODO_20260520.md"
$AnchorPath = "ACTIVE_ANCHOR.txt"
$StatusPath = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
$RcePath = "HOUSE_WORK\WORK_SHED\RELATION_MAPS\RULE_CONCEPT_EVENT_LINK_MAP_SEED_20260520.md"
$ProofPath = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\MULE_RETURN_BIG_OVERALL_FULL_DISPOSITION_20260520.md"
$ReturnDispositionPath = Join-Path $ReturnLane "FULL_DISPOSITION_AFTER_READ_20260520.md"
$ReceiptPath = "PROOF_HISTORY\MULE_RETURN_BIG_OVERALL_FULL_DISPOSITION_RECEIPT_20260520.txt"

foreach ($Path in @($RceTodoPath,$AnchorPath,$StatusPath,$RcePath)) {
    if (-not (Test-Path -LiteralPath $Path)) { throw ("Required house file missing: " + $Path) }
}

$Disposition = @'
# Mule Return Big Overall - Full Disposition After Read

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / MULE_WORKSHOP / RETURNS
Status: full intake disposition / no adoption
Base HEAD before save: 381c2ee383aba11517492768c68b6c4ae0c452ee
Authority: custody/disposition only; not command authority

## What happened

The mule return had already been imported into brain custody.

The remaining job outputs were then read in manifest/job order:

- STALE_CHECK_RESULT_20260520_051938.txt
- STALE_CHECK_RESULT_20260520_054119.txt
- JOB_00_STALE_CHECKER_REVIEW.md
- JOB_01_WHOLE_HOUSE_DRIFT_AND_META_LOOP_AUDIT.md
- JOB_02_REAL_WORK_QUEUE_TOP_10.md
- JOB_03_TODO_ROOM_BOSS_GHOST_COLLAPSE.md
- JOB_04_TOOL_SUIT_RULE_LIFECYCLE_AUDIT.md
- JOB_05_MULE_WORKSHOP_CONTRACT_UPGRADE.md
- JOB_06_RECEIPT_AND_STALE_PROOF_HYGIENE.md

Earlier read already covered:

- INTAKE_REPORT.md
- INITIAL_DISPOSITION_MATRIX.md
- DISPOSITION_MATRIX.md
- EXECUTIVE_SUMMARY.md
- JOB_07_BIG_OVERALL_RECOMMENDATION.md
- MANIFEST_RETURN.md
- NEXT_ACTION_RECOMMENDATION.md
- README_OUTPUT_DUMP_ONLY.md
- RETURN_MANIFEST_TEMPLATE.md
- STALE_CHECK_RESULT_SUMMARY.md
- packet manifest/context files.

## Stale/custody judgment

The mule packet passed stale check at packet time against:

e9bc566bb432817f266e6604595172f5e95afb21

A later stale check showed:

RESULT: STALE/BLOCKED

because current HEAD had advanced to:

fe54daee837b79210ca1ba07dca57b6ee4ead280

Current save base is now:

381c2ee383aba11517492768c68b6c4ae0c452ee

Meaning:
The mule return is valid custody/source evidence and useful support, but it is not current command authority.

## Final disposition matrix

| Return item | Final disposition | Reason | Current handling |
|---|---|---|---|
| INTAKE_REPORT.md | APPLY AS CUSTODY RECORD | Documents known-path import and recovery. | Keep as return-custody proof. |
| INITIAL_DISPOSITION_MATRIX.md | SUPERSEDED BY THIS DISPOSITION | Initial matrix said NEEDS READING. Reading is now complete. | Keep for history; use this file as current intake disposition. |
| DISPOSITION_MATRIX.md | APPLY AS SUPPORT | Consolidates mule findings and dispositions. | Use as outside-worker evidence only. |
| EXECUTIVE_SUMMARY.md | APPLY AS SUPPORT | Correctly says house should avoid meta-loop and use Boss/Ghost / selector. | Already partly consumed; do not treat as current command. |
| STALE_CHECK_RESULT_20260520_051938.txt | APPLY AS PACKET-TIME PROOF | Shows packet was fresh at first mule run. | Packet-time evidence only. |
| STALE_CHECK_RESULT_20260520_054119.txt | APPLY AS CURRENT-BOUNDARY WARNING | Shows packet became stale after repo moved. | Blocks command-authority use. |
| STALE_CHECK_RESULT_SUMMARY.md | APPLY AS STALE SUMMARY | Human-readable stale proof limit. | Keep with packet evidence. |
| JOB_00_STALE_CHECKER_REVIEW.md | ADAPT LATER | Strong checker; V2 packet hash/self-integrity candidate is useful. | Park until next mule packet; no checker promotion now. |
| JOB_01_WHOLE_HOUSE_DRIFT_AND_META_LOOP_AUDIT.md | APPLY AS SUPPORT | Correctly warns against meta-loop and says use supports to drive one real route. | Continue as support; no broad review. |
| JOB_02_REAL_WORK_QUEUE_TOP_10.md | APPLY AS QUEUE SUPPORT | Proof-ranked queue was useful but not command authority. | Use only against current anchor/status. |
| JOB_03_TODO_ROOM_BOSS_GHOST_COLLAPSE.md | APPLY AS TODO SUPPORT | Good parent-boss matrix; no TODO edits directly. | Use by trigger; no rewrite. |
| JOB_04_TOOL_SUIT_RULE_LIFECYCLE_AUDIT.md | APPLY AS LIFECYCLE SUPPORT | Correctly says unload map is retrieval/disposition, not promotion queue. | Use at point of work; no promotion. |
| JOB_05_MULE_WORKSHOP_CONTRACT_UPGRADE.md | ADAPT LATER | V2 local-only mule contract candidate is useful. | Park until next packet build. |
| JOB_06_RECEIPT_AND_STALE_PROOF_HYGIENE.md | APPLY AS PROOF HYGIENE SUPPORT | Correctly warns receipts are claim-scoped and stale-sensitive. | Use in future receipt claims. |
| JOB_07_BIG_OVERALL_RECOMMENDATION.md | APPLY AS OUTSIDE-WORKER SUPPORT | Correctly recommended Boss/Ghost first read and no save from mule output alone. | Already consumed and superseded by later house proofs. |
| NEXT_ACTION_RECOMMENDATION.md | APPLY AS NEXT-READ SUPPORT ONLY | The exact read target was followed earlier. | Satisfied; not a current command. |
| MANIFEST_RETURN.md | APPLY AS RETURN MANIFEST | Lists files, disposition, and no-repo-edit boundary. | Keep as custody manifest. |
| README_OUTPUT_DUMP_ONLY.md | PACKET SUPPORT | Defines dump-only boundary. | Keep as context. |
| RETURN_MANIFEST_TEMPLATE.md | PACKET SUPPORT | Template only. | Keep as context. |
| RAW_PACKET_CONTEXT | CUSTODY CONTEXT | Packet jobs/snapshots explain original mule task. | Keep as historical packet context. |

## APPLY

- keep known-path mule import rule;
- keep dump-only local mule method;
- use stale/custody checks before applying mule outputs;
- use receipt proof limits;
- use Boss/Ghost / selector evidence only through current anchor.

## ADAPT LATER

- packet self-hash verification;
- deterministic latest stale result;
- V2 mule packet skeleton;
- stricter output manifest/return intake checks.

These are not active now.

## PARK

- new mule pass by inertia;
- mule dashboard;
- runtime/automation;
- broad mule workshop framework;
- packet V2 until next actual mule packet.

## REJECT

- adopting mule output as command authority;
- editing repo files directly from mule output;
- treating packet-time PASS as current PASS;
- treating first/second live-use proof as promotion;
- starting broad meta-review from this return.

## NEEDS PROOF

- next mule packet, if any, should prove V2 stale/self-integrity candidate.
- future receipt claims should state same-line proof limits.
- future TODO selection should keep using current anchor and proof-ranked route, not newest-file order.

## RCE / report gate effect

The mule-return intake proof requirement is now PASS as intake/disposition proof.

The broader RCE / Report Gate TODO remains PASS / PARTIAL because the full report gate is still open.

## Boundary

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No knowledge graph.

No full lesson index.

No promotion.

No mule output adoption.
'@

$Proof = @'
# Mule Return Big Overall - Full Disposition Proof

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: full intake proof / no adoption
Base HEAD before save: 381c2ee383aba11517492768c68b6c4ae0c452ee
Authority: proof/disposition only

## Rule-Firing Confirmation Card use

State:
main @ 381c2ee, clean by last proof.

Intended action:
save full disposition proof for imported mule return after remaining job outputs were read.

Fired gate:
Rule-Firing Confirmation Before Action Gate.

Why it fired:
Mule-return intake and disposition is a nontrivial Mr.Kleen house-touching action.

Blocked:
no adoption, no promotion, no doctrine, no active guide, no CURRENT_TRUTH_INDEX, no dashboard, no automation, no runtime, no knowledge graph, no full lesson index, no mule pass by inertia.

Proof needed:
files read/dispositioned, receipt, commit, push, final clean state.

Disposition:
save full intake/disposition proof only.

## What this proof closes

This closes the open mule-return intake disposition for the Big Overall Job return.

The return was imported, manifest/custody material was read, job outputs were read, stale/custody signals were read, and every returned item now has a final disposition.

## What this proof does not close

It does not close:
- Full report gate;
- RCE / Report Gate as a whole;
- Artifact Self-Check;
- No Rule King;
- Relevant Root Key Selector;
- Habit / MAA;
- future mule packet V2 candidate.

## Main judgment

The mule return is useful support evidence, not command authority.

The strongest recommendation was already consumed through later house work:
Boss/Ghost read, selector use, No Rule King guard, RCE partial proof, and rule-firing confirmation proof.

The return is now safe to park as fully intaken/dispositioned.

## Boundary

No doctrine rewrite.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No knowledge graph.

No full lesson index.

No promotion.

No mule output adoption.
'@

$RceTodo = @'
# TODO - Rule-Concept-Event Link Map And Report Gate Live Use

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Status: partial live-use proof recorded / still open
Parent Boss: Rule Activation / Work-Order Control
Related Boss: Memory Health / Placement-Keying / Good Fog Compression

## Purpose

Prove that the discussion save becomes action, not another stored-but-unfired rule.

## Partial live use recorded

Date: 2026-05-20

Proof:
HOUSE_WORK\WORK_SHED\SORTING_BENCH\RULE_CONCEPT_EVENT_REPORT_GATE_PARTIAL_LIVE_USE_PROOF_20260520.md

Receipt:
PROOF_HISTORY\RULE_CONCEPT_EVENT_REPORT_GATE_PARTIAL_LIVE_USE_RECEIPT_20260520.txt

Verdict:
PASS / PARTIAL.

Passed:
- Rule-not-fired alarm live use.
- Rule-Concept-Event map live use.
- Mule return intake/disposition proof for Big Overall Job return.

Still open:
- Full report gate.
- More varied proof before any promotion.

## Required live uses

### 1. Full report gate

Next time user asks for house walk / feel report / full report / step back / do the report right:

- run raw feel pass;
- pause/check control state, drift, custody, proof, and blocked moves;
- rewrite final report;
- do not push commands unless the report proves a command is needed.

Status:
OPEN / NOT TRIGGERED BY THIS EVENT.

### 2. Rule-not-fired alarm

Status:
PASS AS FIRST LIVE USE.

### 3. Rule-Concept-Event map

Status:
PASS AS FIRST LIVE USE.

### 4. Mule return intake

Status:
PASS AS INTAKE/DISPOSITION PROOF FOR BIG OVERALL JOB RETURN.

Proof:
HOUSE_WORK\WORK_SHED\SORTING_BENCH\MULE_RETURN_BIG_OVERALL_FULL_DISPOSITION_20260520.md

Receipt:
PROOF_HISTORY\MULE_RETURN_BIG_OVERALL_FULL_DISPOSITION_RECEIPT_20260520.txt

Boundary:
This pass means the return was fully read and dispositioned. It does not mean mule outputs were adopted as command authority.

## Not allowed

- Do not promote this TODO to active guide.
- Do not build dashboard or knowledge graph from this TODO alone.
- Do not rewrite CURRENT_TRUTH_INDEX.
- Do not use this TODO as command authority.
- Do not close this TODO while full report gate remains open.
'@

$RceAppend = @'

## Entry 18 - Mule Return Big Overall Full Disposition

Rule:
Mule return output must be read, stale/custody checked, and dispositioned item-by-item before adoption or parking.

Concept:
Worker custody; outside output as support evidence; stale proof boundary; no mule command authority.

Event:
The Big Overall Job mule return was imported into brain custody, then manifest/index files and remaining JOB_00 through JOB_06 outputs were read. The final disposition applied, adapted, parked, rejected, or marked needs-proof for each return item without adopting mule output as command authority.

Trigger phrases:
mule return; full disposition; stale check; known path; outside worker; output is support only.

Proof state:
Full intake/disposition proof saved for this mule return. No adoption or promotion.

Boundary:
Not doctrine, not active guide, not dashboard, not automation.
'@

$Anchor = @'
# ACTIVE ANCHOR

Date: 2026-05-20
Current active ball after this save: Route selection under Rule-Firing Confirmation Card

## Last completed move

Saved full intake/disposition proof for the Big Overall Job mule return.

Verdict:
PASS as mule-return intake/disposition proof.

Meaning:
The mule return was fully read and dispositioned. It is now safe to use as parked support evidence. It is not command authority.

## Current control state

Rule-Firing Confirmation Card remains active before nontrivial Mr.Kleen house-touching action.

Relevant Root Key / Tool Use Selector remains support-only.

Habit / MAA lens remains support-only.

RCE / Report Gate TODO remains PASS / PARTIAL because full report gate is still open.

No Rule King remains open as guard.

Big Overall Job mule return is fully intaken/dispositioned and parked as support evidence.

No item is promoted.

## Next allowed move

Return to route selection under the Rule-Firing Confirmation Card.

Select one route by current anchor/status and active proof need, not newest-file pressure.

Use Habit / MAA only when repeated pattern or transfer decision appears.

Use No Rule King whenever a rule, card, selector, suit, tool, TODO, map, or mule output risks becoming king.

## Blocked moves

- Do not run another mule pass by inertia.
- Do not adopt mule output as command authority.
- Do not promote the selector from varied proof.
- Do not promote No Rule King from partial proof.
- Do not promote RCE map/report gate from partial proof.
- Do not promote the card from limited proof.
- Do not promote Habit/MAA from limited proof.
- Do not create dashboard, automation, runtime, knowledge graph, or full lesson index.
- Do not rewrite doctrine.
- Do not rewrite active guides.
- Do not rewrite CURRENT_TRUTH_INDEX.
'@

Write-Utf8Text -Path $ReturnDispositionPath -Text $Disposition
Write-Utf8Text -Path $ProofPath -Text $Proof
Write-Utf8Text -Path $RceTodoPath -Text $RceTodo
Append-IfMissing -Path $RcePath -Needle "Entry 18 - Mule Return Big Overall Full Disposition" -Text $RceAppend
Write-Utf8Text -Path $AnchorPath -Text $Anchor

$StatusAppend = @"

---

## 2026-05-20 - Mule return Big Overall full disposition

Base before save: $BaseHead
Base short: $BaseShort
Status before save: clean

Saved:
- $ReturnDispositionPath
- $ProofPath
- updated $RceTodoPath
- appended entry to $RcePath
- updated $AnchorPath
- updated this status file

Verdict:
PASS as full mule-return intake/disposition proof.

Meaning:
The Big Overall Job mule return is now fully read and dispositioned. It is useful support evidence but not command authority. Packet-time PASS is preserved as packet evidence; later STALE/BLOCKED result and current HEAD movement block blind adoption.

Boundary:
No doctrine rewrite, no active guide rewrite, no CURRENT_TRUTH_INDEX rewrite, no dashboard, no automation, no runtime, no knowledge graph, no full lesson index, no promotion, and no mule output adoption.

Next:
Return to route selection under Rule-Firing Confirmation Card.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

Assert-Needle -Path $ReturnDispositionPath -Needle "full intake disposition / no adoption"
Assert-Needle -Path $ProofPath -Needle "full intake proof / no adoption"
Assert-Needle -Path $RceTodoPath -Needle "Mule return intake/disposition proof for Big Overall Job return"
Assert-Needle -Path $RcePath -Needle "Entry 18 - Mule Return Big Overall Full Disposition"
Assert-Needle -Path $AnchorPath -Needle "Big Overall Job mule return is fully intaken/dispositioned"
Assert-Needle -Path $StatusPath -Needle "Mule return Big Overall full disposition"

$HashTargets = @(
    $ReturnDispositionPath,
    $ProofPath,
    $RceTodoPath,
    $RcePath,
    $AnchorPath,
    $StatusPath
)

$HashLines = New-Object System.Collections.Generic.List[string]
foreach ($Path in $HashTargets) {
    $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
    $HashLines.Add("- " + $Path + " | sha256=" + $Hash) | Out-Null
}

$Receipt = @"
MULE RETURN BIG OVERALL FULL DISPOSITION RECEIPT
Date: 2026-05-20
Repo: $Repo
Base HEAD: $BaseHead
Base short: $BaseShort
origin/main: $Origin
Status before save: clean

Rule-Firing Confirmation Card used before this save:
- State: clean at 381c2ee.
- Intended action: save full disposition proof for imported mule return after remaining job outputs were read.
- Fired gate: Rule-Firing Confirmation Before Action Gate.
- Why it fired: mule-return disposition is a nontrivial Mr.Kleen house-touching action.
- Blocked: adoption, promotion, doctrine, active guide, CURRENT_TRUTH_INDEX, dashboard, automation, runtime, knowledge graph, full lesson index, mule pass by inertia.
- Proof needed: files read/dispositioned, receipt, commit, push, final clean state.
- Disposition: save full intake/disposition proof only.

Saved:
- $ReturnDispositionPath
- $ProofPath
- $RceTodoPath
- $RcePath
- $AnchorPath
- $StatusPath

Verdict:
PASS as full mule-return intake/disposition proof.

Key boundary:
Mule output is useful support evidence, not command authority.

Hashes:
$($HashLines -join [Environment]::NewLine)

Boundary held:
- no doctrine rewrite;
- no active guide rewrite;
- no CURRENT_TRUTH_INDEX rewrite;
- no dashboard;
- no automation;
- no runtime;
- no knowledge graph;
- no full lesson index;
- no promotion;
- no mule output adoption.

Next move:
Return to route selection under Rule-Firing Confirmation Card.
"@

Write-Utf8Text -Path $ReceiptPath -Text $Receipt
Assert-Needle -Path $ReceiptPath -Needle "PASS as full mule-return intake/disposition proof"

$Dirty = @(Invoke-GitChecked status --short)
if ($Dirty.Count -eq 0) { throw "No changes detected after writing mule disposition package." }

Invoke-GitChecked add -- $ReturnDispositionPath $ProofPath $RceTodoPath $RcePath $AnchorPath $StatusPath | Out-Null
Invoke-GitChecked add -f -- $ReceiptPath | Out-Null

$Staged = @(Invoke-GitChecked diff --cached --name-only)
if ($Staged.Count -eq 0) { throw "No staged files before commit." }

Invoke-GitChecked commit -m "Disposition big overall mule return" | Out-Null
Invoke-GitChecked push origin main | Out-Null
Invoke-GitChecked fetch origin main | Out-Null

$FinalHead = Get-GitLine rev-parse HEAD
$FinalOrigin = Get-GitLine rev-parse origin/main
$FinalShort = Get-GitLine rev-parse --short HEAD
$FinalStatus = @(Invoke-GitChecked status --short)

if ($FinalHead -ne $FinalOrigin) { throw "Final proof failed: HEAD does not match origin/main." }
if ($FinalStatus.Count -ne 0) {
    Write-Host "Final dirty status:"
    $FinalStatus | ForEach-Object { Write-Host $_ }
    throw "Final proof failed: status not clean."
}

Write-Host ""
Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX"
Write-Host "MULE RETURN BIG OVERALL FULL DISPOSITION SAVED"
Write-Host ("Commit: " + $FinalShort)
Write-Host ("HEAD: " + $FinalHead)
Write-Host ("origin/main: " + $FinalOrigin)
Write-Host "Status: clean"
Write-Host ""
Write-Host "Saved:"
Write-Host ("- " + $ReturnDispositionPath)
Write-Host ("- " + $ProofPath)
Write-Host ("- " + $ReceiptPath)
Write-Host ""
Write-Host "Updated:"
Write-Host ("- " + $RceTodoPath)
Write-Host ("- " + $RcePath)
Write-Host ("- " + $AnchorPath)
Write-Host ("- " + $StatusPath)
Write-Host ""
Write-Host "Verdict:"
Write-Host "- PASS: Big Overall mule return fully read and dispositioned."
Write-Host "- PASS: Mule-return intake/disposition proof satisfied for this return."
Write-Host "- PASS: mule output kept as support evidence, not command authority."
Write-Host ""
Write-Host "Boundary:"
Write-Host "- No doctrine rewrite."
Write-Host "- No active guide rewrite."
Write-Host "- No CURRENT_TRUTH_INDEX rewrite."
Write-Host "- No dashboard, automation, runtime, knowledge graph, or full lesson index."
Write-Host "- No promotion."
Write-Host "- No mule output adoption."
Write-Host ""
Write-Host "Next move:"
Write-Host "- Return to route selection under Rule-Firing Confirmation Card."
Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX"
