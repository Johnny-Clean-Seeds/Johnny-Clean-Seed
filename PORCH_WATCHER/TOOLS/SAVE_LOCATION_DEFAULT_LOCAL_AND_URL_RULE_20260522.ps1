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

$RulePath = "BRAIN_LEARNING/SAVE_LOCATION_DEFAULT_LOCAL_AND_URL_RULE_20260522.md"
$CapturePath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/SAVE_LOCATION_DEFAULT_LOCAL_AND_URL_CAPTURE_20260522.md"
$CockpitPath = "HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
$ReceiptPath = "PROOF_HISTORY/SAVE_LOCATION_DEFAULT_LOCAL_AND_URL_RULE_RECEIPT_20260522.txt"
$StatusPath = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"

New-Item -ItemType Directory -Force -Path (Split-Path $RulePath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $CapturePath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $CockpitPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $ReceiptPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $StatusPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $Desktop123Drop) | Out-Null

$Rule = @"
# Save Location Default — Local + URL Unless Special — 20260522

## Status

Type: brain-learning / save-routing and save-reporting rule.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not automation.
- This does not force private/local operational artifacts to GitHub.
- This does not bypass dirty repo, privacy, safety, source custody, or proof gates.

## Core Rule

Durable project saves default to both:

1. local Mr.Kleen repo files; and
2. remote URL/GitHub push.

Unless the user explicitly says a case is special, local-only, no URL, no push, no commit, or otherwise blocked, project-durable rules/captures/receipts/status updates should be committed and pushed.

## User Override

The user may override the default by saying:

- this one is special;
- local only;
- do not save to URL;
- no push;
- no commit;
- no Git;
- keep this private;
- do not put this in the brain/repo.

When the user gives one of those signals, obey it and state the save boundary.

## What Defaults to Local + URL

Default local+URL applies to durable project material such as:

- BRAIN_LEARNING rules;
- WORK_SHED captures;
- proof receipts intended for project history;
- status/index updates;
- stable project protocols;
- assistant behavior rules that affect project work;
- gate/save/proof/source-custody rules;
- project-wide housekeeping rules;
- cockpit canonical file updates when they are project-file updates.

## What Defaults to Local-Only

Default local-only applies to operational or transport artifacts such as:

- Desktop chat drop-copies;
- Desktop\123 chat transfer copies;
- porch watcher local receipts;
- porch plans;
- dropboxes;
- one-shot local helper tools;
- local-only source material;
- temp scripts in command/tool lanes;
- backup versions;
- local event/mail triggers;
- large raw transcript or source-heavy material unless explicitly routed.

These can be referenced in repo receipts/status, but they are not automatically pushed to URL.

## Reporting Rule

Every save report must split locations clearly:

### Local + URL

List files committed and pushed to remote URL/GitHub.

Proof needed:
- commit hash;
- push success;
- New HEAD;
- Remote HEAD match;
- final clean status.

### Local-only

List Desktop/123/tools/receipts/dropboxes/drop-copies/event triggers that were created locally but not committed/pushed.

Do not imply local-only artifacts are on the URL.

## Classification Rule

Before saving, classify each object as:

- durable project file: local + URL by default;
- operational local support: local-only by default;
- explicit copy/export/drop-copy: local-only unless routed otherwise;
- sensitive/private/raw/source-heavy: ask, park, or keep local;
- unclear: classify and ask or park.

## Failure Pattern

Dirty pattern:
Saying "saved" without saying whether it is local, URL, or local-only.

Worse dirty pattern:
Treating local-only artifacts as if they are on the URL.

Worst dirty pattern:
Failing to push durable project rules because the assistant confused them with local tools, or pushing local-only operational junk because the assistant failed to classify.

## Clean Pattern

Clean pattern:

1. Classify material.
2. Durable project rule/capture/receipt/status goes local repo + URL push.
3. Operational tools/receipts/dropboxes/drop-copies stay local-only.
4. User special overrides default.
5. Final report explicitly splits local+URL from local-only.

## Short Form

Project-durable saves go local + URL by default.

Local operational artifacts stay local unless explicitly routed.

If special, user says so.

Always report the split.
"@

$Capture = @"
# Save Location Default — Local + URL Unless Special Capture — 20260522

## Status

Type: correction capture / save-routing framing.

Boundary:
- Capture only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Trigger

The user clarified that the assistant should generally know when project saves need both local and URL.

The user also clarified that special cases are the exception, and the user will say when a save should not go to URL.

## Founding Original / Source Root

User correction included:

- "when you save like this is it both local and url"
- "well lets make sure you do what needs it"
- "you should know pretty much when i want it local or not"
- "you cant lkow all cases but thatst when i coime in and i say this one is special dont save to url"

## Clean Translation

Durable project saves default to local repo plus URL/GitHub push.

Local operational support artifacts stay local unless explicitly routed.

The assistant must report the split.

The user can override by saying a case is special or no URL.

## Repair

This save adds a rule, updates the chat cockpit, and exports the updated CHAT drop-copy.

## Guardrail

This is not permission to push everything.

It is a classification rule:
durable project file versus local operational artifact.
"@

Set-Content -LiteralPath $RulePath -Value $Rule -Encoding UTF8
Set-Content -LiteralPath $CapturePath -Value $Capture -Encoding UTF8

if (Test-Path -LiteralPath $CockpitPath) {
    $CockpitText = Get-Content -LiteralPath $CockpitPath -Raw
} else {
    $CockpitText = "# Chat House Rules Cockpit Card — Applied Version — 20260522`r`n"
}

$Marker = "## 2.28 Save Location Default — Local + URL Unless Special"
$Addendum = @"

---

$Marker

Durable project saves default to both:

1. local Mr.Kleen repo files; and
2. remote URL/GitHub push.

Unless the user says a case is special, local-only, no URL, no push, no commit, or no Git, durable project rules/captures/receipts/status updates should be committed and pushed.

Local-only by default:
- Desktop chat drop-copies;
- Desktop\123 transfer copies;
- porch watcher receipts/plans;
- dropboxes;
- one-shot local helper tools;
- local event/mail triggers;
- backup versions;
- raw/source-heavy material unless routed.

Every save report must split:
- Local + URL: committed/pushed repo files.
- Local-only: tools, receipts, dropboxes, event triggers, exported copies.

Short form:
Project-durable saves go local + URL by default. Local operational artifacts stay local unless routed. If special, user says so.
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
SAVE LOCATION DEFAULT LOCAL + URL RULE RECEIPT — 20260522

Verdict:
PASS - SAVE LOCATION DEFAULT LOCAL AND URL RULE SAVED

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
Save-routing/reporting rule, correction capture, cockpit update, and labeled CHAT drop-copy export only.
No doctrine promotion.
No active guide rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation.

Short form:
Project-durable saves go local + URL by default.
Local operational artifacts stay local unless routed.
If special, user says so.
Always report the split.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8

$StatusAppend = @"

## 20260522 — Save Location Default Local + URL Rule

Position before commit: $OldHead

Saved:
- $RulePath
- $CapturePath
- $CockpitPath
- $ReceiptPath

Exported local-only:
- $DesktopDrop
- $Desktop123Drop

Verdict:
PASS - SAVE LOCATION DEFAULT LOCAL AND URL RULE SAVED

Boundary:
Save-routing/reporting rule, correction capture, cockpit update, and labeled CHAT drop-copy export only. No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No automation.

Short form:
Project-durable saves go local + URL by default. Local operational artifacts stay local unless routed. If special, user says so. Always report the split.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

git add -- $RulePath $CapturePath $CockpitPath $StatusPath
git add -f -- $ReceiptPath

$Staged = git diff --cached --name-only
if (-not $Staged) {
    throw "No staged changes found; nothing to commit."
}

git commit -m "Add save location default local and URL rule" | Out-Host
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

Write-Host "PASS - SAVE LOCATION DEFAULT LOCAL AND URL RULE SAVED"
Write-Host "Old HEAD: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Final status: clean"
Write-Host "Rule: $RulePath"
Write-Host "Capture: $CapturePath"
Write-Host "Cockpit: $CockpitPath"
Write-Host "Desktop CHAT drop-copy: $DesktopDrop"
Write-Host "Desktop 123 CHAT copy: $Desktop123Drop"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Local + URL: repo files committed and pushed."
Write-Host "Local-only: Desktop CHAT drop-copies exported, not part of URL unless separately committed."
Write-Host "Boundary: save-routing/reporting rule, correction capture, cockpit update, and labeled CHAT drop-copy export only; no doctrine promotion; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no automation."
