# REPAIR_MULE_BOSS_WHEEL_APPLY_ALL_LOCAL_ONLY_V1.1.ps1
# Local-only repair. No Git commit. No push. No public export.

$ErrorActionPreference = "Stop"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Root = Join-Path $env:USERPROFILE "Desktop\123\MULE_LOCAL_ONLY\BOSS_POOL_WHEEL"
$ReceiptDir = Join-Path $Root "RECEIPTS"
New-Item -ItemType Directory -Path $Root,$ReceiptDir -Force | Out-Null

$RepairPath = Join-Path $Root "MULE_BOSS_POOL_WHEEL_APPLY_ALL_REPAIR_V1.1.md"
$KickoffPath = Join-Path $Root "MULE_BOSS_POOL_WHEEL_KICKOFF_V1.1.md"
$LockAddendumPath = Join-Path $Root "MULE_BOSS_POOL_WHEEL_LOCAL_ONLY_LOCK_ADDENDUM_V1.1.md"
$ReceiptPath = Join-Path $ReceiptDir ("MULE_BOSS_POOL_WHEEL_APPLY_ALL_REPAIR_RECEIPT_{0}.txt" -f $Stamp)

$Repair = @'
# Mule Boss Pool Wheel — Apply-All Repair — V1.1

STATUS: LOCAL-ONLY REPAIR LOCK

VERDICT:
The previous save completed the local file surface but under-applied the same-pass behavior surface.

FAILURE:
The save treated "write local-only mule files" as complete even though the user also required:
- load it in chat;
- keep it in assistant head;
- use it to fill blanks when the actual brain is missing the three local-only mule files;
- make this the new mule-run lock shape.

ROOT CAUSES / WHYS:

1. TASK COLLAPSE TOO NARROW
The active task was collapsed to "create local files" instead of "create local files + apply new operating behavior."

2. LOCAL-ONLY BOUNDARY OVER-WEIGHTED
The no-Git/no-public boundary was handled correctly, but it crowded out the behavioral-carryover requirement.

3. ARTIFACT-VS-BEHAVIOR SPLIT
The file artifact was treated as separate from assistant behavior, even though the user explicitly tied them together.

4. MISSING APPLY-ALL GATE
The save did not require proof that every selected surface was updated before final report.

5. INSTRUCTION PARSING MISS
The phrase "you can load them in the chat too to keep it in your head" should have been interpreted as a required memory/carryover action, not optional commentary.

6. THREE-FILE ABSENCE SIGNAL MISREAD
The note "it is missing from the actual brain" should have triggered a blank-fill memory rule immediately.

7. FALSE COMPLETION RISK
The final report said the local save was done but did not explicitly prove behavioral carryover was also done.

8. MULTI-SURFACE SAVE NOT CHECKED
The task had multiple surfaces: local files, receipt, kickoff, operating memory, final report. The save checked only the local files/receipt surface.

9. NEW-WAY LOCK NOT TREATED AS NEW-WAY
"Make all of this now the new way lock and save" means the run shape becomes default behavior for that class of mule work. It was not enough to write files.

10. NO FINAL COMPLETENESS CHECK
Before final reporting, the assistant should have checked:
- Are all files saved?
- Is local-only boundary preserved?
- Is chat/head carryover applied?
- Is the fill-in-the-blanks rule active?
- Is the receipt/final report explicit about both surfaces?

REPAIR RULE:
For local-only mule support saves, apply-all-at-once is mandatory.

When the user asks for local-only mule run files and also asks to keep them in chat/head/use them to fill blanks/new way/new lock:
1. save/update local files;
2. write receipt;
3. apply chat/head behavior carryover;
4. explicitly report both surfaces;
5. block final PASS if either surface is missing.

BOUNDARY:
- Local-only.
- No Git.
- No push.
- No public export.
- No doctrine promotion.
- No ACTIVE_GUIDE rewrite.
- No CURRENT_TRUTH_INDEX rewrite.

STATE AFTER REPAIR:
The 0 Judge + 12 Gates mule boss-pool wheel is local-only support and assistant-facing carryover for mule-file boss-pool runs.
'@

$LockAddendum = @'
# Mule Boss Pool Wheel — Local-Only Lock Addendum — V1.1

APPLY-ALL REQUIREMENT:
This local-only mule support packet has two required surfaces:

1. FILE SURFACE
The local mule files must exist under:
C:\Users\<user>\Desktop\123\MULE_LOCAL_ONLY\BOSS_POOL_WHEEL

2. BEHAVIOR SURFACE
The assistant must remember and apply the 0 Judge + 12 Gates wheel for mule-file boss-pool runs when the actual brain lacks these local-only files.

A save is not complete until both surfaces are done.

DEFAULT MULE-FILE BOSS-POOL SHAPE:
0 Judge center.
1 Anchor.
2 Run Lock.
3 Authority.
4 File Role.
5 Version Drift.
6 Neighbor Fit.
7 Mirror/Opposite Check.
8 Controller/Spine Fit.
9 Expansion.
10 Output Shape.
11 No Promotion.
12 Fit Decision / Carryover.

FILL-IN-THE-BLANKS RULE:
Because these three mule files are local-only and intentionally not public/brain authority, the assistant should use this remembered structure to fill missing run-shape context during mule-file boss-pool work.

LIMIT:
This support shape cannot override current user instruction, controller gate, compact spine, active run lock, or safety boundary.
'@

$Kickoff = @'
TASK: MULE BOSS POOL WHEEL RUN V1.1

Use the local-only mule boss-pool wheel as the run shape.

LOCAL-ONLY BOUNDARY:
Private/local support only. Do not publish. Do not push. Do not treat as doctrine. Do not rewrite active guides. Do not rewrite CURRENT_TRUTH_INDEX.

APPLY-ALL CHECK:
Before returning PASS, confirm both:
- FILE SURFACE: local mule support files are present or identified.
- BEHAVIOR SURFACE: run uses 0 Judge + 12 Gates as the missing-context fill.

RUN ORDER:
0. Judge opens.
1. Anchor confirms current position.
2. Run Lock defines mode, scope, authority, input, output, stop, and expansion.
3. Authority decides what can command.
4. File Role gives every mule file a job.
5. Version Drift checks old vs current.
6. Neighbor Fit checks side-to-side compatibility.
7. Mirror/Opposite Check catches counter-risk.
8. Controller/Spine Fit checks minimal working set.
9. Expansion decides whether bigger context is allowed.
10. Output Shape formats the return.
11. No Promotion blocks authority changes.
12. Fit Decision / Carryover gives every object a disposition and names the next clean move.
0. Judge closes.

STOP:
Stop after one clean return or one expansion request.
'@

Set-Content -LiteralPath $RepairPath -Value $Repair -Encoding UTF8
Set-Content -LiteralPath $LockAddendumPath -Value $LockAddendum -Encoding UTF8
Set-Content -LiteralPath $KickoffPath -Value $Kickoff -Encoding UTF8

$Files = @($RepairPath,$LockAddendumPath,$KickoffPath)
$Hashes = foreach ($Path in $Files) {
    $H = Get-FileHash -Algorithm SHA256 -LiteralPath $Path
    [PSCustomObject]@{ Path = $Path; SHA256 = $H.Hash }
}

$ReceiptLines = @()
$ReceiptLines += "MULE BOSS POOL WHEEL APPLY-ALL REPAIR RECEIPT"
$ReceiptLines += "Timestamp: $Stamp"
$ReceiptLines += "Verdict: PASS / LOCAL-ONLY APPLY-ALL REPAIR SAVED"
$ReceiptLines += "Root: $Root"
$ReceiptLines += ""
$ReceiptLines += "Failure repaired:"
$ReceiptLines += "- Local file save was treated as complete before behavior carryover was explicitly applied."
$ReceiptLines += ""
$ReceiptLines += "Repair applied:"
$ReceiptLines += "- Broad why/root-cause map saved."
$ReceiptLines += "- Apply-all local-only lock addendum saved."
$ReceiptLines += "- V1.1 mule kickoff saved."
$ReceiptLines += "- Rule states file surface + behavior surface are both required before PASS."
$ReceiptLines += ""
$ReceiptLines += "Boundary:"
$ReceiptLines += "- No Git commit."
$ReceiptLines += "- No push."
$ReceiptLines += "- No public export."
$ReceiptLines += "- No doctrine promotion."
$ReceiptLines += "- No ACTIVE_GUIDE rewrite."
$ReceiptLines += "- No CURRENT_TRUTH_INDEX rewrite."
$ReceiptLines += ""
$ReceiptLines += "Files:"
foreach ($Item in $Hashes) {
    $ReceiptLines += ("- {0}" -f $Item.Path)
    $ReceiptLines += ("  SHA256: {0}" -f $Item.SHA256)
}

Set-Content -LiteralPath $ReceiptPath -Value ($ReceiptLines -join [Environment]::NewLine) -Encoding UTF8

Write-Host "MULE BOSS POOL WHEEL APPLY-ALL REPAIR COMPLETE"
Write-Host "Root: $Root"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Verdict: PASS / LOCAL-ONLY APPLY-ALL REPAIR / NO GIT / NO PUSH"
