# LOCK_STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_V1.1.ps1
# Saves and applies the STOP -> LIST ISSUES -> TAKE NOTES -> FIND OPTIONS -> WEIGH OPTIONS -> FIX -> APPLY -> VERIFY gate.
# This supersedes the narrower V1.0 stop-and-fix wording.
# Saves to ASSISTANT_LOCAL and Mr.Kleen brain.
# No doctrine promotion. No ACTIVE_GUIDES rewrite. No CURRENT_TRUTH_INDEX rewrite.

$ErrorActionPreference = "Stop"

function Invoke-GitChecked {
    param(
        [Parameter(Mandatory=$true)][string]$Repo,
        [Parameter(Mandatory=$true)][string[]]$Args
    )
    Push-Location $Repo
    try {
        $Output = & git @Args 2>&1
        $Code = $LASTEXITCODE
        if ($Code -ne 0) {
            throw "git $($Args -join ' ') failed with exit $Code`n$Output"
        }
        return $Output
    } finally {
        Pop-Location
    }
}

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Desktop = Join-Path $env:USERPROFILE "Desktop"
$Porch = Join-Path $Desktop "123"
$AssistantRoot = Join-Path $Desktop "ASSISTANT_LOCAL"
$ChatRules = Join-Path $AssistantRoot "CHAT_RULES_LOCAL_ONLY"
$ReceiptDir = Join-Path $AssistantRoot "_RECEIPTS"
$Closeout = Join-Path $AssistantRoot ("PORCH_CLOSEOUT\STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_LOCK_{0}" -f $Stamp)
$BrainRepo = Join-Path $Desktop "Jxhnny_Kleen_C3dz"

if (-not (Test-Path -LiteralPath $AssistantRoot)) { throw "BLOCKED: ASSISTANT_LOCAL missing: $AssistantRoot" }
if (-not (Test-Path -LiteralPath $BrainRepo)) { throw "BLOCKED: brain repo missing: $BrainRepo" }
if (-not (Test-Path -LiteralPath (Join-Path $BrainRepo ".git"))) { throw "BLOCKED: not a git repo: $BrainRepo" }

New-Item -ItemType Directory -Path $ChatRules,$ReceiptDir,$Closeout -Force | Out-Null

$Branch = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","--abbrev-ref","HEAD")).Trim()
if ($Branch -ne "main") { throw "BLOCKED: brain repo is not on main. Current branch: $Branch" }

$OldHead = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","HEAD")).Trim()
Invoke-GitChecked -Repo $BrainRepo -Args @("fetch","origin","main") | Out-Null
$RemoteBefore = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","origin/main")).Trim()
if ($OldHead -ne $RemoteBefore) { throw "BLOCKED: local HEAD does not match origin/main. Local: $OldHead Remote: $RemoteBefore" }

$StatusBefore = Invoke-GitChecked -Repo $BrainRepo -Args @("status","--short")
if (($StatusBefore -join "`n").Trim().Length -ne 0) {
    throw "BLOCKED: brain repo has pre-existing dirty state.`n$($StatusBefore -join "`n")"
}

$LocalGatePath = Join-Path $ChatRules "STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_V1.1.md"
$LocalApplicationPath = Join-Path $ChatRules "STOP_ISSUE_NOTE_OPTION_WEIGHT_CURRENT_APPLICATION_20260522_V1.1.md"
$LocalDropPath = Join-Path $Desktop "CHAT_DROP_COPY__STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_V1.1.md"
$RouterPath = Join-Path $ChatRules "CHAT_COCKPIT_ROUTER_MAP_V1.0.md"
$RouterDropPath = Join-Path $Desktop "CHAT_DROP_COPY__CHAT_COCKPIT_ROUTER_MAP_V1.0.md"

$Gate = @'
# STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_V1.1

STATUS: CHAT BEHAVIOR GATE / LOCAL-ONLY SUPPORT MIRROR / NOT DOCTRINE

PURPOSE:
When any issue appears during active work, stop advancement and run the issue through a disciplined fix loop before moving on.

CORE RULE:
No moving to another problem while the active issue is unresolved. The assistant must list issues, take notes, find options, weigh them, apply the selected fix to the same problem that exposed the issue, and verify the fix is real now.

THIS GATE FIRES WHEN:
- the user says stop, fix, repair, do not move on, list issues, take notes, find options, weigh options, figure it out, or equivalent;
- the assistant makes a language/method/proof/routing mistake;
- the assistant tries to advance to a side task while a process break is active;
- proof is vague, stale, missing, future-hoped, or not applied to the current problem;
- a receipt says PASS while errors or blockers exist;
- a rule is written but not applied to the same problem that exposed the need;
- same-shape walk or comparison shows blockers;
- a local/Git/public/porch/mule boundary is unclear.

REQUIRED LOOP:
1. STOP: halt unrelated advancement.
2. LIST ISSUES: identify all visible issues, not only the convenient one.
3. TAKE NOTES: record what happened, what failed, and why it matters.
4. ACTIVE ISSUE: name the current active break that must be fixed before anything else.
5. OPTIONS: find possible fixes.
6. WEIGH OPTIONS: judge each option by fit, risk, proof strength, scope, and whether it solves the active issue now.
7. CHOOSE: select the smallest real fix that solves the active issue.
8. APPLY TO SAME PROBLEM: do not leave the fix abstract; apply it to the problem that exposed it.
9. VERIFY NOW: check exact file/path/hash/receipt/readback/state when applicable.
10. RESUME OR STAY BLOCKED: only resume if the active issue is fixed and verified.

WEIGHING SCALE:
- Fit: does it solve this exact issue?
- Scope: is it small enough to avoid bloat?
- Risk: can it dirty the house, Git, porch, public, or doctrine?
- Proof: can we verify it now?
- Behavior change: does it change the assistant's next action, or only sound good?
- Reuse: does it help future repeats without becoming heavy armor for tiny issues?

OUTPUT SHAPE WHEN THIS FIRES:
- Active issue:
- Visible issue list:
- Notes:
- Options:
- Weighing:
- Chosen fix:
- Apply to current problem:
- Verification:
- Next allowed move:

BANNED BEHAVIOR:
- Do not advance to the next task first.
- Do not fix a side issue while the active issue is behavioral/process control.
- Do not write a rule and walk away.
- Do not use vague proof when exact proof exists.
- Do not treat "later maybe" as a fix.
- Do not make every tiny chat issue require full file/receipt machinery unless saved state, proof, carryover, future pickup, mule, porch, Git, public, or direction comparison is involved.

SHORT FORM:
Stop.
List issues.
Take notes.
Find options.
Weigh them.
Fix the active break.
Apply it to the same problem.
Verify now.
Then move.
'@

$Application = @'
# STOP ISSUE NOTE OPTION WEIGHT — CURRENT APPLICATION — 20260522 — V1.1

STATUS: CURRENT ACTIVE BREAK APPLICATION / LOCAL-ONLY SUPPORT / NOT DOCTRINE

WHAT HAPPENED:
The user corrected the assistant after it tried to move from a live behavior/process failure into a nearby parking-ledger proof-pointer fix.

VISIBLE ISSUES:
1. Rejected repair language was used.
2. The assistant treated a side issue as the active issue.
3. The assistant did not define STOP_AND_FIX_NOW as a hard stop condition before moving.
4. The assistant needed to list issues, take notes, find options, weigh them, and apply the fix to the same problem.
5. The assistant risked writing a rule and walking away without proving it changed the current route.

ACTIVE ISSUE:
The active issue is route-control failure: when a problem appears, the assistant must stop, fix that active problem, apply the fix to the same problem, and verify the fix before any unrelated next move.

OPTIONS CONSIDERED:
A. Only apologize and continue.
B. Fix the parking ledger pointer first.
C. Save a stop-and-fix rule without applying it.
D. Save and apply a stronger gate that requires issue listing, notes, options, weighing, same-problem application, and verification.

WEIGHING:
A fails because it does not change behavior.
B is useful later but wrong now because it advances to a side issue.
C is incomplete because it writes a rule and walks away.
D best fits: it fixes the active route-control failure, captures the method, and changes the next move.

CHOSEN FIX:
D. Save and apply STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_V1.1.

APPLY TO CURRENT PROBLEM:
The next allowed work is not the parking ledger. The current problem is the assistant's route-control failure. This gate is now the active fix target.

VERIFICATION REQUIRED:
- local gate file exists;
- Desktop chat pickup exists;
- router includes the route;
- brain learning and sorting-bench capture are saved;
- receipt exists;
- Git HEAD matches origin/main;
- status is clean;
- next response uses the gate shape before moving on.

NEXT ALLOWED MOVE AFTER SAVE:
Read the receipt. Then use the gate to decide whether the parking-ledger proof-pointer fix is still next.
'@

Set-Content -LiteralPath $LocalGatePath -Value $Gate -Encoding UTF8
Set-Content -LiteralPath $LocalApplicationPath -Value $Application -Encoding UTF8
Copy-Item -LiteralPath $LocalGatePath -Destination $LocalDropPath -Force

$RouterStatus = "ROUTER NOT FOUND"
if (Test-Path -LiteralPath $RouterPath) {
    $RouterText = Get-Content -LiteralPath $RouterPath -Raw
    if ($RouterText -notmatch "STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_V1.1") {
        $Add = @'

---

## Router Addendum — Stop / Issue Notes / Options / Weigh / Verify

ASSISTANT: for stop/fix/repair-now/problem during active work/list issues/take notes/find options/weigh options/gate loop/proof failure/route-control failure, go to:

`CHAT_RULES_LOCAL_ONLY\STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_V1.1.md`

Do not move to another problem while the active issue is unresolved. List issues, take notes, find options, weigh them, apply the chosen fix to the same problem, verify it now, then resume only if state is known.
'@
        Add-Content -LiteralPath $RouterPath -Value $Add -Encoding UTF8
        $RouterStatus = "UPDATED"
    } else {
        $RouterStatus = "ALREADY PRESENT"
    }
    Copy-Item -LiteralPath $RouterPath -Destination $RouterDropPath -Force
}

$BrainRuleRel = "BRAIN_LEARNING\STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_20260522.md"
$BrainCaptureRel = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\STOP_ISSUE_NOTE_OPTION_WEIGHT_ACTIVE_BREAK_CAPTURE_20260522.md"
$BrainReceiptRel = "PROOF_HISTORY\STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_RECEIPT_20260522_$Stamp.txt"
$StatusRel = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$BrainRulePath = Join-Path $BrainRepo $BrainRuleRel
$BrainCapturePath = Join-Path $BrainRepo $BrainCaptureRel
$BrainReceiptPath = Join-Path $BrainRepo $BrainReceiptRel
$StatusPath = Join-Path $BrainRepo $StatusRel

New-Item -ItemType Directory -Path (Split-Path $BrainRulePath),(Split-Path $BrainCapturePath),(Split-Path $BrainReceiptPath),(Split-Path $StatusPath) -Force | Out-Null

$BrainRule = @'
# Stop / Issue Notes / Options / Weigh / Verify Gate — 20260522

STATUS: BRAIN LEARNING / ROUTE-CONTROL GATE / NO DOCTRINE PROMOTION

PURPOSE:
When an issue appears during active work, stop the route and resolve the active issue before advancing.

RULE:
The assistant must not move to any other problem, large or small, while the current issue is unresolved. It must list visible issues, take notes, find options, weigh them, choose the smallest real fix, apply it to the same problem that exposed the issue, and verify the fix now.

FIRES WHEN:
- user says stop, fix, repair, list issues, take notes, find options, weigh options, figure it out, run gate loop, or equivalent;
- assistant uses rejected language or method;
- assistant advances to a side task before resolving active break;
- proof is vague, stale, missing, future-hoped, or not applied;
- same-shape comparison shows blockers;
- receipt and observed state disagree;
- local/Git/public/porch/mule boundary is unclear.

WEIGHING:
Judge options by fit, scope, risk, proof strength, behavior change, and reuse.

REQUIRED METHOD:
Stop.
List issues.
Take notes.
Find options.
Weigh options.
Choose.
Apply to same problem.
Verify now.
Only then resume.

BOUNDARY:
- Behavior and route-control learning.
- No doctrine promotion.
- No ACTIVE_GUIDES rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.
- No dashboard.
- No broad cleanup.
'@

$BrainCapture = @'
# Stop / Issue Notes / Options / Weigh / Verify Active Break Capture — 20260522

STATUS: SORTING BENCH CAPTURE / ACTIVE BREAK FIX / NO PROMOTION

WHAT HAPPENED:
The assistant tried to continue toward a parking-ledger proof-pointer correction after the user identified a deeper process failure. The user clarified the correct rule: when any issue occurs during active work, stop, list issues, take notes, find options, weigh them, fix the active issue, apply the fix to the same problem, and verify it before moving on.

ISSUES:
1. The assistant used rejected repair language.
2. The assistant selected a side issue instead of the active route-control failure.
3. The assistant did not treat STOP_AND_FIX_NOW as a hard stop condition.
4. The assistant needed an option-weighing step instead of jumping to the first useful-looking fix.
5. The assistant needed to prove the fix changed the current behavior/state.

FIX:
Save and apply the Stop / Issue Notes / Options / Weigh / Verify Gate locally and in brain learning.

CURRENT APPLICATION:
The next move after this save is receipt readback and then using the new gate shape. Only after that may the assistant decide whether the parking-ledger proof-pointer fix is the next allowed task.

BOUNDARY:
No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No automation, dashboard, or broad cleanup.
'@

Set-Content -LiteralPath $BrainRulePath -Value $BrainRule -Encoding UTF8
Set-Content -LiteralPath $BrainCapturePath -Value $BrainCapture -Encoding UTF8

$StatusAdd = @"

---

## Stop Issue Note Option Weight Gate — $Stamp

Status: saved as brain learning and sorting-bench capture.
Old base: $OldHead
Files:
- $BrainRuleRel
- $BrainCaptureRel
Boundary: no doctrine promotion, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no automation, no dashboard, no broad cleanup.
Next: read receipt; then use the gate shape before any further task movement.
"@
Add-Content -LiteralPath $StatusPath -Value $StatusAdd -Encoding UTF8

$LocalGateHash = Get-FileHash -Algorithm SHA256 -LiteralPath $LocalGatePath
$LocalApplicationHash = Get-FileHash -Algorithm SHA256 -LiteralPath $LocalApplicationPath
$LocalDropHash = Get-FileHash -Algorithm SHA256 -LiteralPath $LocalDropPath
$BrainRuleHash = Get-FileHash -Algorithm SHA256 -LiteralPath $BrainRulePath
$BrainCaptureHash = Get-FileHash -Algorithm SHA256 -LiteralPath $BrainCapturePath
$StatusHash = Get-FileHash -Algorithm SHA256 -LiteralPath $StatusPath
$RouterHashText = "ROUTER NOT FOUND"
if (Test-Path -LiteralPath $RouterPath) { $RouterHashText = (Get-FileHash -Algorithm SHA256 -LiteralPath $RouterPath).Hash }

$BrainReceipt = @"
STOP ISSUE NOTE OPTION WEIGHT GATE RECEIPT
Timestamp: $Stamp
Old base: $OldHead
Remote before: $RemoteBefore
Verdict target: GATE SAVED AND APPLIED TO CURRENT ACTIVE BREAK / NO DOCTRINE PROMOTION

Local support files:
- $LocalGatePath
  SHA256: $($LocalGateHash.Hash)
- $LocalApplicationPath
  SHA256: $($LocalApplicationHash.Hash)
- $LocalDropPath
  SHA256: $($LocalDropHash.Hash)
- Router status: $RouterStatus
- Router SHA256: $RouterHashText

Brain files:
- $BrainRuleRel
  SHA256: $($BrainRuleHash.Hash)
- $BrainCaptureRel
  SHA256: $($BrainCaptureHash.Hash)
- $StatusRel
  SHA256: $($StatusHash.Hash)

Applied to current problem:
- Active issue named: route-control failure.
- Side issue held: parking-ledger proof pointer.
- Required future behavior: list issues, take notes, find options, weigh, apply to same problem, verify now.

Boundary:
- No doctrine promotion.
- No ACTIVE_GUIDES rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.
- No dashboard.
- No broad cleanup.

Final Git proof printed by script after commit/push verification.
"@
Set-Content -LiteralPath $BrainReceiptPath -Value $BrainReceipt -Encoding UTF8
$BrainReceiptHash = Get-FileHash -Algorithm SHA256 -LiteralPath $BrainReceiptPath

$ScriptArchive = "Not running from porch"
if ($PSCommandPath) {
    $SelfFull = [System.IO.Path]::GetFullPath($PSCommandPath)
    $PorchFull = [System.IO.Path]::GetFullPath($Porch)
    if ($SelfFull.StartsWith($PorchFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        $ArchivePath = Join-Path $Closeout (Split-Path -Leaf $PSCommandPath)
        Move-Item -LiteralPath $PSCommandPath -Destination $ArchivePath -Force
        if (-not (Test-Path -LiteralPath $ArchivePath)) { throw "BLOCKED: script archive failed: $ArchivePath" }
        $ScriptArchive = $ArchivePath
    }
}

$LocalReceiptPath = Join-Path $ReceiptDir ("STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_LOCAL_AND_BRAIN_RECEIPT_$Stamp.txt")
$LocalReceipt = @"
STOP ISSUE NOTE OPTION WEIGHT GATE LOCAL AND BRAIN RECEIPT
Timestamp: $Stamp

Local support:
- $LocalGatePath
  SHA256: $($LocalGateHash.Hash)
- $LocalApplicationPath
  SHA256: $($LocalApplicationHash.Hash)
- $LocalDropPath
  SHA256: $($LocalDropHash.Hash)
- Router status: $RouterStatus
- Router SHA256: $RouterHashText

Brain targets:
- $BrainRuleRel
  SHA256: $($BrainRuleHash.Hash)
- $BrainCaptureRel
  SHA256: $($BrainCaptureHash.Hash)
- $BrainReceiptRel
  SHA256: $($BrainReceiptHash.Hash)
- $StatusRel
  SHA256: $($StatusHash.Hash)

Installer archive:
- $ScriptArchive

Boundary:
- Gate saved and applied to current active break.
- No doctrine promotion.
- No ACTIVE_GUIDES rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.
- No dashboard.
- No broad cleanup.
"@
Set-Content -LiteralPath $LocalReceiptPath -Value $LocalReceipt -Encoding UTF8

Invoke-GitChecked -Repo $BrainRepo -Args @("add",$BrainRuleRel,$BrainCaptureRel,$StatusRel) | Out-Null
Invoke-GitChecked -Repo $BrainRepo -Args @("add","-f",$BrainReceiptRel) | Out-Null

$Staged = Invoke-GitChecked -Repo $BrainRepo -Args @("status","--short")
if (($Staged -join "`n").Trim().Length -eq 0) { throw "BLOCKED: no staged brain changes." }

Invoke-GitChecked -Repo $BrainRepo -Args @("commit","-m","Add stop issue option weigh gate") | Out-Null
Invoke-GitChecked -Repo $BrainRepo -Args @("push","origin","main") | Out-Null

$NewHead = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","HEAD")).Trim()
Invoke-GitChecked -Repo $BrainRepo -Args @("fetch","origin","main") | Out-Null
$RemoteAfter = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","origin/main")).Trim()
$StatusAfter = Invoke-GitChecked -Repo $BrainRepo -Args @("status","--short")

if ($NewHead -ne $RemoteAfter) { throw "BLOCKED: remote mismatch. Local: $NewHead Remote: $RemoteAfter" }
if (($StatusAfter -join "`n").Trim().Length -ne 0) { throw "BLOCKED: brain repo dirty after save.`n$($StatusAfter -join "`n")" }

Write-Host "STOP ISSUE NOTE OPTION WEIGHT GATE SAVED"
Write-Host "Local receipt: $LocalReceiptPath"
Write-Host "Brain receipt: $BrainReceiptRel"
Write-Host "Old HEAD: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteAfter"
Write-Host "Status: clean"
Write-Host "Verdict: PASS / GATE SAVED AND APPLIED / NO DOCTRINE PROMOTION"
