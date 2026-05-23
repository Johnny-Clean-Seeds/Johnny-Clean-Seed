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

$NoParkingRulePath = "BRAIN_LEARNING/NO_PARKING_WITHOUT_FIT_DECISION_RULE_20260522.md"
$NoParkingCapturePath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/NO_PARKING_WITHOUT_FIT_DECISION_CAPTURE_20260522.md"

$SaveLocationRulePath = "BRAIN_LEARNING/SAVE_LOCATION_DEFAULT_LOCAL_AND_URL_RULE_20260522.md"
$SaveLocationCapturePath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/SAVE_LOCATION_DEFAULT_LOCAL_AND_URL_CAPTURE_20260522.md"

$CockpitPath = "HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
$ReceiptPath = "PROOF_HISTORY/NO_PARKING_FIT_DECISION_AND_SAVE_LOCATION_RULES_RECEIPT_20260522.txt"
$StatusPath = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"

$Paths = @(
    $NoParkingRulePath,
    $NoParkingCapturePath,
    $SaveLocationRulePath,
    $SaveLocationCapturePath,
    $CockpitPath,
    $ReceiptPath,
    $StatusPath
)

foreach ($p in $Paths) {
    $dir = Split-Path $p
    if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
}
New-Item -ItemType Directory -Force -Path (Split-Path $Desktop123Drop) | Out-Null

$NoParkingRule = @"
# No Parking Without Fit Decision Rule — 20260522

## Status

Type: brain-learning / project-wide intake-routing rule.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not automation.
- This does not mean reckless promotion.
- This does not mean dangerous material gets forced into active lanes.
- This does not bypass source custody, proof, privacy, or safety gates.

## Core Rule

Do not leave project-related material parked loosely or forgotten.

Whenever the user or assistant creates, notices, receives, drops, downloads, writes, or names a project-related object, run a fit decision.

Project-related objects include:

- rules
- concepts
- ideas
- corrections
- methods
- tools
- launchers
- scripts
- handoffs
- files
- packets
- source notes
- receipts
- maps
- mule outputs
- helper parts
- chat cockpit changes
- package drops
- porch events

## Fit Decision Required

Every new object must be classified:

1. Fits now.
2. Fits after refinement.
3. Does not fit.
4. Unsafe/dangerous/important hold.
5. Unknown / needs review.

Then it must be routed.

## Routes

### Fits now

Move/save/update it into the correct lane with proof.

### Fits after refinement

Refine the object, preserve the founding/source wording if needed, then route it.

### Does not fit

Reject or park it with reason and receipt.

### Unsafe/dangerous/important hold

Hold only with:
- reason;
- lane;
- risk;
- owner;
- next action;
- return trigger.

### Unknown / needs review

Move it to a review/sorting lane with:
- object name;
- source path;
- why unclear;
- what review is needed;
- return trigger.

## Blocked Pattern

Blocked:

- dumping many artifacts into porch and forgetting them;
- leaving downloaded scripts/handoffs/files in root;
- saying "we will get back to this" without a lane and return trigger;
- treating "parked" as permanent storage;
- letting chat-created files stay only in chat/downloads without project route;
- failing to update cockpit/drop-copy when a new assistant-facing rule is added.

## Clean Pattern

Clean pattern:

1. Notice object.
2. Name object.
3. Classify object.
4. Decide fit.
5. Refine if needed.
6. Route or block.
7. Receipt the action.
8. Update cockpit/drop-copy when assistant-facing.
9. Report local+URL versus local-only.

## Holding Rule

Holding is allowed only when the object is super dangerous, sensitive, large, legally risky, source-heavy, privacy-sensitive, unclear, or too important to route without review.

A hold must not be silent.

A hold needs:
- hold reason;
- lane;
- risk;
- next action;
- return trigger.

## Relation to Porch Event Rule

Drop means event.

The event trigger prevents forgotten porch material.

The no-parking rule prevents forgotten project material anywhere, including chat, downloads, porch, mule workshop, source transfer, tool packs, and repo work lanes.

## Relation to Final Judge Gate

The Final Judge Gate starts the gate run and ends it.

For new objects, it asks:

- What is the object?
- What is its job?
- What lane owns it?
- Does it fit?
- What gate judges it?
- Was it routed, refined, blocked, or held with proof?

## Short Form

No floating project gold.

No loose parked piles.

Every new project object gets a fit decision, route, and receipt.
"@

$NoParkingCapture = @"
# No Parking Without Fit Decision Capture — 20260522

## Status

Type: correction capture / rule source capture.

Boundary:
- Capture only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Trigger

The user clarified that the project should not keep creating and parking many files/rules/ideas, then forget them.

The user wants new project-related material checked for fit and routed into the build, refined, or explicitly blocked/parked with proof.

## Founding Original / Source Root

User correction included:

- "for now on everytime we make new anything it gets dropped in"
- "no more parking a bunch of stuff and forgetting it"
- "we verifiy if its fits the build yes no in it goes or refine whatever"
- "it all goes just make it fit clean"
- "dot hold stuff unless its super dangerous and very important"

## Clean Translation

Default behavior:

Every new project-related object must receive a fit decision and route.

If it fits, put it in.

If it needs shaping, refine it and put it in.

If it does not fit, reject or park with reason.

If it is dangerous/important, hold only with explicit reason, lane, and return trigger.

No indefinite parking.
"@

$SaveLocationRule = @"
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

## Short Form

Project-durable saves go local + URL by default.

Local operational artifacts stay local unless explicitly routed.

If special, user says so.

Always report the split.
"@

$SaveLocationCapture = @"
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
"@

Set-Content -LiteralPath $NoParkingRulePath -Value $NoParkingRule -Encoding UTF8
Set-Content -LiteralPath $NoParkingCapturePath -Value $NoParkingCapture -Encoding UTF8
Set-Content -LiteralPath $SaveLocationRulePath -Value $SaveLocationRule -Encoding UTF8
Set-Content -LiteralPath $SaveLocationCapturePath -Value $SaveLocationCapture -Encoding UTF8

if (Test-Path -LiteralPath $CockpitPath) {
    $CockpitText = Get-Content -LiteralPath $CockpitPath -Raw
} else {
    $CockpitText = "# Chat House Rules Cockpit Card — Applied Version — 20260522`r`n"
}

$SaveLocationMarker = "## 2.28 Save Location Default — Local + URL Unless Special"
$SaveLocationAddendum = @"

---

$SaveLocationMarker

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

$NoParkingMarker = "## 2.29 No Parking Without Fit Decision Rule"
$NoParkingAddendum = @"

---

$NoParkingMarker

No floating project gold.

Every new project-related rule, concept, idea, correction, tool, handoff, file, packet, method, receipt, map, mule output, helper, or package gets a fit decision.

Decision:
1. fits now -> route/save/update;
2. fits after refinement -> refine then route;
3. does not fit -> reject or park with reason;
4. dangerous/important -> hold only with reason, lane, risk, next action, and return trigger;
5. unknown -> review lane with receipt and return trigger.

Blocked:
- no parking piles and forgetting them;
- no loose downloads/handoffs/scripts;
- no "later" without lane and return trigger;
- no chat-created artifacts left only in chat/downloads;
- no cockpit rule left unexported when assistant-facing.

Short form:
Make it fit clean, route it, or block/hold it with proof. No indefinite parking.
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

$CockpitText = Upsert-Section -Text $CockpitText -Marker $SaveLocationMarker -Addendum $SaveLocationAddendum
$CockpitText = Upsert-Section -Text $CockpitText -Marker $NoParkingMarker -Addendum $NoParkingAddendum

Set-Content -LiteralPath $CockpitPath -Value $CockpitText -Encoding UTF8

Copy-Item -LiteralPath $CockpitPath -Destination $DesktopDrop -Force
Copy-Item -LiteralPath $CockpitPath -Destination $Desktop123Drop -Force

$HashLines = New-Object System.Collections.Generic.List[string]
foreach ($p in @($NoParkingRulePath,$NoParkingCapturePath,$SaveLocationRulePath,$SaveLocationCapturePath,$CockpitPath)) {
    $h = (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash
    $HashLines.Add("$p`nSHA256: $h`n")
}
$DesktopDropHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $DesktopDrop).Hash
$Desktop123DropHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Desktop123Drop).Hash

$Receipt = @"
NO PARKING FIT DECISION + SAVE LOCATION RULES RECEIPT — 20260522

Verdict:
PASS - NO PARKING FIT DECISION AND SAVE LOCATION RULES SAVED

Old HEAD:
$OldHead

Saved project files:
$($HashLines -join "`n")

Exported Desktop chat drop-copy:
$DesktopDrop
SHA256: $DesktopDropHash

Exported Desktop\123 chat transfer copy:
$Desktop123Drop
SHA256: $Desktop123DropHash

Boundary:
No-parking/fit-decision rule, save-location default rule, correction captures, cockpit update, and labeled CHAT drop-copy export only.
No doctrine promotion.
No active guide rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation.

Short form:
No indefinite parking.
Every new project object gets fit decision and route.
Project-durable saves go local + URL by default.
Local operational artifacts stay local unless routed.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8

$StatusAppend = @"

## 20260522 — No Parking Fit Decision + Save Location Rules

Position before commit: $OldHead

Saved:
- $NoParkingRulePath
- $NoParkingCapturePath
- $SaveLocationRulePath
- $SaveLocationCapturePath
- $CockpitPath
- $ReceiptPath

Exported local-only:
- $DesktopDrop
- $Desktop123Drop

Verdict:
PASS - NO PARKING FIT DECISION AND SAVE LOCATION RULES SAVED

Boundary:
No-parking/fit-decision rule, save-location default rule, correction captures, cockpit update, and labeled CHAT drop-copy export only. No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No automation.

Short form:
No indefinite parking. Every new project object gets fit decision and route. Project-durable saves go local + URL by default. Local operational artifacts stay local unless routed.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

git add -- $NoParkingRulePath $NoParkingCapturePath $SaveLocationRulePath $SaveLocationCapturePath $CockpitPath $StatusPath
git add -f -- $ReceiptPath

$Staged = git diff --cached --name-only
if (-not $Staged) {
    throw "No staged changes found; nothing to commit."
}

git commit -m "Add no parking fit decision and save location rules" | Out-Host
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

Write-Host "PASS - NO PARKING FIT DECISION AND SAVE LOCATION RULES SAVED"
Write-Host "Old HEAD: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Final status: clean"
Write-Host "Local + URL saved:"
Write-Host "  $NoParkingRulePath"
Write-Host "  $NoParkingCapturePath"
Write-Host "  $SaveLocationRulePath"
Write-Host "  $SaveLocationCapturePath"
Write-Host "  $CockpitPath"
Write-Host "  $ReceiptPath"
Write-Host "  $StatusPath"
Write-Host "Local-only exported:"
Write-Host "  $DesktopDrop"
Write-Host "  $Desktop123Drop"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Boundary: no-parking/fit-decision rule, save-location default rule, correction captures, cockpit update, and labeled CHAT drop-copy export only; no doctrine promotion; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no automation."
