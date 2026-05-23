$ErrorActionPreference = "Stop"

$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"

$DropFileName = "CHAT_DROP_COPY__CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
$DesktopDrop = Join-Path $env:USERPROFILE "Desktop\$DropFileName"
$Desktop123Drop = Join-Path $env:USERPROFILE "Desktop\123\$DropFileName"

if (-not (Test-Path -LiteralPath $Repo)) {
    throw "Repo not found: $Repo"
}

Set-Location -LiteralPath $Repo

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not in a git repo: $Repo"
}

$DirtyBefore = git status --short
if ($DirtyBefore) {
    Write-Host "BLOCKED - REPO NOT CLEAN"
    Write-Host "Dirty status before save:"
    $DirtyBefore | ForEach-Object { Write-Host $_ }
    exit 1
}

$OldHead = (git rev-parse HEAD).Trim()

$RulePath = "BRAIN_LEARNING/MULTI_RULE_BATCH_COMPATIBILITY_APPLY_GATE_20260522.md"
$CapturePath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/MULTI_RULE_BATCH_COMPATIBILITY_APPLY_GATE_CAPTURE_20260522.md"
$MatrixPath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/MULTI_RULE_BATCH_COMPATIBILITY_MATRIX_RECENT_RULES_20260522.md"
$CockpitPath = "HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
$ReceiptPath = "PROOF_HISTORY/MULTI_RULE_BATCH_COMPATIBILITY_APPLY_GATE_RECEIPT_20260522.txt"
$StatusPath = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"

foreach ($p in @($RulePath,$CapturePath,$MatrixPath,$CockpitPath,$ReceiptPath,$StatusPath)) {
    $dir = Split-Path $p
    if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
}
New-Item -ItemType Directory -Force -Path (Split-Path $Desktop123Drop) | Out-Null

$Rule = @"
# Multi-Rule Batch Compatibility Apply Gate — 20260522

## Status

Type: brain-learning / batch-rule installation gate.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not automation.
- This does not force multiple rules to install if they conflict.
- This does not replace individual proof receipts.
- This does not override source custody, save-routing, or safety gates.

## Core Rule

When the assistant creates or installs several rules together, it must run those rules against each other before saving or as part of the save.

Do not merely bundle several rules and commit them.

A batch rule save needs a compatibility/apply gate.

## Trigger

This gate fires when:

- two or more rules are being created at once;
- a rule bundle includes several captures;
- a new rule modifies how other recent rules should behave;
- a cockpit update adds several sections;
- a save script installs multiple project files with rule effect;
- the assistant notices a rule may affect another rule;
- the user says apply, compare, make sure they obey each other, or similar.

## Required Checks

For every multi-rule batch, check:

1. Scope compatibility.
2. Authority compatibility.
3. Local + URL versus local-only routing.
4. Desktop drop naming versus internal house naming.
5. No-parking / fit-decision routing.
6. Cockpit/drop-copy update requirement.
7. Source custody / no source gets throne.
8. Proof receipt coverage.
9. Final Judge Gate role.
10. Switching-gears/context reset if the work changed lanes.
11. Porch/drop event trigger if files/packages are dropped.
12. Blocked promotion boundaries.
13. Whether any rule creates an exception to another rule.
14. Whether the exception is explicit, named, and bounded.

## Required Output

A batch save must include one of these:

- compatibility matrix;
- apply-gate receipt section;
- cross-check table;
- explicit fit/conflict/refine/block list.

The output must judge each involved rule as:

- FITS;
- FITS WITH BOUNDED EXCEPTION;
- NEEDS REFINEMENT;
- CONFLICTS;
- BLOCKED;
- PARK WITH RETURN TRIGGER.

## Compatibility Matrix Minimum Fields

A clean matrix should include:

- rule name;
- scope;
- affected other rule(s);
- compatibility verdict;
- required boundary;
- save location;
- receipt/proof location;
- remaining risk or follow-up.

## Conflict Handling

If rules conflict:

1. Stop the batch promotion.
2. Name the conflict.
3. Decide which rule has precedence or whether refinement is needed.
4. Refine before save, or park/block with receipt.
5. Do not hide the conflict by committing both silently.

## Bounded Exception Rule

If a rule needs an exception to another rule, the exception must be:

- named;
- scoped;
- justified;
- visible in receipt or matrix;
- not allowed to spread.

Example:
A fixed-name CHAT current-pointer drop-copy may be treated differently from normal versioned Desktop artifacts only if the role is explicitly current-pointer/mirror and not a new user-facing artifact family.

## Relation to No Parking Rule

No Parking says every new project object gets fit decision and route.

This gate applies that logic to batches:
each rule in the batch must be routed and each relationship between rules must be checked.

## Relation to Final Judge Gate

The Final Judge Gate asks whether the gates did their jobs.

For a rule batch, the Final Judge Gate checks whether the compatibility/apply gate actually ran and whether the batch obeyed existing house rules.

## Relation to Desktop Drop Version Naming

Desktop/download/drop helper scripts created for the user should use V naming.

Internal house/repo files should not use V naming.

If a batch creates both, report the split.

## Relation to Local + URL Default

Durable project rules/captures/receipts/status updates default to local + URL.

Local helper scripts, Desktop drop-copies, receipts, plans, dropboxes, and triggers default local-only unless explicitly routed.

A batch receipt must state the split.

## Failure Pattern

Dirty pattern:
Bundling multiple rules and saying "saved" without checking whether they obey each other.

Worse dirty pattern:
Installing two rules that silently conflict.

Worst dirty pattern:
Adding a new rule that should have changed the install process, but not applying it to the current batch.

## Clean Pattern

Clean pattern:

1. Identify the batch.
2. List every rule/object in the batch.
3. Run compatibility matrix.
4. Refine conflicts.
5. Save only the compatible set.
6. Receipt matrix/proof.
7. Update cockpit/drop-copy if assistant-facing.
8. Report local+URL versus local-only.

## Short Form

Several rules at once means apply gate.

Run the rules against each other.

Fit, refine, block, or bounded exception before commit.
"@

$Capture = @"
# Multi-Rule Batch Compatibility Apply Gate Capture — 20260522

## Status

Type: correction capture / batch-rule installation source capture.

Boundary:
- Capture only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Trigger

The user caught that the assistant saved several recent rules but did not explicitly run them against each other.

The user clarified that when several rules are made or installed together, the assistant must apply them to each other and check that they obey the house.

## Founding Original / Source Root

User correction included:

- "you made the file on my desktop but failed to use the apply rule"
- "when you make seceral rules and are attempting to add them all at once"
- "you need to run them agaisnt each other"
- "ensure they obey each other and house rules"
- "this is one is important"

## Clean Translation

A multi-rule save is not just a bundle.

It needs an apply gate:
run the rules against each other, check existing house rules, identify conflicts, refine or block, then save with proof.

## Repair

This save adds the Multi-Rule Batch Compatibility Apply Gate, adds a recent-rules compatibility matrix, updates the chat cockpit, exports the current chat drop-copy, and records the local+URL split.

## Guardrail

This gate prevents rule piles from becoming internal contradictions.
"@

$Matrix = @"
# Multi-Rule Batch Compatibility Matrix — Recent Rules — 20260522

## Status

Type: compatibility/apply matrix.

Purpose:
Prove the recent rule cluster was run against itself after the user's correction.

Boundary:
- Matrix/proof only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Batch Under Review

Recent rules checked:

1. Save Location Default — Local + URL Unless Special.
2. No Parking Without Fit Decision.
3. Switching Gears / Smoke Break House Walk.
4. Desktop Drop Version Naming.
5. Porch Drop Event Trigger + Package Intake.
6. Multi-Rule Batch Compatibility Apply Gate.

## Compatibility Matrix

| Rule | Affected Rules | Verdict | Boundary / Refinement |
|---|---|---|---|
| Save Location Default | No Parking, Desktop Drop Naming, Porch Event, Cockpit updates | FITS | Durable project material goes local+URL. Operational tools/dropboxes/receipts/triggers stay local-only. Reports must split both. |
| No Parking Without Fit Decision | All new project objects | FITS | New objects cannot float. They must route, refine, reject, or hold with trigger. Does not force unsafe material into active lanes. |
| Switching Gears / Smoke Break House Walk | No Parking, Final Judge Gate, task transitions | FITS | Context reset only. Not broad cleanup. Not wandering. Does not replace task-specific proof. |
| Desktop Drop Version Naming | Local helper scripts, download/export artifacts, chat drop-copies | FITS WITH BOUNDED EXCEPTION | New Desktop/drop/download artifacts get V names. Internal house files do not. Fixed-name CHAT current-pointer drop-copy remains allowed as a current mirror because its job is stable pickup/current cockpit visibility, not artifact-family versioning. If user rejects that exception later, refactor cockpit exports separately. |
| Porch Drop Event Trigger + Package Intake | No Parking, Save Location Default, Package/folder handling | FITS | Drop means event. Folder means package. Local triggers/plans/receipts stay local-only unless routed. |
| Multi-Rule Batch Compatibility Apply Gate | All batch saves | FITS | Any multi-rule bundle must include compatibility matrix or cross-check receipt before/with save. |

## Known Exception

### CHAT current-pointer drop-copy

The file:

C:\Users\13527\Desktop\CHAT_DROP_COPY__CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md

is a fixed-name current-pointer mirror used by the cockpit/drop-copy protocol.

It is allowed as a bounded exception to normal V-naming because the user and assistant need one predictable current cockpit pickup name.

This exception does not apply to ordinary downloadable scripts, ZIPs, handoffs, packs, or Desktop helper artifacts.

Those still use V naming.

## Conflicts Found

No hard conflict found after bounded exception.

## Refinement Needed

Potential future refinement:
If the user wants even the fixed CHAT current-pointer copy versioned, make a separate cockpit drop-copy refactor. Do not silently change it inside this gate.

## Final Judge

Gate did its job if:

- batch object was named;
- rule relationships were checked;
- bounded exception was named;
- durable files saved local+URL;
- Desktop helper artifact uses V naming;
- internal house files retain house naming;
- cockpit updated;
- receipt written.

Verdict:
PASS WITH BOUNDED EXCEPTION / COMPATIBILITY GATE ADDED.

## Short Form

The recent rules fit.

The only named exception is the fixed current CHAT cockpit drop-copy.

Everything else obeys normal lane rules.
"@

Set-Content -LiteralPath $RulePath -Value $Rule -Encoding UTF8
Set-Content -LiteralPath $CapturePath -Value $Capture -Encoding UTF8
Set-Content -LiteralPath $MatrixPath -Value $Matrix -Encoding UTF8

if (Test-Path -LiteralPath $CockpitPath) {
    $CockpitText = Get-Content -LiteralPath $CockpitPath -Raw
} else {
    $CockpitText = "# Chat House Rules Cockpit Card — Applied Version — 20260522`r`n"
}

$Marker = "## 2.32 Multi-Rule Batch Compatibility Apply Gate"
$Addendum = @"

---

$Marker

When several rules are created or installed together, do not just bundle and commit them.

Run them against each other first.

Check:
- scope;
- authority;
- local+URL versus local-only;
- Desktop-drop naming versus house naming;
- no-parking fit decision;
- cockpit/drop-copy update;
- source custody;
- proof receipts;
- Final Judge Gate;
- blocked promotions;
- bounded exceptions.

Required output:
compatibility matrix, apply-gate receipt section, cross-check table, or explicit fit/conflict/refine/block list.

Verdicts:
FITS / FITS WITH BOUNDED EXCEPTION / NEEDS REFINEMENT / CONFLICTS / BLOCKED / PARK WITH RETURN TRIGGER.

Short form:
Several rules at once means apply gate. Run the rules against each other before commit.
"@

function Upsert-Section {
    param(
        [string]$Text,
        [string]$Marker,
        [string]$Addendum
    )

    if ($Text -notlike "*$Marker*") {
        return ($Text.TrimEnd() + $Addendum)
    }

    $Pattern = [regex]::Escape($Marker) + ".*?(?=\r?\n---\r?\n|\z)"
    return [regex]::Replace($Text, $Pattern, $Addendum.TrimStart(), [System.Text.RegularExpressions.RegexOptions]::Singleline)
}

$CockpitText = Upsert-Section -Text $CockpitText -Marker $Marker -Addendum $Addendum
Set-Content -LiteralPath $CockpitPath -Value $CockpitText -Encoding UTF8

Copy-Item -LiteralPath $CockpitPath -Destination $DesktopDrop -Force
Copy-Item -LiteralPath $CockpitPath -Destination $Desktop123Drop -Force

$RuleHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $RulePath).Hash
$CaptureHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CapturePath).Hash
$MatrixHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $MatrixPath).Hash
$CockpitHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CockpitPath).Hash
$DesktopDropHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $DesktopDrop).Hash
$Desktop123DropHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Desktop123Drop).Hash

$Receipt = @"
MULTI-RULE BATCH COMPATIBILITY APPLY GATE RECEIPT — 20260522

Verdict:
PASS WITH BOUNDED EXCEPTION - MULTI-RULE BATCH COMPATIBILITY APPLY GATE SAVED

Old HEAD:
$OldHead

Local + URL project files:
$RulePath
SHA256: $RuleHash

$CapturePath
SHA256: $CaptureHash

$MatrixPath
SHA256: $MatrixHash

$CockpitPath
SHA256: $CockpitHash

Local-only exports:
$DesktopDrop
SHA256: $DesktopDropHash

$Desktop123Drop
SHA256: $Desktop123DropHash

Compatibility Result:
Recent rules were run against each other.
No hard conflict found.
Bounded exception named:
fixed-name CHAT current-pointer drop-copy remains allowed as a current cockpit mirror; ordinary Desktop/download/drop artifacts still require V naming.

Boundary:
Multi-rule batch compatibility/apply gate, correction capture, recent-rule compatibility matrix, cockpit update, and labeled CHAT drop-copy export only.
No doctrine promotion.
No active guide rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation.
No internal house/repo file renaming.
No broad cleanup.

Short form:
Several rules at once means apply gate.
Run rules against each other.
Fit, refine, block, or bounded exception before commit.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8

$StatusAppend = @"

## 20260522 — Multi-Rule Batch Compatibility Apply Gate

Position before commit: $OldHead

Local + URL saved:
- $RulePath
- $CapturePath
- $MatrixPath
- $CockpitPath
- $ReceiptPath

Local-only exported:
- $DesktopDrop
- $Desktop123Drop

Verdict:
PASS WITH BOUNDED EXCEPTION - MULTI-RULE BATCH COMPATIBILITY APPLY GATE SAVED

Compatibility Result:
Recent rules were run against each other.
No hard conflict found.
Bounded exception named: fixed-name CHAT current-pointer drop-copy remains allowed as a current cockpit mirror; ordinary Desktop/download/drop artifacts still require V naming.

Boundary:
Multi-rule batch compatibility/apply gate, correction capture, recent-rule compatibility matrix, cockpit update, and labeled CHAT drop-copy export only. No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No automation. No internal house/repo file renaming. No broad cleanup.

Short form:
Several rules at once means apply gate. Run rules against each other. Fit, refine, block, or bounded exception before commit.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

git add -- $RulePath $CapturePath $MatrixPath $CockpitPath $StatusPath
git add -f -- $ReceiptPath

$Staged = git diff --cached --name-only
if (-not $Staged) {
    throw "No staged changes found; nothing to commit."
}

git commit -m "Add multi-rule compatibility apply gate" | Out-Host
git push origin main | Out-Host

$NewHead = (git rev-parse HEAD).Trim()
$RemoteHead = (git rev-parse origin/main).Trim()
$FinalStatus = git status --short

if ($NewHead -ne $RemoteHead) {
    Write-Host "BLOCKED - REMOTE HEAD DOES NOT MATCH"
    Write-Host "Old HEAD: $OldHead"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    exit 1
}

if ($FinalStatus) {
    Write-Host "BLOCKED - FINAL STATUS NOT CLEAN"
    Write-Host "Old HEAD: $OldHead"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    $FinalStatus | ForEach-Object { Write-Host $_ }
    exit 1
}

Write-Host "PASS WITH BOUNDED EXCEPTION - MULTI-RULE BATCH COMPATIBILITY APPLY GATE SAVED"
Write-Host "Old HEAD: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Final status: clean"
Write-Host "Local + URL saved:"
Write-Host "  $RulePath"
Write-Host "  $CapturePath"
Write-Host "  $MatrixPath"
Write-Host "  $CockpitPath"
Write-Host "  $ReceiptPath"
Write-Host "  $StatusPath"
Write-Host "Local-only exported:"
Write-Host "  $DesktopDrop"
Write-Host "  $Desktop123Drop"
Write-Host "Compatibility: recent rules checked; no hard conflict; bounded CHAT current-pointer exception named."
Write-Host "Receipt: $ReceiptPath"
Write-Host "Boundary: multi-rule batch compatibility/apply gate, correction capture, recent-rule compatibility matrix, cockpit update, and labeled CHAT drop-copy export only; no doctrine promotion; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no automation."
