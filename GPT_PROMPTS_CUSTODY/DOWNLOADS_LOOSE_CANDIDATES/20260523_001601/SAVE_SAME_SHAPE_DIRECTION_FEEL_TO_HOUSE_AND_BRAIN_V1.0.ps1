# SAVE_SAME_SHAPE_DIRECTION_FEEL_TO_HOUSE_AND_BRAIN_V1.0.ps1
# Saves the Before/After Same-Shape House Walk "wearing it" direction-feel insight
# into ASSISTANT_LOCAL where chat behavior belongs, and into the Mr.Kleen brain repo.
# Brain save = local repo files + commit + push, with guardrails.
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
$Journal = Join-Path $AssistantRoot "ASSISTANT_LOCAL_JOURNAL"
$LocalReceiptDir = Join-Path $AssistantRoot "_RECEIPTS"
$LocalCloseout = Join-Path $AssistantRoot ("PORCH_CLOSEOUT\SAME_SHAPE_DIRECTION_FEEL_SAVE_{0}" -f $Stamp)

$BrainRepo = Join-Path $Desktop "Jxhnny_Kleen_C3dz"

# --- PRE-FLIGHT ---
if (-not (Test-Path -LiteralPath $AssistantRoot)) { throw "BLOCKED: ASSISTANT_LOCAL root missing: $AssistantRoot" }
if (-not (Test-Path -LiteralPath $ChatRules)) { throw "BLOCKED: CHAT_RULES_LOCAL_ONLY missing: $ChatRules" }
if (-not (Test-Path -LiteralPath $BrainRepo)) { throw "BLOCKED: Mr.Kleen brain repo missing: $BrainRepo" }
if (-not (Test-Path -LiteralPath (Join-Path $BrainRepo ".git"))) { throw "BLOCKED: not a git repo: $BrainRepo" }

New-Item -ItemType Directory -Path $Journal,$LocalReceiptDir,$LocalCloseout -Force | Out-Null

$Branch = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","--abbrev-ref","HEAD")).Trim()
if ($Branch -ne "main") { throw "BLOCKED: brain repo is not on main. Current branch: $Branch" }

$StatusBefore = (Invoke-GitChecked -Repo $BrainRepo -Args @("status","--short"))
if (($StatusBefore -join "`n").Trim().Length -gt 0) {
    throw "BLOCKED: brain repo has pre-existing dirty state. Clean or inspect before save.`n$($StatusBefore -join "`n")"
}

$OldHead = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","HEAD")).Trim()

# Fetch is proof/sync only. It does not merge.
Invoke-GitChecked -Repo $BrainRepo -Args @("fetch","origin","main") | Out-Null
$RemoteBefore = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","origin/main")).Trim()
if ($OldHead -ne $RemoteBefore) {
    throw "BLOCKED: local HEAD does not match origin/main. Local: $OldHead Remote: $RemoteBefore"
}

# --- LOCAL ASSISTANT SAVE ---
$LocalCapturePath = Join-Path $ChatRules "SAME_SHAPE_HOUSE_WALK_WEARING_FEEL_CAPTURE_20260522.md"
$LocalJournalPath = Join-Path $Journal "SAME_SHAPE_HOUSE_WALK_WEARING_FEEL_NOTE_20260522.md"
$LocalDropPath = Join-Path $Desktop "CHAT_DROP_COPY__SAME_SHAPE_HOUSE_WALK_WEARING_FEEL_CAPTURE_20260522.md"
$MethodPath = Join-Path $ChatRules "BEFORE_AFTER_SAME_SHAPE_HOUSE_WALK_METHOD_V1.0.md"

$Capture = @'
# Same-Shape House Walk Wearing-Feel Capture — 20260522

STATUS: CHAT BEHAVIOR SUPPORT / DIRECTION-FEEL CAPTURE / LOCAL-ONLY MIRROR

SOURCE CONTEXT:
After the Before/After Same-Shape House Walk method was applied, the user asked how it felt to wear it, then clarified that this should be added where it belongs, including chat and brain.

CORE FEEL:
Operationally, this method feels like a harness, not a cage.

WHAT IT DOES:
- slows the jump before action;
- keeps the assistant's feet under it;
- makes "ready" harder to fake;
- turns direction-feel into evidence instead of vibe;
- makes before/after comparison use the same ruler;
- blocks reading/reviewing output until the required after-walk and comparison are clean.

PROVED BY CURRENT USE:
The method blocked immediate mule-return reading.
The AFTER walk found missing Desktop pickups and loose porch files.
Those blockers were repaired.
The same-shape AFTER walk reran clean.
Only then was the mule return read.

USEFUL FRICTION:
The friction is good when the task touches files, proof, carryover, future pickup, mule/porch/Git/public boundaries, or direction comparison.

RISK:
The method can become too stiff if every tiny chat mistake requires files, receipts, pickups, and closeout.

BOUNDARY:
Use the heavier route when saved artifacts, proof, carryover, future pickup, local/root state, mule, porch, Git, public, or comparison evidence is involved.
For small low-risk chat behavior, apply the lesson directly without forcing a full file/receipt machine.

SHORT FORM:
Harness, not cage.
Slow the jump.
Use the same ruler twice.
Repair blockers before reading the prize.
Do not make every tiny mistake wear full armor.
'@

Set-Content -LiteralPath $LocalCapturePath -Value $Capture -Encoding UTF8
Set-Content -LiteralPath $LocalJournalPath -Value $Capture -Encoding UTF8
Copy-Item -LiteralPath $LocalCapturePath -Destination $LocalDropPath -Force

$MethodPatchStatus = "METHOD FILE NOT FOUND"
if (Test-Path -LiteralPath $MethodPath) {
    $MethodText = Get-Content -LiteralPath $MethodPath -Raw
    if ($MethodText -notmatch "Harness, not cage") {
        $Addendum = @'

---

## Wearing-Feel Addendum — 20260522

Operationally, this method is a harness, not a cage.

It should slow the jump, keep the assistant's feet under it, make "ready" harder to fake, and turn direction-feel into evidence instead of vibe.

Use the full same-shape walk route when the task touches saved artifacts, proof, carryover, future pickup, local/root state, mule, porch, Git, public, or comparison evidence.

Do not make every tiny chat mistake require files, receipts, pickups, and closeout. For small low-risk chat behavior, apply the lesson directly.
'@
        Add-Content -LiteralPath $MethodPath -Value $Addendum -Encoding UTF8
        $MethodPatchStatus = "PATCHED"
    } else {
        $MethodPatchStatus = "ALREADY PRESENT"
    }
}

$LocalCaptureHash = Get-FileHash -Algorithm SHA256 -LiteralPath $LocalCapturePath
$LocalJournalHash = Get-FileHash -Algorithm SHA256 -LiteralPath $LocalJournalPath
$LocalDropHash = Get-FileHash -Algorithm SHA256 -LiteralPath $LocalDropPath
$LocalMethodHashText = "METHOD FILE NOT FOUND"
if (Test-Path -LiteralPath $MethodPath) {
    $LocalMethodHashText = (Get-FileHash -Algorithm SHA256 -LiteralPath $MethodPath).Hash
}

# --- BRAIN SAVE ---
$BrainRuleRel = "BRAIN_LEARNING\BEFORE_AFTER_SAME_SHAPE_HOUSE_WALK_DIRECTION_FEEL_RULE_20260522.md"
$BrainCaptureRel = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\SAME_SHAPE_HOUSE_WALK_WEARING_FEEL_CAPTURE_20260522.md"
$BrainReceiptRel = "PROOF_HISTORY\SAME_SHAPE_HOUSE_WALK_DIRECTION_FEEL_LOCK_RECEIPT_20260522_$Stamp.txt"
$BrainStatusRel = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"

$BrainRulePath = Join-Path $BrainRepo $BrainRuleRel
$BrainCapturePath = Join-Path $BrainRepo $BrainCaptureRel
$BrainReceiptPath = Join-Path $BrainRepo $BrainReceiptRel
$BrainStatusPath = Join-Path $BrainRepo $BrainStatusRel

New-Item -ItemType Directory -Path (Split-Path $BrainRulePath),(Split-Path $BrainCapturePath),(Split-Path $BrainReceiptPath),(Split-Path $BrainStatusPath) -Force | Out-Null

$BrainRule = @'
# Before/After Same-Shape House Walk Direction-Feel Rule — 20260522

STATUS: BRAIN LEARNING / BEHAVIOR RULE / NO DOCTRINE PROMOTION

PURPOSE:
Use the Before/After Same-Shape House Walk method to make direction-feel evidence-based rather than vibe-based.

RULE:
When an action needs direction comparison, the assistant must capture a baseline with a fixed comparison contract, perform the action, then run the after-walk using the exact same contract before judging the result.

SAME-SHAPE REQUIREMENT:
The second search must match the first search exactly:
- same paths;
- same depth;
- same filters;
- same file names and patterns;
- same ordering;
- same labels;
- same count logic;
- same hash/proof fields;
- same receipt checks;
- same boundary checks;
- same blocker checks;
- same output sections.

If a new concern appears after baseline, put it under ADDED AFTER BASELINE and keep it out of the direct comparison.

WEARING-FEEL:
Operationally, this feels like a harness, not a cage.

It slows the jump, keeps the assistant's feet under it, makes "ready" harder to fake, and blocks reward-reading until the after-walk and comparison are clean.

USEFUL FRICTION:
The friction is good when the task touches saved artifacts, proof, carryover, future pickup, mule/porch/Git/public boundaries, or direction comparison.

RISK:
Do not make every tiny chat mistake require files, receipts, pickups, and closeout. The heavy route is for stateful/proof-bearing work. Low-risk chat behavior can apply the lesson directly.

BOUNDARY:
- Does not rewrite doctrine.
- Does not rewrite ACTIVE_GUIDES.
- Does not rewrite CURRENT_TRUTH_INDEX.
- Does not replace proof.
- Does not authorize broad cleanup.
- Does not turn vibe into authority.
- It gives the assistant a stable ruler for before/after judgment.

SHORT FORM:
Harness, not cage.
Same ruler twice.
Repair blockers before reading the prize.
Direction-feel by evidence.
'@

$BrainCapture = @'
# Same-Shape House Walk Wearing-Feel Capture — 20260522

STATUS: SORTING BENCH CAPTURE / SOURCE-TO-RULE BRIDGE / NO PROMOTION

SOURCE:
The user asked how the Before/After Same-Shape House Walk method felt when worn, then directed that the insight be added to the house, to chat where it belongs, and to the brain.

OBSERVED OPERATIONAL FEEL:
It feels cleaner and heavier at the same time.

It reduces the assistant's freedom to bluff readiness. It creates a backbone because the assistant must search the same way before and after. The second walk cannot become wider, narrower, renamed, reordered, or smarter just because the assistant wants a better result.

LIVE BEHAVIOR PROOF:
The method prevented immediate mule-return review.
It forced the AFTER walk.
The AFTER walk found specific blockers.
The blockers were repaired.
The same-shape AFTER walk reran clean.
Only then did the mule return become reviewable.

DIRECTION:
This is a useful working method for feeling project direction through evidence. It does not replace proof; it improves proof routing.

RISK:
If over-applied, it becomes too stiff. The rule should not force the full file/receipt machine for every tiny chat correction.

FIT:
- Chat behavior mirror: yes.
- Brain learning: yes.
- Doctrine: no.
- Active guide rewrite: no.
- CURRENT_TRUTH_INDEX rewrite: no.
- Automation/dashboard: no.
- Broad cleanup: no.
'@

Set-Content -LiteralPath $BrainRulePath -Value $BrainRule -Encoding UTF8
Set-Content -LiteralPath $BrainCapturePath -Value $BrainCapture -Encoding UTF8

$BrainRuleHash = Get-FileHash -Algorithm SHA256 -LiteralPath $BrainRulePath
$BrainCaptureHash = Get-FileHash -Algorithm SHA256 -LiteralPath $BrainCapturePath

$StatusAdd = @"

---

## Same-Shape Direction-Feel Rule Capture — $Stamp

Status: saved as brain learning and sorting-bench capture.
Old base: $OldHead
Files:
- $BrainRuleRel
- $BrainCaptureRel
Boundary: no doctrine promotion, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no automation, no dashboard, no broad cleanup.
Next: use the same-shape before/after method when stateful direction comparison matters; keep the heavy route trigger-based.
"@

Add-Content -LiteralPath $BrainStatusPath -Value $StatusAdd -Encoding UTF8

$BrainStatusHash = Get-FileHash -Algorithm SHA256 -LiteralPath $BrainStatusPath

$BrainReceipt = @"
SAME-SHAPE HOUSE WALK DIRECTION-FEEL LOCK RECEIPT
Timestamp: $Stamp
Old base: $OldHead
Remote before: $RemoteBefore
Verdict target: SAVE TO CHAT-SUPPORT SURFACE AND BRAIN / NO DOCTRINE PROMOTION

Local assistant files:
- $LocalCapturePath
  SHA256: $($LocalCaptureHash.Hash)
- $LocalJournalPath
  SHA256: $($LocalJournalHash.Hash)
- $LocalDropPath
  SHA256: $($LocalDropHash.Hash)
- Method patch: $MethodPatchStatus
- Method SHA256: $LocalMethodHashText

Brain files:
- $BrainRuleRel
  SHA256: $($BrainRuleHash.Hash)
- $BrainCaptureRel
  SHA256: $($BrainCaptureHash.Hash)
- $BrainStatusRel
  SHA256: $($BrainStatusHash.Hash)

Boundary:
- Chat behavior support saved where chat belongs.
- Brain learning saved in Mr.Kleen repo.
- No doctrine promotion.
- No ACTIVE_GUIDES rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.
- No dashboard.
- No broad cleanup.
- No public export beyond normal Git remote push of the brain repo.

Final Git proof is printed by the launcher after commit and push.
"@

Set-Content -LiteralPath $BrainReceiptPath -Value $BrainReceipt -Encoding UTF8
$BrainReceiptHash = Get-FileHash -Algorithm SHA256 -LiteralPath $BrainReceiptPath

# Archive this installer if it is run from Desktop\123.
$ScriptArchive = "Not running from porch"
if ($PSCommandPath) {
    $SelfFull = [System.IO.Path]::GetFullPath($PSCommandPath)
    $PorchFull = [System.IO.Path]::GetFullPath($Porch)
    if ($SelfFull.StartsWith($PorchFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        $ArchivePath = Join-Path $LocalCloseout (Split-Path -Leaf $PSCommandPath)
        Move-Item -LiteralPath $PSCommandPath -Destination $ArchivePath -Force
        if (-not (Test-Path -LiteralPath $ArchivePath)) { throw "BLOCKED: script archive failed: $ArchivePath" }
        $ScriptArchive = $ArchivePath
    }
}

$LocalReceiptPath = Join-Path $LocalReceiptDir ("SAME_SHAPE_DIRECTION_FEEL_CHAT_AND_BRAIN_SAVE_RECEIPT_$Stamp.txt")
$LocalReceipt = @"
SAME-SHAPE DIRECTION-FEEL CHAT AND BRAIN SAVE RECEIPT
Timestamp: $Stamp

Local assistant save:
- $LocalCapturePath
  SHA256: $($LocalCaptureHash.Hash)
- $LocalJournalPath
  SHA256: $($LocalJournalHash.Hash)
- $LocalDropPath
  SHA256: $($LocalDropHash.Hash)
- Method patch: $MethodPatchStatus
- Method SHA256: $LocalMethodHashText

Brain save targets:
- $BrainRuleRel
  SHA256: $($BrainRuleHash.Hash)
- $BrainCaptureRel
  SHA256: $($BrainCaptureHash.Hash)
- $BrainReceiptRel
  SHA256: $($BrainReceiptHash.Hash)
- $BrainStatusRel
  SHA256: $($BrainStatusHash.Hash)

Installer archive:
- $ScriptArchive

Boundary:
- Local chat support updated.
- Brain repo save prepared and committed by this same run.
- No doctrine promotion.
- No ACTIVE_GUIDES rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.
- No dashboard.
- No broad cleanup.
"@
Set-Content -LiteralPath $LocalReceiptPath -Value $LocalReceipt -Encoding UTF8

# Git add / commit / push
$Targets = @(
    $BrainRuleRel,
    $BrainCaptureRel,
    $BrainReceiptRel,
    $BrainStatusRel
)

Invoke-GitChecked -Repo $BrainRepo -Args (@("add") + $Targets) | Out-Null

$StatusStaged = (Invoke-GitChecked -Repo $BrainRepo -Args @("status","--short")) -join "`n"
if ($StatusStaged.Trim().Length -eq 0) {
    throw "BLOCKED: no staged brain changes found."
}

Invoke-GitChecked -Repo $BrainRepo -Args @("commit","-m","Add same-shape direction feel rule") | Out-Null
Invoke-GitChecked -Repo $BrainRepo -Args @("push","origin","main") | Out-Null

$NewHead = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","HEAD")).Trim()
Invoke-GitChecked -Repo $BrainRepo -Args @("fetch","origin","main") | Out-Null
$RemoteAfter = (Invoke-GitChecked -Repo $BrainRepo -Args @("rev-parse","origin/main")).Trim()
$StatusAfter = (Invoke-GitChecked -Repo $BrainRepo -Args @("status","--short")) -join "`n"

if ($NewHead -ne $RemoteAfter) {
    throw "BLOCKED: push verification failed. Local: $NewHead Remote: $RemoteAfter"
}
if ($StatusAfter.Trim().Length -ne 0) {
    throw "BLOCKED: brain repo not clean after save.`n$StatusAfter"
}

Write-Host "SAME-SHAPE DIRECTION-FEEL SAVED TO CHAT AND BRAIN"
Write-Host "Local receipt: $LocalReceiptPath"
Write-Host "Brain receipt: $BrainReceiptRel"
Write-Host "Old base: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteAfter"
Write-Host "Status: clean"
Write-Host "Verdict: PASS / CHAT SUPPORT UPDATED / BRAIN COMMITTED AND PUSHED / NO DOCTRINE PROMOTION"
