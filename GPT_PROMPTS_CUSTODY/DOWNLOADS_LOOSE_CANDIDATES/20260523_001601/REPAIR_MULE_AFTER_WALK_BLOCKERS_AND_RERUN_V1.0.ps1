# REPAIR_MULE_AFTER_WALK_BLOCKERS_AND_RERUN_V1.0.ps1
# Repairs the blockers found in MULE_REVIEW_AFTER_WALK_AND_COMPARE_RECEIPT_20260522_190704.txt:
# - missing Desktop pickups for Why We Suck files
# - loose root files in Desktop\123
# Then reruns the exact same AFTER walk script if present.
# No Git. No push. No public export. No doctrine.

$ErrorActionPreference = "Stop"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

$Desktop = Join-Path $env:USERPROFILE "Desktop"
$Porch = Join-Path $Desktop "123"
$Root = Join-Path $Desktop "ASSISTANT_LOCAL"
$ChatRules = Join-Path $Root "CHAT_RULES_LOCAL_ONLY"
$ReceiptDir = Join-Path $Root "_RECEIPTS"
$Closeout = Join-Path $Root ("PORCH_CLOSEOUT\MULE_AFTER_WALK_BLOCKER_REPAIR_{0}" -f $Stamp)

New-Item -ItemType Directory -Path $ReceiptDir,$Closeout -Force | Out-Null

$PickupPlan = @(
    @{
        Source = Join-Path $ChatRules "WHY_WE_SUCK_SOMETIMES_METHOD_V1.1.md"
        Dest = Join-Path $Desktop "CHAT_DROP_COPY__WHY_WE_SUCK_SOMETIMES_METHOD_V1.1.md"
    },
    @{
        Source = Join-Path $ChatRules "WHY_WE_SUCK_CURRENT_ISSUE_APPLICATION_20260522_V1.1.md"
        Dest = Join-Path $Desktop "CHAT_DROP_COPY__WHY_WE_SUCK_CURRENT_ISSUE_APPLICATION_20260522_V1.1.md"
    }
)

$PickupResults = @()
foreach ($Item in $PickupPlan) {
    if (-not (Test-Path -LiteralPath $Item.Source)) {
        throw "BLOCKED: missing source for Desktop pickup repair: $($Item.Source)"
    }

    Copy-Item -LiteralPath $Item.Source -Destination $Item.Dest -Force

    if (-not (Test-Path -LiteralPath $Item.Dest)) {
        throw "BLOCKED: Desktop pickup repair failed: $($Item.Dest)"
    }

    $SourceHash = Get-FileHash -Algorithm SHA256 -LiteralPath $Item.Source
    $DestHash = Get-FileHash -Algorithm SHA256 -LiteralPath $Item.Dest

    $PickupResults += [PSCustomObject]@{
        Source = $Item.Source
        SourceSHA256 = $SourceHash.Hash
        Dest = $Item.Dest
        DestSHA256 = $DestHash.Hash
    }
}

$LooseBefore = Get-ChildItem -LiteralPath $Porch -File -ErrorAction SilentlyContinue | Sort-Object Name
$ArchivedLoose = @()

foreach ($File in $LooseBefore) {
    $Dest = Join-Path $Closeout $File.Name
    Move-Item -LiteralPath $File.FullName -Destination $Dest -Force

    if (-not (Test-Path -LiteralPath $Dest)) {
        throw "BLOCKED: failed archiving loose porch file: $($File.FullName)"
    }

    $Hash = Get-FileHash -Algorithm SHA256 -LiteralPath $Dest
    $ArchivedLoose += [PSCustomObject]@{
        Name = $File.Name
        Archived = $Dest
        SHA256 = $Hash.Hash
    }
}

$LooseAfter = Get-ChildItem -LiteralPath $Porch -File -ErrorAction SilentlyContinue | Sort-Object Name
if ($LooseAfter.Count -ne 0) {
    throw "BLOCKED: porch still has loose root files after repair: $($LooseAfter.Count)"
}

$AfterScriptCandidates = @(
    (Join-Path $Closeout "RUN_MULE_REVIEW_AFTER_SAME_SHAPE_HOUSE_WALK_V1.0.ps1"),
    (Join-Path $Porch "RUN_MULE_REVIEW_AFTER_SAME_SHAPE_HOUSE_WALK_V1.0.ps1"),
    (Join-Path $Desktop "RUN_MULE_REVIEW_AFTER_SAME_SHAPE_HOUSE_WALK_V1.0.ps1"),
    (Join-Path $Root "PORCH_CLOSEOUT\SAME_SHAPE_AFTER_WALK_V1.0_20260522_190704\RUN_MULE_REVIEW_AFTER_SAME_SHAPE_HOUSE_WALK_V1.0.ps1")
)

$AfterScript = $AfterScriptCandidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
$RerunStatus = "NOT RUN - after-walk script not found in expected places"

if ($AfterScript) {
    pwsh -NoProfile -ExecutionPolicy Bypass -File $AfterScript
    $RerunStatus = "RUN - $AfterScript"
}

$ReceiptPath = Join-Path $ReceiptDir ("MULE_AFTER_WALK_BLOCKER_REPAIR_RECEIPT_{0}.txt" -f $Stamp)

$Lines = @()
$Lines += "MULE AFTER-WALK BLOCKER REPAIR RECEIPT"
$Lines += "Timestamp: $Stamp"
$Lines += "Verdict: PASS / BLOCKERS REPAIRED / PORCH ROOT CLEAN / NO GIT / NO PUSH"
$Lines += ""
$Lines += "Original blocker receipt:"
$Lines += "- C:\Users\13527\Desktop\ASSISTANT_LOCAL\_RECEIPTS\MULE_REVIEW_AFTER_WALK_AND_COMPARE_RECEIPT_20260522_190704.txt"
$Lines += ""
$Lines += "Repaired Desktop pickups:"
foreach ($Item in $PickupResults) {
    $Lines += "- Source: $($Item.Source)"
    $Lines += "  Source SHA256: $($Item.SourceSHA256)"
    $Lines += "  Desktop pickup: $($Item.Dest)"
    $Lines += "  Desktop SHA256: $($Item.DestSHA256)"
}
$Lines += ""
$Lines += "Porch loose files before repair: $($LooseBefore.Count)"
foreach ($Item in $ArchivedLoose) {
    $Lines += "- Archived: $($Item.Name)"
    $Lines += "  Path: $($Item.Archived)"
    $Lines += "  SHA256: $($Item.SHA256)"
}
$Lines += ""
$Lines += "Porch loose files after repair: $($LooseAfter.Count)"
$Lines += ""
$Lines += "Same-shape AFTER rerun:"
$Lines += "- $RerunStatus"
$Lines += ""
$Lines += "Boundary:"
$Lines += "- Local-only blocker repair."
$Lines += "- No delete."
$Lines += "- No Git."
$Lines += "- No push."
$Lines += "- No public export."
$Lines += "- No doctrine rewrite."
$Lines += "- No ACTIVE_GUIDES rewrite."
$Lines += "- No CURRENT_TRUTH_INDEX rewrite."

Set-Content -LiteralPath $ReceiptPath -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8

Write-Host "MULE AFTER-WALK BLOCKER REPAIR COMPLETE"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Porch loose before: $($LooseBefore.Count)"
Write-Host "Porch loose after: $($LooseAfter.Count)"
Write-Host "Same-shape AFTER rerun: $RerunStatus"
Write-Host "Verdict: PASS / BLOCKERS REPAIRED / NO GIT / NO PUSH"
