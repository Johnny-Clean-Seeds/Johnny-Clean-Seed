$ErrorActionPreference = "Stop"

$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"

$DropFileNameCurrent = "CHAT_DROP_COPY__CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
$DropFileNameVersioned = "CHAT_COCKPIT_V1.md"
$DesktopDropCurrent = Join-Path $env:USERPROFILE "Desktop\$DropFileNameCurrent"
$Desktop123DropCurrent = Join-Path $env:USERPROFILE "Desktop\123\$DropFileNameCurrent"
$DesktopDropVersioned = Join-Path $env:USERPROFILE "Desktop\$DropFileNameVersioned"
$Desktop123DropVersioned = Join-Path $env:USERPROFILE "Desktop\123\$DropFileNameVersioned"

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

$RulePath = "BRAIN_LEARNING/DESKTOP_DROP_VERSION_NAMING_RULE_REPAIR_20260522.md"
$CapturePath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/DESKTOP_DROP_VERSION_NAMING_REPAIR_CAPTURE_20260522.md"
$MatrixPath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/DESKTOP_DROP_NAMING_REPAIR_COMPATIBILITY_MATRIX_20260522.md"
$CockpitPath = "HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
$ReceiptPath = "PROOF_HISTORY/DESKTOP_DROP_VERSION_NAMING_REPAIR_RECEIPT_20260522.txt"
$StatusPath = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"

foreach ($p in @($RulePath,$CapturePath,$MatrixPath,$CockpitPath,$ReceiptPath,$StatusPath)) {
    $dir = Split-Path $p
    if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
}
New-Item -ItemType Directory -Force -Path (Split-Path $Desktop123DropCurrent),(Split-Path $Desktop123DropVersioned) | Out-Null

$Rule = @"
# Desktop Drop Version Naming Repair — 20260522

## Status

Type: brain-learning / repair to Desktop-facing artifact naming.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not automation.
- This does not rename internal house/repo files.
- This applies only to Desktop/drop/download/export items meant for the user to handle directly.

## Repair

The earlier Desktop Drop Version Naming rule was correct in principle, but the assistant still made Desktop-facing names too long and treated the CHAT cockpit current-pointer as a broad exception without explicit user approval.

Correction:

Desktop-facing files must use names that are:

1. short enough to read;
2. direct enough to identify the job;
3. versioned with V sequence.

## Core Rule

Keep the name to the point.

Add the V suffix.

Use:

NAME_V1.ext
NAME_V1.1.ext
NAME_V1.2.ext
...
NAME_V1.9.ext
NAME_V2.0.ext
NAME_V2.1.ext

## Examples

Good Desktop/drop names:

- SAVE_DESKTOP_NAMING_REPAIR_V1.1.ps1
- MULE_HANDOFF_V1.md
- ROBOCOP_SETUP_V1.zip
- CHAT_COCKPIT_V1.md
- PORCH_DROPPER_V1.ps1
- SOURCE_PACKET_V1.md

Bad Desktop/drop names:

- overlong file names that read like a paragraph
- names with too many stacked concepts
- names without visible V suffix
- names that force the user to guess which one is current

## Internal House Exception

Internal house/repo files still do not use the Desktop V style.

House files keep lane/date/receipt naming.

Examples:

- BRAIN_LEARNING/*.md
- HOUSE_WORK/*.md
- PROOF_HISTORY/*.txt
- ACTIVE_ANCHOR.txt
- CURRENT_TRUTH_INDEX files
- ACTIVE_GUIDES files

## Current-Pointer Rule

A stable current-pointer Desktop file is allowed only if the user explicitly approves it.

Do not assume the exception.

Until approved, Desktop-facing cockpit drops should also provide a concise V-named copy such as:

CHAT_COCKPIT_V1.md

The internal canonical cockpit file remains:

HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md

## Apply Gate

Because this repair touches existing rules, it must run through the Multi-Rule Batch Compatibility Apply Gate.

Compatibility checks required:
- Desktop naming obeys No Parking.
- Desktop naming obeys Save Location split.
- Desktop naming does not rename internal house files.
- Cockpit/drop-copy update remains visible.
- The prior bounded exception is either user-approved or corrected.
- Receipt states local+URL and local-only split.

## Short Form

Desktop drops:
short name + V number.

House files:
normal house naming.

No assumed exceptions.
"@

$Capture = @"
# Desktop Drop Version Naming Repair Capture — 20260522

## Status

Type: correction capture / repair source capture.

Boundary:
- Capture only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Trigger

The user corrected the assistant after the Desktop naming rule was saved.

The assistant still made Desktop-facing names too long and failed to apply the simple V naming rule cleanly.

## Founding Original / Source Root

User correction included:

- "dude you stil are not naming the ones on the desktop right"
- "just keepo the name to the point add the V1. style"
- "its easy why is this failing"

## Clean Translation

Desktop/drop/download/export names should be concise and versioned.

The assistant should not overbuild the filename.

The assistant should not assume a broad exception for Desktop-facing files unless the user approves it.

## Repair

This save:
- repairs the Desktop naming rule;
- adds a compatibility matrix;
- updates the cockpit;
- exports both the existing CHAT drop-copy and a concise V-named cockpit copy;
- reports local+URL versus local-only.
"@

$Matrix = @"
# Desktop Drop Naming Repair Compatibility Matrix — 20260522

## Status

Type: Multi-Rule Apply Gate matrix.

Boundary:
- Matrix/proof only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Rules Checked

1. Desktop Drop Version Naming.
2. Multi-Rule Batch Compatibility Apply Gate.
3. Save Location Default — Local + URL Unless Special.
4. No Parking Without Fit Decision.
5. Chat Cockpit Drop-Copy Export Protocol.
6. Porch Watcher / Move-Not-Copy Housekeeping.
7. Internal house naming conventions.

## Matrix

| Check | Verdict | Reason |
|---|---|---|
| Desktop names must be concise | FITS | Repair explicitly requires short direct names plus V suffix. |
| Desktop/drop items need V sequence | FITS | Repair confirms V1, V1.1 through V1.9, V2.0 onward. |
| Internal house files must not use V style | FITS | Repair keeps BRAIN_LEARNING, HOUSE_WORK, PROOF_HISTORY, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX on house naming. |
| Batch rule change needs apply gate | FITS | This matrix is the apply gate proof for the repair. |
| Save location split | FITS | Rule/capture/matrix/cockpit/receipt/status are local+URL. Desktop exports are local-only. |
| No parking | FITS | Repair routes the correction immediately, with receipt and cockpit update. |
| Cockpit/drop-copy | FITS WITH CORRECTION | Existing long CHAT drop-copy remains for protocol continuity, but a concise V-named copy is also exported: CHAT_COCKPIT_V1.md. |
| Prior bounded current-pointer exception | REFINED | Exception is no longer assumed. It requires explicit user approval. |
| Porch/move-not-copy | FITS | This save script is a Desktop/download artifact and uses V naming; local exports are intentional copies. |

## Result

PASS WITH REPAIR.

The rule now says:
Desktop drops use short names plus V suffix.
Internal house files do not.
No broad Desktop exception is assumed.

## Remaining Risk

The existing fixed-name CHAT drop-copy is still exported for continuity because the cockpit protocol already points to it.

The repair adds a concise V-named copy so the Desktop side obeys the user's naming rule now.

If the user wants the fixed-name copy removed later, do that as a separate cleanup with receipt.
"@

Set-Content -LiteralPath $RulePath -Value $Rule -Encoding UTF8
Set-Content -LiteralPath $CapturePath -Value $Capture -Encoding UTF8
Set-Content -LiteralPath $MatrixPath -Value $Matrix -Encoding UTF8

if (Test-Path -LiteralPath $CockpitPath) {
    $CockpitText = Get-Content -LiteralPath $CockpitPath -Raw
} else {
    $CockpitText = "# Chat House Rules Cockpit Card — Applied Version — 20260522`r`n"
}

$Marker = "## 2.33 Desktop Drop Naming Repair"
$Addendum = @"

---

$Marker

Desktop/drop/download/export names must be short, direct, and versioned.

Use:
- NAME_V1.ext
- NAME_V1.1.ext
- NAME_V1.2.ext
- through V1.9
- then V2.0, V2.1, onward

Keep the name to the point.

Good:
- SAVE_DESKTOP_NAMING_REPAIR_V1.1.ps1
- MULE_HANDOFF_V1.md
- CHAT_COCKPIT_V1.md
- ROBOCOP_SETUP_V1.zip

Do not use Desktop V style for internal house/repo files.

Do not assume broad Desktop exceptions.
A current-pointer exception needs explicit user approval.

Short form:
Desktop drops = short name + V.
House files = house naming.
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

Copy-Item -LiteralPath $CockpitPath -Destination $DesktopDropCurrent -Force
Copy-Item -LiteralPath $CockpitPath -Destination $Desktop123DropCurrent -Force
Copy-Item -LiteralPath $CockpitPath -Destination $DesktopDropVersioned -Force
Copy-Item -LiteralPath $CockpitPath -Destination $Desktop123DropVersioned -Force

$RuleHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $RulePath).Hash
$CaptureHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CapturePath).Hash
$MatrixHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $MatrixPath).Hash
$CockpitHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CockpitPath).Hash
$DesktopDropCurrentHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $DesktopDropCurrent).Hash
$Desktop123DropCurrentHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Desktop123DropCurrent).Hash
$DesktopDropVersionedHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $DesktopDropVersioned).Hash
$Desktop123DropVersionedHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Desktop123DropVersioned).Hash

$Receipt = @"
DESKTOP DROP VERSION NAMING REPAIR RECEIPT — 20260522

Verdict:
PASS WITH REPAIR - DESKTOP DROP NAMING REPAIR SAVED

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
$DesktopDropCurrent
SHA256: $DesktopDropCurrentHash

$Desktop123DropCurrent
SHA256: $Desktop123DropCurrentHash

$DesktopDropVersioned
SHA256: $DesktopDropVersionedHash

$Desktop123DropVersioned
SHA256: $Desktop123DropVersionedHash

Compatibility Result:
PASS WITH REPAIR.
Desktop names now require short/direct names plus V suffix.
Internal house files keep normal house naming.
The prior current-pointer exception is not assumed; it requires explicit user approval.
For continuity, the existing CHAT drop-copy remains, and a concise V-named copy is exported.

Boundary:
Desktop drop naming repair, correction capture, compatibility matrix, cockpit update, and labeled local exports only.
No doctrine promotion.
No active guide rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation.
No internal house/repo file renaming.

Short form:
Desktop drops = short name + V.
House files = house naming.
No assumed exceptions.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8

$StatusAppend = @"

## 20260522 — Desktop Drop Naming Repair

Position before commit: $OldHead

Local + URL saved:
- $RulePath
- $CapturePath
- $MatrixPath
- $CockpitPath
- $ReceiptPath

Local-only exported:
- $DesktopDropCurrent
- $Desktop123DropCurrent
- $DesktopDropVersioned
- $Desktop123DropVersioned

Verdict:
PASS WITH REPAIR - DESKTOP DROP NAMING REPAIR SAVED

Compatibility Result:
PASS WITH REPAIR. Desktop names now require short/direct names plus V suffix. Internal house files keep normal house naming. The prior current-pointer exception is not assumed; it requires explicit user approval.

Boundary:
Desktop drop naming repair, correction capture, compatibility matrix, cockpit update, and labeled local exports only. No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No automation. No internal house/repo file renaming.

Short form:
Desktop drops = short name + V. House files = house naming. No assumed exceptions.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

git add -- $RulePath $CapturePath $MatrixPath $CockpitPath $StatusPath
git add -f -- $ReceiptPath

$Staged = git diff --cached --name-only
if (-not $Staged) {
    throw "No staged changes found; nothing to commit."
}

git commit -m "Repair desktop drop version naming" | Out-Host
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

Write-Host "PASS WITH REPAIR - DESKTOP DROP NAMING REPAIR SAVED"
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
Write-Host "  $DesktopDropCurrent"
Write-Host "  $Desktop123DropCurrent"
Write-Host "  $DesktopDropVersioned"
Write-Host "  $Desktop123DropVersioned"
Write-Host "Compatibility: PASS WITH REPAIR; desktop names short + V; internal house naming unchanged; no assumed current-pointer exception."
Write-Host "Receipt: $ReceiptPath"
Write-Host "Boundary: desktop drop naming repair, correction capture, compatibility matrix, cockpit update, and labeled local exports only; no doctrine promotion; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no automation."
