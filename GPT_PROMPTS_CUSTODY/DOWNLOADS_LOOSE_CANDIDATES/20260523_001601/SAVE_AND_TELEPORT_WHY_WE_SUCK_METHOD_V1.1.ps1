# SAVE_AND_TELEPORT_WHY_WE_SUCK_METHOD_V1.1.ps1
# File-first local-only fix for the current "Why We Suck Sometimes" issue.
# Saves method + current issue application, patches router map, creates Desktop drop-copies,
# archives this script from the porch when run from Desktop\123, and writes a receipt.
# No Git. No push. No public export. No doctrine.

$ErrorActionPreference = "Stop"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

$Desktop = Join-Path $env:USERPROFILE "Desktop"
$Porch = Join-Path $Desktop "123"
$Root = Join-Path $Desktop "ASSISTANT_LOCAL"
$ChatRules = Join-Path $Root "CHAT_RULES_LOCAL_ONLY"
$ReceiptDir = Join-Path $Root "_RECEIPTS"
$Closeout = Join-Path $Root ("PORCH_CLOSEOUT\WHY_WE_SUCK_METHOD_V1.1_{0}" -f $Stamp)

New-Item -ItemType Directory -Path $ChatRules,$ReceiptDir,$Closeout -Force | Out-Null

$MethodName = "WHY_WE_SUCK_SOMETIMES_METHOD_V1.1.md"
$IssueName = "WHY_WE_SUCK_CURRENT_ISSUE_APPLICATION_20260522_V1.1.md"

$MethodPath = Join-Path $ChatRules $MethodName
$IssuePath = Join-Path $ChatRules $IssueName

$MethodDrop = Join-Path $Desktop ("CHAT_DROP_COPY__" + $MethodName)
$IssueDrop = Join-Path $Desktop ("CHAT_DROP_COPY__" + $IssueName)

$RouterPath = Join-Path $ChatRules "CHAT_COCKPIT_ROUTER_MAP_V1.0.md"
$RouterDrop = Join-Path $Desktop "CHAT_DROP_COPY__CHAT_COCKPIT_ROUTER_MAP_V1.0.md"

$ReceiptPath = Join-Path $ReceiptDir ("WHY_WE_SUCK_METHOD_V1.1_SAVE_RECEIPT_{0}.txt" -f $Stamp)

$Method = @'
# Why We Suck Sometimes Method — V1.1

STATUS: ACROSS-BOARD ASSISTANT FAILURE-REPAIR METHOD

PURPOSE:
When the assistant fails, this method forces a working repair instead of explanation-only behavior.

BOUNDARY:
- Local-only assistant behavior support.
- Not doctrine.
- Not Git.
- Not public.
- Does not replace Mr.Kleen.
- Does not rewrite ACTIVE_GUIDES.
- Does not rewrite CURRENT_TRUTH_INDEX.
- Does not authorize cleanup, deletion, merge, promotion, or broad rewrite.

WHEN THIS FIRES:
Use this when the user asks:
- why did you fail?
- why did that rule not work?
- make this the new method;
- add it;
- common sense;
- adopt/adapt;
- stop explaining and apply it;
- why are you not sending files/code to fix this?
- fix these issues cleanly.

CORE RULE:
Do not stop at explanation.
Apply the method to the current issue in the same response/work pass.

METHOD:
1. Intended job — what was the rule/workflow/tool supposed to do?
2. Actual behavior — what happened instead?
3. Issue list — what current issues remain open?
4. Missing active parts — trigger, lane, house-rule route, delivery surface, tools/resources, save surface, Desktop pickup, proof, Final Judge, common-sense step.
5. Working fix — apply the smallest fix that changes behavior, not only wording.
6. Disposition — adopt, adapt, park, or reject as ghost.
7. Proof route — if files are involved, save to the correct local surface, create Desktop pickup when needed, archive porch source, write receipt.
8. Repeat — if the fix does not solve the failure, run the method again.

COMMON SENSE RULE:
If the fix is obvious and low risk, apply it immediately.
If the fix changes files, rules, scope, or proof, route it to the correct surface and receipt.

PLACEMENT RULE:
For chat-side behavior methods, save to:
- chat behavior memory;
- ASSISTANT_LOCAL\CHAT_RULES_LOCAL_ONLY;
- Desktop CHAT_DROP_COPY pickup;
- local receipt.

ROUTER LINE:
ASSISTANT: for failure analysis / why-we-suck moments, go to house rules for rule-fit, no side mutation, delivery surface, proof/receipt validation, and Final Judge; then run this method.

SHORT FORM:
Job. Actual. Issues. Missing active parts. Smallest fix. Adopt/adapt/park/reject. Proof route. Repeat until it works.
'@

$Issue = @'
# Why We Suck Sometimes — Current Issue Application — 20260522 — V1.1

STATUS: CURRENT ISSUE FIX / LOCAL-ONLY CHAT BEHAVIOR SUPPORT

CURRENT USER CORRECTION:
The assistant defined the method and generated a script, but did not say why, did not apply the method to the current issue(s), and did not place the fix into the local file surfaces yet.

INTENDED JOB:
When the user said “make this the new method,” the assistant should:
1. define the failure-repair method;
2. apply it to the live failure immediately;
3. state the current issues;
4. save the method where it belongs;
5. update the router;
6. create Desktop pickup;
7. write proof/receipt.

ACTUAL FAILURE:
The assistant updated memory and generated a staged script, but did not fully apply the method to the current issue in the same response. That repeated the same pattern: making a fix object without fully closing the behavior loop.

CURRENT ISSUES:
1. Method was adopted in chat memory but not yet locally installed.
2. The first script was staged/download-only until run through the porch/local-save route.
3. The response did not clearly say why the failure happened.
4. The response did not list the live current issues before fixing them.
5. The router was not yet patched with the failure-analysis route.
6. Desktop pickup and receipt proof were not complete.

MISSING ACTIVE PARTS:
- current issue application;
- local chat-rule file;
- Desktop drop-copy;
- router addendum;
- receipt;
- porch closeout;
- proof language that says staged is not complete.

FIX APPLIED BY THIS V1.1 SCRIPT:
1. Saves the method as a local chat-rule file.
2. Saves this current-issue application as a local chat-rule file.
3. Creates Desktop pickup copies for both.
4. Patches the router map if present.
5. Refreshes router Desktop pickup if router exists.
6. Archives this script from Desktop\123 into porch closeout when run from the porch.
7. Writes a receipt.

DISPOSITION:
ADOPT across-board as assistant failure-repair behavior.
ADAPT locally through chat-rule surfaces.
Do not promote to doctrine.
Do not Git/public push.
Do not call complete unless the receipt exists.

FINAL JUDGE:
This issue is fixed only when the receipt exists and the files named in it exist.
'@

Set-Content -LiteralPath $MethodPath -Value $Method -Encoding UTF8
Set-Content -LiteralPath $IssuePath -Value $Issue -Encoding UTF8

Copy-Item -LiteralPath $MethodPath -Destination $MethodDrop -Force
Copy-Item -LiteralPath $IssuePath -Destination $IssueDrop -Force

$RouterPatched = "NO - router map not found"
if (Test-Path -LiteralPath $RouterPath) {
    $Router = Get-Content -LiteralPath $RouterPath -Raw
    if ($Router -notmatch "WHY_WE_SUCK_SOMETIMES_METHOD") {
        $RouterAdd = @'

---

## Router Addendum — Why We Suck Sometimes Method

ASSISTANT: for failure analysis, rule-not-working, correction loops, "why did you fail," "make this the new method," or "fix these issues cleanly," go to house rules for rule-fit, no side mutation, delivery surface, proof/receipt validation, and Final Judge.

Then run:
`WHY_WE_SUCK_SOMETIMES_METHOD_V1.1.md`

Do not answer with explanation only.
Apply the method to the current issue in the same response/work pass.
'@
        Add-Content -LiteralPath $RouterPath -Value $RouterAdd -Encoding UTF8
        $RouterPatched = "YES - V1.1 addendum appended"
    }
    else {
        $RouterPatched = "ALREADY PRESENT"
    }

    Copy-Item -LiteralPath $RouterPath -Destination $RouterDrop -Force
}

$RequiredOutputs = @($MethodPath,$IssuePath,$MethodDrop,$IssueDrop)
foreach ($Path in $RequiredOutputs) {
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "BLOCKED: expected output missing: $Path"
    }
}

$MethodHash = Get-FileHash -Algorithm SHA256 -LiteralPath $MethodPath
$IssueHash = Get-FileHash -Algorithm SHA256 -LiteralPath $IssuePath
$MethodDropHash = Get-FileHash -Algorithm SHA256 -LiteralPath $MethodDrop
$IssueDropHash = Get-FileHash -Algorithm SHA256 -LiteralPath $IssueDrop

$RouterHashText = "Router map not found"
$RouterDropHashText = "Router drop-copy not updated"
if (Test-Path -LiteralPath $RouterPath) {
    $RouterHashText = (Get-FileHash -Algorithm SHA256 -LiteralPath $RouterPath).Hash
}
if (Test-Path -LiteralPath $RouterDrop) {
    $RouterDropHashText = (Get-FileHash -Algorithm SHA256 -LiteralPath $RouterDrop).Hash
}

$ScriptArchive = "Not archived"
if ($PSCommandPath) {
    $SelfFull = [System.IO.Path]::GetFullPath($PSCommandPath)
    $PorchFull = [System.IO.Path]::GetFullPath($Porch)
    if ($SelfFull.StartsWith($PorchFull, [System.StringComparison]::OrdinalIgnoreCase)) {
        $SelfName = Split-Path -Leaf $PSCommandPath
        $ArchivePath = Join-Path $Closeout $SelfName
        Copy-Item -LiteralPath $PSCommandPath -Destination $ArchivePath -Force
        if (-not (Test-Path -LiteralPath $ArchivePath)) {
            throw "BLOCKED: script archive copy failed: $ArchivePath"
        }
        $ScriptArchive = $ArchivePath
    }
}

$ReceiptLines = @()
$ReceiptLines += "WHY WE SUCK SOMETIMES METHOD V1.1 SAVE RECEIPT"
$ReceiptLines += "Timestamp: $Stamp"
$ReceiptLines += "Verdict: PASS / METHOD AND CURRENT ISSUE APPLICATION SAVED / NO GIT / NO PUSH"
$ReceiptLines += ""
$ReceiptLines += "Saved method:"
$ReceiptLines += "- $MethodPath"
$ReceiptLines += "  SHA256: $($MethodHash.Hash)"
$ReceiptLines += ""
$ReceiptLines += "Saved current issue application:"
$ReceiptLines += "- $IssuePath"
$ReceiptLines += "  SHA256: $($IssueHash.Hash)"
$ReceiptLines += ""
$ReceiptLines += "Desktop pickup:"
$ReceiptLines += "- $MethodDrop"
$ReceiptLines += "  SHA256: $($MethodDropHash.Hash)"
$ReceiptLines += "- $IssueDrop"
$ReceiptLines += "  SHA256: $($IssueDropHash.Hash)"
$ReceiptLines += ""
$ReceiptLines += "Router:"
$ReceiptLines += "- Patch status: $RouterPatched"
$ReceiptLines += "- Router path: $RouterPath"
$ReceiptLines += "- Router SHA256: $RouterHashText"
$ReceiptLines += "- Router Desktop drop-copy: $RouterDrop"
$ReceiptLines += "- Router Desktop SHA256: $RouterDropHashText"
$ReceiptLines += ""
$ReceiptLines += "Porch closeout:"
$ReceiptLines += "- Script archive: $ScriptArchive"
$ReceiptLines += "- Closeout folder: $Closeout"
$ReceiptLines += ""
$ReceiptLines += "Boundary:"
$ReceiptLines += "- Local-only assistant behavior support."
$ReceiptLines += "- No Git commit."
$ReceiptLines += "- No push."
$ReceiptLines += "- No public export."
$ReceiptLines += "- Not doctrine."
$ReceiptLines += "- Not ACTIVE_GUIDES."
$ReceiptLines += "- Not CURRENT_TRUTH_INDEX."

Set-Content -LiteralPath $ReceiptPath -Value ($ReceiptLines -join [Environment]::NewLine) -Encoding UTF8

if (-not (Test-Path -LiteralPath $ReceiptPath)) {
    throw "BLOCKED: receipt missing after write: $ReceiptPath"
}

Write-Host "WHY WE SUCK METHOD V1.1 SAVE COMPLETE"
Write-Host "Method: $MethodPath"
Write-Host "Current issue application: $IssuePath"
Write-Host "Desktop pickups: $MethodDrop ; $IssueDrop"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Router patch: $RouterPatched"
Write-Host "Verdict: PASS / METHOD AND CURRENT ISSUE APPLICATION SAVED / NO GIT / NO PUSH"
