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

$RulePath = "BRAIN_LEARNING/DESKTOP_DROP_VERSION_NAMING_RULE_20260522.md"
$CapturePath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/DESKTOP_DROP_VERSION_NAMING_CAPTURE_20260522.md"
$CockpitPath = "HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
$ReceiptPath = "PROOF_HISTORY/DESKTOP_DROP_VERSION_NAMING_RULE_RECEIPT_20260522.txt"
$StatusPath = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"

foreach ($p in @($RulePath,$CapturePath,$CockpitPath,$ReceiptPath,$StatusPath)) {
    $dir = Split-Path $p
    if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
}
New-Item -ItemType Directory -Force -Path (Split-Path $Desktop123Drop) | Out-Null

$Rule = @"
# Desktop Drop Version Naming Rule — 20260522

## Status

Type: brain-learning / desktop-drop naming and user-facing artifact rule.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not automation.
- This does not rename internal house/repo files.
- This applies only to Desktop/drop/download/export items meant for the user to handle directly.

## Core Rule

When the assistant creates or drops a file for the user's Desktop or as a Desktop-facing/downloadable transfer item, the file name must include a clear version suffix.

Use this version sequence:

- V1
- V1.1
- V1.2
- V1.3
- V1.4
- V1.5
- V1.6
- V1.7
- V1.8
- V1.9
- V2.0
- V2.1
- V2.2
- continue as needed

## Purpose

The user needs to know which Desktop drop is current, which one is older, and which artifacts belong to the same family.

Versioned Desktop drops reduce confusion, duplicate clutter, stale downloads, and accidental use of the wrong file.

## Naming Shape

Use:

RESPECTIVE_DESCRIPTIVE_NAME_V1.ext

Examples:

SAVE_DESKTOP_DROP_VERSION_NAMING_RULE_V1.ps1

ROBOCOP_CONTEXT_README_SETUP_PACK_V1.zip

BOSS_WHIRLPOOL_3_LAP_MULE_HANDOFF_V1.md

If a revised Desktop drop is made in the same artifact family, use:

RESPECTIVE_DESCRIPTIVE_NAME_V1.1.ext

Then:

RESPECTIVE_DESCRIPTIVE_NAME_V1.2.ext

After V1.9, use V2.0.

## Applies To

This applies to user-facing external/drop artifacts such as:

- downloadable scripts;
- Desktop helper scripts;
- Desktop transfer packs;
- ZIP packs;
- handoff files dropped for the user;
- chat-produced files meant for user download;
- Desktop drop-copy support files when they are new exported versions;
- one-shot launchers the user handles directly.

## Does Not Apply To Internal House Files

Do not use this style for internal house/repo files.

Internal house files keep existing conventions:

- lane path;
- role name;
- date stamp;
- receipt naming;
- proof-history naming;
- current project naming rules.

Examples of internal house files that should not be forced into V1/V1.1 style:

- BRAIN_LEARNING/*.md
- HOUSE_WORK/WORK_SHED/*.md
- PROOF_HISTORY/*.txt
- HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md
- ACTIVE_ANCHOR.txt
- CURRENT_TRUTH_INDEX files
- ACTIVE_GUIDES files

## Version Family Rule

A version series belongs to an artifact family.

If the same desktop/drop artifact is revised, increment the version.

If it is a new artifact family, start at V1.

## Reporting Rule

When a Desktop/drop artifact is created, report:

- file name;
- version;
- whether it is a new family or revision;
- SHA256 when practical;
- whether it is local-only or local+URL;
- whether an internal house save also happened separately.

## Failure Pattern

Dirty pattern:
Creating several Desktop/download files with similar names and no visible version.

Worse dirty pattern:
Using V1/V1.1 naming inside the house and polluting internal project naming.

Worst dirty pattern:
Replacing an older Desktop drop without making the version visible.

## Clean Pattern

Clean pattern:

1. Name the Desktop drop clearly.
2. Add version suffix.
3. Preserve internal house naming separately.
4. Report local-only versus local+URL.
5. If revised, increment version.

## Short Form

Desktop drops get V names.

House files do not.

V1, V1.1 to V1.9, then V2.0, V2.1, and onward.
"@

$Capture = @"
# Desktop Drop Version Naming Capture — 20260522

## Status

Type: correction capture / artifact naming source capture.

Boundary:
- Capture only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Trigger

The user clarified that files dropped onto Desktop or Desktop-facing download/export items need clear version names.

The user also explicitly limited the naming rule: do not use this style for inside-house files.

## Founding Original / Source Root

User correction included:

- "when you ddrop files onto my desktop give it the respective name then V1"
- "follow the v rules v1.1 to 1.9 then 2.0 then 2.1 so on"
- "this is to keep me on the know which is and which isnt"
- "be sure you dont use this style for the inside house files"
- "this is only for desktop drop idtems"

## Clean Translation

Desktop/drop/download/export artifacts get visible version suffixes.

Internal repo/house files keep house naming conventions.

## Repair

This save adds a durable project rule and a chat cockpit addendum, then exports the updated CHAT drop-copy.

## Guardrail

This rule prevents Desktop clutter and stale artifact confusion.

It must not pollute internal house file names.
"@

Set-Content -LiteralPath $RulePath -Value $Rule -Encoding UTF8
Set-Content -LiteralPath $CapturePath -Value $Capture -Encoding UTF8

if (Test-Path -LiteralPath $CockpitPath) {
    $CockpitText = Get-Content -LiteralPath $CockpitPath -Raw
} else {
    $CockpitText = "# Chat House Rules Cockpit Card — Applied Version — 20260522`r`n"
}

$Marker = "## 2.31 Desktop Drop Version Naming Rule"
$Addendum = @"

---

$Marker

Desktop/drop/download/export items created for the user must use visible version names.

Use:
- V1
- V1.1 through V1.9
- V2.0
- V2.1
- continue as needed

Applies to:
- downloadable scripts;
- Desktop helper files;
- ZIP packs;
- handoff drops;
- transfer packs;
- user-facing exported files.

Does not apply to:
- internal repo files;
- BRAIN_LEARNING files;
- HOUSE_WORK files;
- PROOF_HISTORY files;
- ACTIVE_ANCHOR;
- CURRENT_TRUTH_INDEX;
- ACTIVE_GUIDES.

Short form:
Desktop drops get V names. House files do not.
"@

if ($CockpitText -notlike "*$Marker*") {
    Set-Content -LiteralPath $CockpitPath -Value ($CockpitText.TrimEnd() + $Addendum) -Encoding UTF8
} else {
    $Pattern = [regex]::Escape($Marker) + ".*?(?=\r?\n---\r?\n|\z)"
    $NewCockpit = [regex]::Replace($CockpitText, $Pattern, $Addendum.TrimStart(), [System.Text.RegularExpressions.RegexOptions]::Singleline)
    Set-Content -LiteralPath $CockpitPath -Value $NewCockpit -Encoding UTF8
}

Copy-Item -LiteralPath $CockpitPath -Destination $DesktopDrop -Force
Copy-Item -LiteralPath $CockpitPath -Destination $Desktop123Drop -Force

$RuleHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $RulePath).Hash
$CaptureHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CapturePath).Hash
$CockpitHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CockpitPath).Hash
$DesktopDropHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $DesktopDrop).Hash
$Desktop123DropHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Desktop123Drop).Hash

$Receipt = @"
DESKTOP DROP VERSION NAMING RULE RECEIPT — 20260522

Verdict:
PASS - DESKTOP DROP VERSION NAMING RULE SAVED

Old HEAD:
$OldHead

Saved project files:
$RulePath
SHA256: $RuleHash

$CapturePath
SHA256: $CaptureHash

$CockpitPath
SHA256: $CockpitHash

Exported Desktop chat drop-copy:
$DesktopDrop
SHA256: $DesktopDropHash

Exported Desktop\123 chat transfer copy:
$Desktop123Drop
SHA256: $Desktop123DropHash

Boundary:
Desktop-drop version naming rule, correction capture, cockpit update, and labeled CHAT drop-copy export only.
No doctrine promotion.
No active guide rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation.
No internal house/repo file renaming.

Short form:
Desktop drops get V names.
House files do not.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8

$StatusAppend = @"

## 20260522 — Desktop Drop Version Naming Rule

Position before commit: $OldHead

Local + URL saved:
- $RulePath
- $CapturePath
- $CockpitPath
- $ReceiptPath

Local-only exported:
- $DesktopDrop
- $Desktop123Drop

Verdict:
PASS - DESKTOP DROP VERSION NAMING RULE SAVED

Boundary:
Desktop-drop version naming rule, correction capture, cockpit update, and labeled CHAT drop-copy export only. No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No automation. No internal house/repo file renaming.

Short form:
Desktop drops get V names. House files do not.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

git add -- $RulePath $CapturePath $CockpitPath $StatusPath
git add -f -- $ReceiptPath

$Staged = git diff --cached --name-only
if (-not $Staged) {
    throw "No staged changes found; nothing to commit."
}

git commit -m "Add desktop drop version naming rule" | Out-Host
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

Write-Host "PASS - DESKTOP DROP VERSION NAMING RULE SAVED"
Write-Host "Old HEAD: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Final status: clean"
Write-Host "Local + URL saved:"
Write-Host "  $RulePath"
Write-Host "  $CapturePath"
Write-Host "  $CockpitPath"
Write-Host "  $ReceiptPath"
Write-Host "  $StatusPath"
Write-Host "Local-only exported:"
Write-Host "  $DesktopDrop"
Write-Host "  $Desktop123Drop"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Boundary: desktop-drop version naming rule, correction capture, cockpit update, and labeled CHAT drop-copy export only; no doctrine promotion; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no automation; no internal house/repo file renaming."
