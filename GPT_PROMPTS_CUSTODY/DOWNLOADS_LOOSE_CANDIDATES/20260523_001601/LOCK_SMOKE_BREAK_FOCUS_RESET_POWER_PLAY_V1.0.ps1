# LOCK_SMOKE_BREAK_FOCUS_RESET_POWER_PLAY_V1.0.ps1
# Saves the Smoke Break Focus Reset / Problem-to-Power-Play rule locally and in Mr.Kleen brain.
# Updates the V1.1 stop/issue/options/weigh gate and router.
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
$Closeout = Join-Path $AssistantRoot ("PORCH_CLOSEOUT\SMOKE_BREAK_FOCUS_RESET_POWER_PLAY_SAVE_{0}" -f $Stamp)
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

$LocalRulePath = Join-Path $ChatRules "SMOKE_BREAK_FOCUS_RESET_POWER_PLAY_V1.0.md"
$LocalDropPath = Join-Path $Desktop "CHAT_DROP_COPY__SMOKE_BREAK_FOCUS_RESET_POWER_PLAY_V1.0.md"
$GatePath = Join-Path $ChatRules "STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_V1.1.md"
$GateDropPath = Join-Path $Desktop "CHAT_DROP_COPY__STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_V1.1.md"
$RouterPath = Join-Path $ChatRules "CHAT_COCKPIT_ROUTER_MAP_V1.0.md"
$RouterDropPath = Join-Path $Desktop "CHAT_DROP_COPY__CHAT_COCKPIT_ROUTER_MAP_V1.0.md"

$Rule = @'
# SMOKE_BREAK_FOCUS_RESET_POWER_PLAY_V1.0

STATUS: CHAT BEHAVIOR SUPPORT / FOCUS RESET / PROBLEM-TO-POWER-PLAY METHOD / NOT DOCTRINE

PURPOSE:
Use a short smoke-break style focus reset between thoughts or issues when work gets tangled, without using the pause as avoidance.

CORE RULE:
When the assistant feels the route getting tangled, it may take a smoke break: pause, breathe, separate the active issue from side issues, and return to the Stop / Issue Notes / Options / Weigh / Verify gate.

WHAT A SMOKE BREAK DOES:
- breaks task-completion momentum;
- separates active issue from side issues;
- stops the assistant from grabbing the first visible defect;
- makes room to list issues, take notes, find options, and weigh them;
- returns the assistant to the same active problem.

WHAT IT MUST NOT DO:
- drift into unrelated work;
- delay the active fix;
- become a mood/vibe substitute for proof;
- skip same-problem application;
- create a reason to avoid file/state verification when verification is needed.

ADVERSE EFFECT RULE:
If the smoke break causes avoidance, delay, drift, overthinking, loss of active issue, or failure to apply the fix to the same problem, treat that adverse effect as evidence. Feed it back into the gate loop as a new visible issue.

PROBLEM-TO-POWER-PLAY RULE:
A problem is not just a failure. It is a signal. If the signal is captured, weighed, applied to the same problem, and verified, it becomes a power play: the system becomes stronger because the failure exposed a missing control.

USE WITH:
`STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_V1.1.md`

SHORT FORM:
Pause.
Separate.
Return to the active issue.
If the pause misbehaves, use that as evidence.
Turn the problem into a stronger gate.
'@

Set-Content -LiteralPath $LocalRulePath -Value $Rule -Encoding UTF8
Copy-Item -LiteralPath $LocalRulePath -Destination $LocalDropPath -Force

$GateStatus = "GATE NOT FOUND"
if (Test-Path -LiteralPath $GatePath) {
    $GateText = Get-Content -LiteralPath $GatePath -Raw
    if ($GateText -notmatch "SMOKE_BREAK_FOCUS_RESET_POWER_PLAY_V1.0") {
        $Add = @'

---

## Smoke Break Focus Reset / Problem-to-Power-Play Addendum

Use:
`CHAT_RULES_LOCAL_ONLY\SMOKE_BREAK_FOCUS_RESET_POWER_PLAY_V1.0.md`

When the route gets tangled, the assistant may take a smoke break between thoughts/issues: pause, breathe, separate the active issue from side issues, then return to this gate.

If the smoke break causes avoidance, delay, drift, overthinking, or failure to apply the fix to the same problem, that adverse effect is evidence. List it as a visible issue and run it through this gate.

A problem becomes a power play only when the signal is captured, weighed, applied to the same problem, and verified.
'@
        Add-Content -LiteralPath $GatePath -Value $Add -Encoding UTF8
        $GateStatus = "UPDATED"
    } else {
        $GateStatus = "ALREADY PRESENT"
    }
    Copy-Item -LiteralPath $GatePath -Destination $GateDropPath -Force
}

$RouterStatus = "ROUTER NOT FOUND"
if (Test-Path -LiteralPath $RouterPath) {
    $RouterText = Get-Content -LiteralPath $RouterPath -Raw
    if ($RouterText -notmatch "SMOKE_BREAK_FOCUS_RESET_POWER_PLAY_V1.0") {
        $AddRouter = @'

---

## Router Addendum — Smoke Break Focus Reset / Problem-to-Power-Play

ASSISTANT: for tangled route, focus reset, smoke break, adverse effect as evidence, or problem-to-power-play behavior, go to:

`CHAT_RULES_LOCAL_ONLY\SMOKE_BREAK_FOCUS_RESET_POWER_PLAY_V1.0.md`

Then return to:
`CHAT_RULES_LOCAL_ONLY\STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE_V1.1.md`

The smoke break must return to the same active problem. If it causes drift, treat the drift as evidence and run it through the gate.
'@
        Add-Content -LiteralPath $RouterPath -Value $AddRouter -Encoding UTF8
        $RouterStatus = "UPDATED"
    } else {
        $RouterStatus = "ALREADY PRESENT"
    }
    Copy-Item -LiteralPath $RouterPath -Destination $RouterDropPath -Force
}

$BrainRuleRel = "BRAIN_LEARNING\SMOKE_BREAK_FOCUS_RESET_POWER_PLAY_RULE_20260522.md"
$BrainCaptureRel = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\SMOKE_BREAK_FOCUS_RESET_POWER_PLAY_CAPTURE_20260522.md"
$BrainReceiptRel = "PROOF_HISTORY\SMOKE_BREAK_FOCUS_RESET_POWER_PLAY_RECEIPT_20260522_$Stamp.txt"
$StatusRel = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$BrainRulePath = Join-Path $BrainRepo $BrainRuleRel
$BrainCapturePath = Join-Path $BrainRepo $BrainCaptureRel
$BrainReceiptPath = Join-Path $BrainRepo $BrainReceiptRel
$StatusPath = Join-Path $BrainRepo $StatusRel

New-Item -ItemType Directory -Path (Split-Path $BrainRulePath),(Split-Path $BrainCapturePath),(Split-Path $BrainReceiptPath),(Split-Path $StatusPath) -Force | Out-Null

$BrainRule = @'
# Smoke Break Focus Reset / Problem-to-Power-Play Rule — 20260522

STATUS: BRAIN LEARNING / FOCUS-RESET METHOD / NO DOCTRINE PROMOTION

PURPOSE:
Add a controlled focus reset to the Stop / Issue Notes / Options / Weigh / Verify gate.

RULE:
When the route gets tangled, the assistant may take a smoke break between thoughts or issues: pause, breathe, separate the active issue from side issues, then return to the same active problem through the gate loop.

ADVERSE EFFECT RULE:
If the smoke break causes avoidance, delay, drift, overthinking, or failure to apply the fix to the same problem, treat that adverse effect as evidence. It becomes a visible issue in the gate loop.

PROBLEM-TO-POWER-PLAY RULE:
Problems become power plays when their signal is captured, weighed, applied to the same problem, and verified. The failure is not hidden; it becomes a control improvement.

BOUNDARY:
- No doctrine promotion.
- No ACTIVE_GUIDES rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.
- No dashboard.
- No broad cleanup.
- Does not replace proof.
- Does not authorize drifting away from the active issue.
'@

$BrainCapture = @'
# Smoke Break Focus Reset / Problem-to-Power-Play Capture — 20260522

STATUS: SORTING BENCH CAPTURE / USER-SUPPLIED REFINEMENT / NO PROMOTION

USER REFINEMENT:
The assistant can use smoke breaks between thoughts or issues to focus. If the smoke break has adverse effects, that adverse effect is evidence, proof, and answer material. Use it. This is how problems become power plays.

FIT:
This refines the Stop / Issue Notes / Options / Weigh / Verify gate. It gives the assistant a focus reset but prevents the reset from becoming avoidance. The reset must return to the same active problem.

CURRENT APPLICATION:
Use the smoke break to separate tangled issues without moving to a side task. If it causes drift, record drift as a visible issue and run it through the gate.

BOUNDARY:
No doctrine promotion, active guide rewrite, current truth rewrite, automation, dashboard, or broad cleanup.
'@

Set-Content -LiteralPath $BrainRulePath -Value $BrainRule -Encoding UTF8
Set-Content -LiteralPath $BrainCapturePath -Value $BrainCapture -Encoding UTF8

$StatusAdd = @"

---

## Smoke Break Focus Reset / Problem-to-Power-Play — $Stamp

Status: saved as brain learning and sorting-bench capture.
Old base: $OldHead
Files:
- $BrainRuleRel
- $BrainCaptureRel
Boundary: no doctrine promotion, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no automation, no dashboard, no broad cleanup.
Next: use smoke break as a focus reset only if it returns to the same active issue; adverse effects become evidence in the gate loop.
"@
Add-Content -LiteralPath $StatusPath -Value $StatusAdd -Encoding UTF8

$LocalRuleHash = Get-FileHash -Algorithm SHA256 -LiteralPath $LocalRulePath
$LocalDropHash = Get-FileHash -Algorithm SHA256 -LiteralPath $LocalDropPath
$GateHashText = "GATE NOT FOUND"
if (Test-Path -LiteralPath $GatePath) { $GateHashText = (Get-FileHash -Algorithm SHA256 -LiteralPath $GatePath).Hash }
$RouterHashText = "ROUTER NOT FOUND"
if (Test-Path -LiteralPath $RouterPath) { $RouterHashText = (Get-FileHash -Algorithm SHA256 -LiteralPath $RouterPath).Hash }
$BrainRuleHash = Get-FileHash -Algorithm SHA256 -LiteralPath $BrainRulePath
$BrainCaptureHash = Get-FileHash -Algorithm SHA256 -LiteralPath $BrainCapturePath
$StatusHash = Get-FileHash -Algorithm SHA256 -LiteralPath $StatusPath

$BrainReceipt = @"
SMOKE BREAK FOCUS RESET POWER PLAY RECEIPT
Timestamp: $Stamp
Old base: $OldHead
Remote before: $RemoteBefore
Verdict target: FOCUS RESET RULE SAVED / ADVERSE EFFECT AS EVIDENCE / NO DOCTRINE PROMOTION

Local support:
- $LocalRulePath
  SHA256: $($LocalRuleHash.Hash)
- $LocalDropPath
  SHA256: $($LocalDropHash.Hash)
- Gate status: $GateStatus
- Gate SHA256: $GateHashText
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
- Adds focus reset between thoughts/issues.
- Requires returning to the same active problem.
- Treats adverse effects as evidence and input to the gate loop.

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

$LocalReceiptPath = Join-Path $ReceiptDir ("SMOKE_BREAK_FOCUS_RESET_POWER_PLAY_LOCAL_AND_BRAIN_RECEIPT_$Stamp.txt")
$LocalReceipt = @"
SMOKE BREAK FOCUS RESET POWER PLAY LOCAL AND BRAIN RECEIPT
Timestamp: $Stamp

Local support:
- $LocalRulePath
  SHA256: $($LocalRuleHash.Hash)
- $LocalDropPath
  SHA256: $($LocalDropHash.Hash)
- Gate status: $GateStatus
- Gate SHA256: $GateHashText
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
- Focus reset saved and linked to gate.
- Adverse effect is treated as evidence.
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

Invoke-GitChecked -Repo $BrainRepo -Args @("commit","-m","Add smoke break focus reset rule") | Out-Null
Invoke-GitChecked -Repo $BrainRepo -Args @("push","origin","main") | Out-Null

$NewHead = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","HEAD")).Trim()
Invoke-GitChecked -Repo $BrainRepo -Args @("fetch","origin","main") | Out-Null
$RemoteAfter = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","origin/main")).Trim()
$StatusAfter = Invoke-GitChecked -Repo $BrainRepo -Args @("status","--short")

if ($NewHead -ne $RemoteAfter) { throw "BLOCKED: remote mismatch. Local: $NewHead Remote: $RemoteAfter" }
if (($StatusAfter -join "`n").Trim().Length -ne 0) { throw "BLOCKED: brain repo dirty after save.`n$($StatusAfter -join "`n")" }

Write-Host "SMOKE BREAK FOCUS RESET POWER PLAY SAVED"
Write-Host "Local receipt: $LocalReceiptPath"
Write-Host "Brain receipt: $BrainReceiptRel"
Write-Host "Old HEAD: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteAfter"
Write-Host "Status: clean"
Write-Host "Verdict: PASS / FOCUS RESET SAVED AND LINKED TO GATE / NO DOCTRINE PROMOTION"
