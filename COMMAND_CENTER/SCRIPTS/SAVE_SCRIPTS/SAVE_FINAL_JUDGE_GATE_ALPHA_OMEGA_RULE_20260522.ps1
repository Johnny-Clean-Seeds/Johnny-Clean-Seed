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

$RulePath = "BRAIN_LEARNING/FINAL_JUDGE_GATE_ALPHA_OMEGA_ROLE_RULE_20260522.md"
$CapturePath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/FINAL_JUDGE_GATE_ALPHA_OMEGA_ROLE_CAPTURE_20260522.md"
$CockpitPath = "HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
$ReceiptPath = "PROOF_HISTORY/FINAL_JUDGE_GATE_ALPHA_OMEGA_ROLE_RULE_RECEIPT_20260522.txt"
$StatusPath = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"

New-Item -ItemType Directory -Force -Path (Split-Path $RulePath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $CapturePath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $CockpitPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $ReceiptPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $StatusPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $Desktop123Drop) | Out-Null

$Rule = @"
# Final Judge Gate Alpha/Omega Role Rule — 20260522

## Status

Type: brain-learning / gate architecture role rule.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not automation.
- This does not make any handoff, source, document, mule report, helper, or file the throne.
- This does not override "No source gets the throne. Every source gets a lane."
- This does not make the Final Judge Gate a monarchy.
- This does not replace the individual jobs of each gate.

## Core Clarification

The concern is not mainly whether handoff documents, source packets, or mule reports become part of the house.

The concern is whether every object is doing what it needs to do.

Every object must do its job.

Every gate must do its job.

Every mule, handoff, helper, file, process, source, output, receipt, and map must do its job.

The Final Judge Gate judges the gates.

## Alpha/Omega Meaning

The Final Judge Gate is alpha and omega for gate behavior.

It starts the gate run and ends the gate run.

Alpha:
- opens the gate-run question;
- asks whether this object/process is ready to be judged;
- frames which gates are supposed to fire;
- identifies the expected gate roles, lanes, proof needs, and stop conditions.

Omega:
- closes the gate-run question;
- judges whether the gates actually fired;
- judges whether each gate stayed in lane;
- judges whether each gate judged the right thing;
- judges whether the gate stack produced a clean result;
- decides whether the run closes, parks, blocks, fails, or needs another proof route.

This is start-to-finish role fidelity judgment, not monarchy.

## What the Final Judge Gate Starts

The Final Judge Gate starts a gate run by asking:

1. What object is being judged?
2. What is the object's job?
3. What lane owns it?
4. What gates should fire?
5. What does each gate judge?
6. What proof is needed?
7. What would block PASS?
8. What would require parking?
9. What must not change?
10. Where does the run stop?

## What the Final Judge Gate Ends

The Final Judge Gate ends a gate run by asking:

1. Did each required gate fire?
2. Did any gate fail to fire?
3. Did any gate judge outside its lane?
4. Did any gate underreach or overreach?
5. Did any gate skip proof?
6. Did any gate kill an undisproved candidate?
7. Did any gate allow fake PASS?
8. Did any gate promote source ore, mule output, or candidate material too early?
9. Did every object do its assigned job?
10. Did the final result obey source custody, proof discipline, placement, and boundary?
11. Is the run closed, parked, blocked, failed, or ready for next move?

## Relation to Gate Judge / Gate Role Boundary

Gate Judge / Gate Role Boundary says each gate minds its own business.

Final Judge Gate Alpha/Omega says the final judge starts the gate run, keeps the gate stack bounded, and closes by judging whether the gates actually did their jobs.

Gate Judge controls gate-lane behavior.

Final Judge Gate opens and closes the gate-run evaluation.

## Relation to No Source Gets the Throne

This rule does not make a source, handoff, document, thinker, mule, or helper the throne.

It prevents false thrones by asking whether objects and gates are doing their correct jobs.

Short form:

No source gets the throne.
Every source gets a lane.
Every object gets a job.
Every gate gets judged.
The Final Judge Gate starts the gate run and ends it.

## Relation to Tool Context / No Mystery Parts

This rule supports the no-mystery-parts problem:

A helper file is clean only if its job is known and it does its job.

A gate is clean only if its lane is known and it judges correctly.

A mule output is clean only if it returns what it was assigned to return and does not steal authority.

## Dirty Patterns

Dirty patterns blocked by this rule:

- treating a handoff as authority instead of a work order;
- treating a mule report as final truth;
- letting a helper file exist without a role;
- letting a gate kill useful unproven growth;
- letting a gate promote without proof;
- letting a gate judge outside its lane;
- letting a process finish without asking whether the gates behaved;
- treating "not a throne risk" as enough when role failure still exists;
- starting a gate run without defining which gates are supposed to fire;
- ending a gate run without checking whether the gates actually did their jobs.

## Clean Pattern

Clean pattern:

1. Identify the object.
2. Identify its job.
3. Identify its lane.
4. Identify what depends on it.
5. Start the gate run.
6. Identify which gates must fire.
7. Let each gate do only its job.
8. Let the Final Judge Gate judge the gate stack.
9. Close only when object role, gate role, proof, and boundary line up.

## Short Form

The Final Judge Gate is the alpha and omega of gate behavior.

It starts the gate run and ends it.

It judges the gates.

Every object must do its job.
"@

$Capture = @"
# Final Judge Gate Alpha/Omega Role Capture — 20260522

## Status

Type: correction capture / gate-role framing capture.

Boundary:
- Capture only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Trigger

The assistant focused too much on whether found handoff documents were active authority or idle artifacts.

The user clarified that the deeper concern is whether all objects are doing what they need to do, and that the final judge gate judges the gates.

The user then refined the architecture:

The Final Judge Gate starts the gate run and ends it.

## Founding Original / Source Root

User correction included:

- "im not worried about those documents per sey becomming part of the house"
- "i just wnat to ensur eall is doing what it needs to do"
- "the final judge gate judges the gates"
- "its the alpha and omehga"
- "it starts the gate run and ends it"

## Clean Translation

The project needs a stronger role-fidelity and gate-run lens:

- every object has a job;
- every gate has a lane;
- each gate must judge only its assigned matter;
- the Final Judge Gate opens the gate-run question;
- the Final Judge Gate closes the gate-run question;
- the Final Judge Gate evaluates whether the gate stack did its job from start to finish.

This is not about making documents king.

It is about making role and gate behavior accountable.

## Repair

This save adds a project rule and a chat cockpit addendum.

The cockpit addendum is included because this affects assistant behavior during live review, packaging, mule intake, file handling, and save/proof judgment.

## Guardrail

Alpha/Omega does not mean monarchy.

It means start-to-finish gate-run control:
open the run, define the gates, judge whether they behaved, and close cleanly.
"@

Set-Content -LiteralPath $RulePath -Value $Rule -Encoding UTF8
Set-Content -LiteralPath $CapturePath -Value $Capture -Encoding UTF8

if (Test-Path -LiteralPath $CockpitPath) {
    $CockpitText = Get-Content -LiteralPath $CockpitPath -Raw
} else {
    $CockpitText = @"
# Chat House Rules Cockpit Card — Applied Version — 20260522

## Status

Type: in-chat assistant operating card / cockpit sheet.

Purpose: hold assistant-facing project rules close enough to use during live work.

Boundary:
- This does not replace Mr.Kleen.
- This does not rewrite doctrine.
- This does not promote new doctrine.
- This is a working cockpit card for chat behavior.
"@
}

$Marker = "## 2.25 Final Judge Gate Alpha/Omega Role Rule"
$Addendum = @"

---

$Marker

The issue is not only whether a document, source, mule report, or handoff becomes house authority.

The issue is whether every object is doing the job it is supposed to do.

The Final Judge Gate judges the gates.

Alpha/Omega meaning:
- Alpha: start the gate run;
- Omega: end the gate run;
- open the gate-evaluation question;
- identify which gates should fire;
- check whether each gate stayed in lane;
- check whether each gate judged the right thing;
- check whether any gate overreached, underreached, skipped proof, killed growth, allowed fake PASS, or promoted early;
- close the run only when object role, gate role, proof, and boundary line up.

This is role-fidelity judgment, not monarchy.

Short form:
Every object gets a job. Every gate gets judged. The Final Judge Gate starts the gate run and ends it.
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
FINAL JUDGE GATE ALPHA/OMEGA ROLE RULE RECEIPT — 20260522

Verdict:
PASS - FINAL JUDGE GATE ALPHA OMEGA ROLE RULE SAVED

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
Final Judge Gate alpha/omega role rule, correction capture, cockpit addendum, and labeled CHAT drop-copy export only.
No doctrine promotion.
No active guide rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation.
No runtime change.
Does not make any source, handoff, document, mule, or helper the throne.
Does not make Final Judge Gate a monarchy.

Short form:
Every object gets a job.
Every gate gets judged.
The Final Judge Gate starts the gate run and ends it.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8

$StatusAppend = @"

## 20260522 — Final Judge Gate Alpha/Omega Role Rule

Position before commit: $OldHead

Saved:
- $RulePath
- $CapturePath
- $CockpitPath
- $ReceiptPath

Exported:
- $DesktopDrop
- $Desktop123Drop

Verdict:
PASS - FINAL JUDGE GATE ALPHA OMEGA ROLE RULE SAVED

Boundary:
Final Judge Gate alpha/omega role rule, correction capture, cockpit addendum, and labeled CHAT drop-copy export only. No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No automation. Does not make any source, handoff, document, mule, or helper the throne. Does not make Final Judge Gate a monarchy.

Short form:
Every object gets a job. Every gate gets judged. The Final Judge Gate starts the gate run and ends it.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

git add -- $RulePath $CapturePath $CockpitPath $StatusPath
git add -f -- $ReceiptPath

$Staged = git diff --cached --name-only
if (-not $Staged) {
    throw "No staged changes found; nothing to commit."
}

git commit -m "Add final judge gate alpha omega role rule" | Out-Host
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

Write-Host "PASS - FINAL JUDGE GATE ALPHA OMEGA ROLE RULE SAVED"
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
Write-Host "Boundary: Final Judge Gate alpha/omega role rule, correction capture, cockpit addendum, and labeled CHAT drop-copy export only; no doctrine promotion; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no automation."
