# FIX_GPT_PROMPTS_FRONT_DOOR_MAIL_DROP_V1.3.ps1
# Front-door fixer using SAFE COLLISION / CONTROLLED OVERWRITE.
# Known rooms collide into their intended hidden homes safely:
# - visible CHAT_GATE_SYSTEM_PACKAGE -> hidden .GPT_PROMPTS_HOME\CHAT_GATE_SYSTEM_PACKAGE
# - visible _PACKAGE_INTAKE -> hidden .GPT_PROMPTS_HOME\_PACKAGE_INTAKE
# Stable files overwrite. Directories merge. Nothing goes to Git. Nothing public.

$ErrorActionPreference = "Stop"

$FrontDoor = Join-Path $env:USERPROFILE "Desktop\GPT_Prompts"
$HiddenRoot = Join-Path $FrontDoor ".GPT_PROMPTS_HOME"
$CurrentSet = Join-Path $HiddenRoot "CHAT_GATE_SYSTEM_PACKAGE"
$HiddenIntake = Join-Path $HiddenRoot "_PACKAGE_INTAKE"
$Receipts = Join-Path $HiddenIntake "RECEIPTS"
$MailIntake = Join-Path $HiddenIntake "MAIL_INTAKE"
$Processed = Join-Path $HiddenIntake "PROCESSED"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

New-Item -ItemType Directory -Path $FrontDoor,$HiddenRoot,$CurrentSet,$HiddenIntake,$Receipts,$MailIntake,$Processed -Force | Out-Null
attrib +h $HiddenRoot 2>$null

$Moved = New-Object System.Collections.Generic.List[string]
$Overwritten = New-Object System.Collections.Generic.List[string]
$Merged = New-Object System.Collections.Generic.List[string]

function Merge-Safely {
    param(
        [Parameter(Mandatory=$true)][string]$SourceDir,
        [Parameter(Mandatory=$true)][string]$DestDir,
        [Parameter(Mandatory=$true)][string]$Label
    )
    if (!(Test-Path -LiteralPath $SourceDir)) { return }
    New-Item -ItemType Directory -Path $DestDir -Force | Out-Null

    foreach ($Item in Get-ChildItem -LiteralPath $SourceDir -Force) {
        $Dest = Join-Path $DestDir $Item.Name
        if ($Item.PSIsContainer) {
            if (!(Test-Path -LiteralPath $Dest)) {
                Move-Item -LiteralPath $Item.FullName -Destination $Dest -Force
                $Moved.Add("$Label DIR :: $($Item.FullName) -> $Dest") | Out-Null
            } else {
                $Merged.Add("$Label DIR MERGE :: $($Item.FullName) -> $Dest") | Out-Null
                Merge-Safely -SourceDir $Item.FullName -DestDir $Dest -Label $Label
                if (@(Get-ChildItem -LiteralPath $Item.FullName -Force -ErrorAction SilentlyContinue).Count -eq 0) {
                    Remove-Item -LiteralPath $Item.FullName -Force
                }
            }
        } else {
            if (Test-Path -LiteralPath $Dest) {
                $Overwritten.Add("$Label FILE OVERWRITE :: $Dest") | Out-Null
            } else {
                $Moved.Add("$Label FILE :: $($Item.FullName) -> $Dest") | Out-Null
            }
            Move-Item -LiteralPath $Item.FullName -Destination $Dest -Force
        }
    }

    if (@(Get-ChildItem -LiteralPath $SourceDir -Force -ErrorAction SilentlyContinue).Count -eq 0) {
        Remove-Item -LiteralPath $SourceDir -Force
    }
}

# Known visible rooms collide safely into hidden homes.
Merge-Safely -SourceDir (Join-Path $FrontDoor "CHAT_GATE_SYSTEM_PACKAGE") -DestDir $CurrentSet -Label "ACTIVE_ROOM"
Merge-Safely -SourceDir (Join-Path $FrontDoor "_PACKAGE_INTAKE") -DestDir $HiddenIntake -Label "INTAKE_ROOM"

# Any other visible front-door item is mail; preserve names under a dated intake.
$MailSession = Join-Path $MailIntake $Stamp
New-Item -ItemType Directory -Path $MailSession -Force | Out-Null
foreach ($Item in Get-ChildItem -LiteralPath $FrontDoor -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne ".GPT_PROMPTS_HOME" -and $_.Name -ne "desktop.ini" }) {
    $Dest = Join-Path $MailSession $Item.Name
    Move-Item -LiteralPath $Item.FullName -Destination $Dest -Force
    $Moved.Add("MAIL_DROP :: $($Item.FullName) -> $Dest") | Out-Null
}

# Verify current active set.
$Required = @(
"00_LOAD_FIRST__CHAT_GATE_SYSTEM.md","01_TASK_ROUTER_GATE.md","02_STOP_FIX_VERIFY_GATE.md",
"03_SMOKE_BREAK_FOCUS_GATE.md","04_CONDENSE_SOURCE_LINK_GATE.md","05_SELF_AUDIT_IDEA_CAPTURE_GATE.md",
"06_START_OVER_CARRY_FORWARD_GATE.md","07_NEIGHBOR_COMPOUND_GROWTH_GATE.md","08_LOCAL_ONLY_PROMPT_PACKAGE_GATE.md",
"09_SINGLE_LOAD_CARD.md","10_BABBLING_FOOL_GATE.md","11_SUIT_ADOPT_ADAPT_GATE.md",
"12_LIVE_IDEA_INTAKE_AND_NEIGHBOR_HANDOFF_GATE.md","13_HOUSE_LINKED_CHAT_SUIT_ARMATURE_GATE.md",
"14_CHAT_SUIT_HOUSE_LINK_MAP.md","15_RESPECTFUL_SUIT_MAP_AND_FORKS_GATE.md","16_SOURCE_LINKS_AND_PROOF.md","MANIFEST.md"
)
$Missing = @()
foreach ($R in $Required) { if (!(Test-Path -LiteralPath (Join-Path $CurrentSet $R))) { $Missing += $R } }

$VisibleNow = @(Get-ChildItem -LiteralPath $FrontDoor -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne "desktop.ini" })
$Receipt = Join-Path $Receipts "GPT_PROMPTS_FRONT_DOOR_SAFE_COLLISION_FIX_V1.3_$Stamp.txt"

$Verdict = if ($VisibleNow.Count -eq 0 -and $Missing.Count -eq 0) {
    "PASS / SAFE COLLISION MERGE COMPLETE / FRONT DOOR CLEAN / CURRENT SET COMPLETE"
} elseif ($VisibleNow.Count -eq 0) {
    "PASS WITH REVIEW / FRONT DOOR CLEAN / CURRENT SET MISSING FILES"
} else {
    "REVIEW / FRONT DOOR STILL HAS VISIBLE ITEMS"
}

@(
"GPT_PROMPTS FRONT DOOR SAFE COLLISION FIX V1.3",
"Timestamp: $Stamp",
"Front door: $FrontDoor",
"Hidden root: $HiddenRoot",
"Current set: $CurrentSet",
"Hidden intake: $HiddenIntake",
"Mail session: $MailSession",
"",
"Moved count: $($Moved.Count)",
"Overwritten file count: $($Overwritten.Count)",
"Merged directory count: $($Merged.Count)",
"Required files: $($Required.Count)",
"Missing required count: $($Missing.Count)",
"Visible front-door count: $($VisibleNow.Count)",
"",
"Moved:",
($Moved -join [Environment]::NewLine),
"",
"Overwritten:",
($Overwritten -join [Environment]::NewLine),
"",
"Merged:",
($Merged -join [Environment]::NewLine),
"",
"Missing:",
($Missing -join [Environment]::NewLine),
"",
"Visible front-door items:",
(($VisibleNow | ForEach-Object { $_.FullName }) -join [Environment]::NewLine),
"",
"Boundary: local-only; no Git; no push; no public export; controlled overwrite only at known homes; front door is mail drop only.",
"Verdict: $Verdict"
) | Set-Content -LiteralPath $Receipt -Encoding UTF8

Write-Host "GPT_PROMPTS SAFE COLLISION FRONT DOOR FIX COMPLETE"
Write-Host "Receipt: $Receipt"
Write-Host "Visible front-door count: $($VisibleNow.Count)"
Write-Host "Missing required count: $($Missing.Count)"
Write-Host "Verdict: $Verdict"
