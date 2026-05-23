# FIX_GPT_PROMPTS_FRONT_DOOR_MAIL_DROP.ps1
# Makes Desktop\GPT_Prompts behave like a clean front door/mail drop.
# Moves current visible rooms behind a hidden local home.
# Future drops can go directly into GPT_Prompts root; this tool intakes them and clears the front door.
# Local-only. No Git. No push. No public export. No delete.

$ErrorActionPreference = "Stop"

$Root = Join-Path $env:USERPROFILE "Desktop\GPT_Prompts"
$Home = Join-Path $Root ".GPT_PROMPTS_HOME"
$Current = Join-Path $Home "CURRENT_SET"
$Mail = Join-Path $Home "MAIL_INTAKE"
$Processed = Join-Path $Home "PROCESSED"
$Receipts = Join-Path $Home "RECEIPTS"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

if (!(Test-Path -LiteralPath $Root)) { New-Item -ItemType Directory -Path $Root -Force | Out-Null }
New-Item -ItemType Directory -Path $Home,$Current,$Mail,$Processed,$Receipts -Force | Out-Null
attrib +h $Home 2>$null

$OldActive = Join-Path $Root "CHAT_GATE_SYSTEM_PACKAGE"
$OldIntake = Join-Path $Root "_PACKAGE_INTAKE"

if (Test-Path -LiteralPath $OldActive) {
    if (Test-Path -LiteralPath $Current) {
        Get-ChildItem -LiteralPath $OldActive -Force | Move-Item -Destination $Current -Force
        Remove-Item -LiteralPath $OldActive -Force
    } else {
        Move-Item -LiteralPath $OldActive -Destination $Current -Force
    }
}

if (Test-Path -LiteralPath $OldIntake) {
    $OldHold = Join-Path $Processed "$Stamp`__OLD_PACKAGE_INTAKE"
    Move-Item -LiteralPath $OldIntake -Destination $OldHold -Force
}

$Drops = Get-ChildItem -LiteralPath $Root -Force | Where-Object {
    $_.Name -ne ".GPT_PROMPTS_HOME" -and
    $_.Name -notlike "README*" -and
    $_.Name -notlike "*.lnk"
}

$DropHold = Join-Path $Mail "$Stamp"
New-Item -ItemType Directory -Path $DropHold -Force | Out-Null

$MovedDrops = @()
foreach ($Item in $Drops) {
    Move-Item -LiteralPath $Item.FullName -Destination $DropHold -Force
    $MovedDrops += $Item.Name
}

# If dropped folder or zip contains complete package installer, run it from intake copy.
$Installer = Get-ChildItem -LiteralPath $DropHold -Filter "INSTALL_COMPLETE_CHAT_GATE_SYSTEM_PACKAGE.ps1" -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
if ($Installer) {
    Unblock-File $Installer.FullName -ErrorAction SilentlyContinue
    pwsh -NoProfile -ExecutionPolicy Bypass -File $Installer.FullName

    # Move installed package files from old visible target if installer recreated it.
    if (Test-Path -LiteralPath $OldActive) {
        Get-ChildItem -LiteralPath $OldActive -Force | Move-Item -Destination $Current -Force
        Remove-Item -LiteralPath $OldActive -Force
    }
}

$Required = @(
"00_LOAD_FIRST__CHAT_GATE_SYSTEM.md",
"01_TASK_ROUTER_GATE.md",
"02_STOP_FIX_VERIFY_GATE.md",
"03_SMOKE_BREAK_FOCUS_GATE.md",
"04_CONDENSE_SOURCE_LINK_GATE.md",
"05_SELF_AUDIT_IDEA_CAPTURE_GATE.md",
"06_START_OVER_CARRY_FORWARD_GATE.md",
"07_NEIGHBOR_COMPOUND_GROWTH_GATE.md",
"08_LOCAL_ONLY_PROMPT_PACKAGE_GATE.md",
"09_SINGLE_LOAD_CARD.md",
"10_BABBLING_FOOL_GATE.md",
"11_SUIT_ADOPT_ADAPT_GATE.md",
"12_LIVE_IDEA_INTAKE_AND_NEIGHBOR_HANDOFF_GATE.md",
"13_HOUSE_LINKED_CHAT_SUIT_ARMATURE_GATE.md",
"14_CHAT_SUIT_HOUSE_LINK_MAP.md",
"15_RESPECTFUL_SUIT_MAP_AND_FORKS_GATE.md",
"16_SOURCE_LINKS_AND_PROOF.md",
"MANIFEST.md"
)

$Missing = @()
foreach ($R in $Required) {
    if (!(Test-Path -LiteralPath (Join-Path $Current $R))) { $Missing += $R }
}

$FrontDoorItems = Get-ChildItem -LiteralPath $Root -Force | Where-Object { $_.Name -ne ".GPT_PROMPTS_HOME" }
$Receipt = Join-Path $Receipts "GPT_PROMPTS_FRONT_DOOR_MAIL_DROP_FIX_$Stamp.txt"
@(
"GPT_PROMPTS FRONT DOOR MAIL DROP FIX",
"Timestamp: $Stamp",
"Front door: $Root",
"Hidden home: $Home",
"Active current set: $Current",
"Mail intake: $Mail",
"Receipts: $Receipts",
"",
"Moved old active package to hidden current set: $(Test-Path -LiteralPath $Current)",
"Moved old intake behind front door: $(!(Test-Path -LiteralPath $OldIntake))",
"Dropped items moved this run: $($MovedDrops.Count)",
"Required current-set files missing: $($Missing.Count)",
"Front door visible item count after fix: $($FrontDoorItems.Count)",
"",
"Moved drops:",
($MovedDrops -join [Environment]::NewLine),
"",
"Missing current-set files:",
($Missing -join [Environment]::NewLine),
"",
"Remaining front-door items:",
(($FrontDoorItems | ForEach-Object { $_.FullName }) -join [Environment]::NewLine),
"",
"Boundary: local-only; no Git; no push; no public export; no delete; names preserved.",
"Verdict: $(if($FrontDoorItems.Count -eq 0 -and $Missing.Count -eq 0){"PASS / FRONT DOOR CLEAN / CURRENT SET HIDDEN AND COMPLETE"}elseif($FrontDoorItems.Count -eq 0){"PASS WITH REVIEW / FRONT DOOR CLEAN / CURRENT SET NEEDS REVIEW"}else{"REVIEW / FRONT DOOR STILL HAS ITEMS"})"
) | Set-Content -LiteralPath $Receipt -Encoding UTF8

Write-Host "GPT_PROMPTS FRONT DOOR FIX COMPLETE"
Write-Host "Front door: $Root"
Write-Host "Hidden current set: $Current"
Write-Host "Receipt: $Receipt"
Write-Host "Front door visible item count: $($FrontDoorItems.Count)"
Write-Host "Missing current-set files: $($Missing.Count)"
Write-Host "Verdict: $(if($FrontDoorItems.Count -eq 0 -and $Missing.Count -eq 0){"PASS / FRONT DOOR CLEAN / CURRENT SET HIDDEN AND COMPLETE"}elseif($FrontDoorItems.Count -eq 0){"PASS WITH REVIEW / FRONT DOOR CLEAN / CURRENT SET NEEDS REVIEW"}else{"REVIEW / FRONT DOOR STILL HAS ITEMS"})"
