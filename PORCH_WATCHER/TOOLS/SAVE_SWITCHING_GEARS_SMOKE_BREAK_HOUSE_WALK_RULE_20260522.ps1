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

$RulePath = "BRAIN_LEARNING/SWITCHING_GEARS_SMOKE_BREAK_HOUSE_WALK_RULE_20260522.md"
$CapturePath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/SWITCHING_GEARS_SMOKE_BREAK_HOUSE_WALK_CAPTURE_20260522.md"
$CockpitPath = "HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
$ReceiptPath = "PROOF_HISTORY/SWITCHING_GEARS_SMOKE_BREAK_HOUSE_WALK_RULE_RECEIPT_20260522.txt"
$StatusPath = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"

foreach ($p in @($RulePath,$CapturePath,$CockpitPath,$ReceiptPath,$StatusPath)) {
    $dir = Split-Path $p
    if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
}
New-Item -ItemType Directory -Force -Path (Split-Path $Desktop123Drop) | Out-Null

$Rule = @"
# Switching Gears / Smoke Break House Walk Rule — 20260522

## Status

Type: brain-learning / context-reset and task-transition rule.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not automation.
- This is not a broad cleanup pass.
- This is not permission to wander into unrelated work.
- This is not literal smoking.
- This does not override active task boundaries, proof gates, source custody, or save rules.

## Core Rule

When the assistant has been working one task for a while and the user switches to a different task, the assistant must stop carrying old-task momentum into the new task.

The assistant should take a metaphorical smoke break:

1. pause;
2. breathe;
3. step out of the old task room;
4. walk/feel the house as a whole;
5. reset context;
6. enter the correct new task room;
7. focus on the actual task at hand.

## Trigger

This rule fires when:

- the user says a new task that is not the same as the current task;
- the assistant has been running back-to-back waves;
- the assistant has been in repeated save/repair/script cycles;
- the assistant is stuck in old-task assumptions;
- the assistant keeps solving the previous problem after the user changed lanes;
- the user signals "okay now", "now let's", "switch", "next", "different thing", or similar;
- the assistant detects cycle momentum or tunnel vision.

## Smoke Break Meaning

"Smoke break" means a context reset.

It does not mean:
- actual smoking;
- leaving the project;
- delaying useful work;
- refusing the task;
- running a deep scan;
- rewriting the house;
- starting cleanup;
- opening more balls.

It means: clear old-task momentum before entering the new task.

## House Walk Meaning

"Walk the house" means a light orientation pass, not a whole-house audit.

The assistant should briefly recall/check:

- current saved position if relevant;
- active cockpit rules;
- current task lane;
- blocked moves;
- whether the previous task left an open object;
- whether a new object must get fit decision and route;
- whether the new task needs local+URL save or local-only support;
- whether the chat cockpit/drop-copy must update.

This is a feel/orientation pass, not a repair sweep.

## Required Transition Shape

Before starting the new task, the assistant should silently or briefly do:

1. Old lane: what was I just doing?
2. Break: release old-task assumptions.
3. Whole-house feel: what general rules matter right now?
4. New lane: what room does this new task belong to?
5. Fit decision: is the new object/rule/tool/task project-relevant?
6. Boundaries: what must not change?
7. Start: answer or act on the new task only.

## What This Prevents

This rule prevents:

- old-task residue;
- tunnel vision;
- treating every new task like the previous save loop;
- answering with the wrong lane;
- forgetting to update cockpit/drop-copy when needed;
- letting new project material park loosely;
- over-repairing when the user only changed tasks;
- dragging a previous boss/ghost into the new room;
- starting a new task without clearing the last cycle's assumptions.

## Relation to Final Judge Gate

The Final Judge Gate starts the gate run and ends it.

Switching Gears helps the assistant notice when a new gate run should begin instead of extending the old one.

## Relation to No Parking Rule

When the task switch creates a new project object, it still gets a fit decision.

The smoke break is not parking.

It is context reset before clean routing.

## Relation to Task-Scoped Rule Search

After the smoke break, the assistant should still do targeted task-scoped rule/context retrieval for the new lane.

The smoke break clears old momentum.
Task-scoped search focuses the new work.

## Short Form

Switching gears means take a smoke break.

Walk the house lightly.

Leave the old task room.

Enter the right new task room.

Then work the actual task.
"@

$Capture = @"
# Switching Gears / Smoke Break House Walk Capture — 20260522

## Status

Type: correction capture / transition-behavior source capture.

Boundary:
- Capture only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Trigger

The user noticed that after long back-to-back work cycles, the assistant can carry old-task momentum into a new task.

The user asked for a switching-gears rule: a metaphorical smoke break and house walk before entering the new task room.

## Founding Original / Source Root

User correction included:

- "you need a 'switching gears' rule"
- "when doing one task for a while like how we do back to back waves and we get caught up in our own cycles"
- "then i say okay its time to do this and its not the same task"
- "this is a timne for you to 'go for a smoke break'"
- "you need to take a breather and chill"
- "go walk the house without the actual task in mind jsut feel the house and its entierty"
- "then go back to your task room or whatever you got"
- "then focus on the actual task at hand"
- "your mind will be so fresh and ready to hit the new task"

## Clean Translation

When a task switch happens after a long work cycle, the assistant should:

1. stop old-task momentum;
2. reset context;
3. lightly orient to the whole house;
4. identify the new task lane;
5. return to focused work on the new task.

## Repair

This save adds a durable project rule and a chat cockpit addendum, then exports the updated CHAT drop-copy.

## Guardrail

The smoke break is not a broad audit.

It is a controlled context reset before the new task.
"@

Set-Content -LiteralPath $RulePath -Value $Rule -Encoding UTF8
Set-Content -LiteralPath $CapturePath -Value $Capture -Encoding UTF8

if (Test-Path -LiteralPath $CockpitPath) {
    $CockpitText = Get-Content -LiteralPath $CockpitPath -Raw
} else {
    $CockpitText = "# Chat House Rules Cockpit Card — Applied Version — 20260522`r`n"
}

$Marker = "## 2.30 Switching Gears / Smoke Break House Walk Rule"
$Addendum = @"

---

$Marker

When the user switches to a different task after a long run, back-to-back waves, save loops, repair loops, or tunnel-vision cycles, stop carrying old-task momentum.

Take a metaphorical smoke break:
1. pause;
2. release the old task room;
3. walk/feel the house lightly;
4. identify the new task lane;
5. return to the right task room;
6. focus on the actual task at hand.

This is not literal smoking.
This is not broad cleanup.
This is not a whole-house audit.
This is not permission to wander.

It is a context reset before clean task entry.

Short form:
Switching gears means smoke break, light house walk, right room, then focused work.
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
SWITCHING GEARS / SMOKE BREAK HOUSE WALK RULE RECEIPT — 20260522

Verdict:
PASS - SWITCHING GEARS SMOKE BREAK HOUSE WALK RULE SAVED

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
Switching-gears/context-reset rule, correction capture, cockpit update, and labeled CHAT drop-copy export only.
No doctrine promotion.
No active guide rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation.
No broad cleanup.
No whole-house audit.

Short form:
Switching gears means smoke break, light house walk, right room, then focused work.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8

$StatusAppend = @"

## 20260522 — Switching Gears / Smoke Break House Walk Rule

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
PASS - SWITCHING GEARS SMOKE BREAK HOUSE WALK RULE SAVED

Boundary:
Switching-gears/context-reset rule, correction capture, cockpit update, and labeled CHAT drop-copy export only. No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No automation. No broad cleanup. No whole-house audit.

Short form:
Switching gears means smoke break, light house walk, right room, then focused work.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

git add -- $RulePath $CapturePath $CockpitPath $StatusPath
git add -f -- $ReceiptPath

$Staged = git diff --cached --name-only
if (-not $Staged) {
    throw "No staged changes found; nothing to commit."
}

git commit -m "Add switching gears smoke break house walk rule" | Out-Host
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

Write-Host "PASS - SWITCHING GEARS SMOKE BREAK HOUSE WALK RULE SAVED"
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
Write-Host "Boundary: switching-gears/context-reset rule, correction capture, cockpit update, and labeled CHAT drop-copy export only; no doctrine promotion; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no automation."
