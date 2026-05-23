# FIX_GPT_PROMPTS_FRONT_DOOR_MAIL_DROP_V1.1.ps1
# Corrected front-door fixer.
# Fixes previous failure: PowerShell $HOME is read-only, so this script does NOT use $Home.
# Goal: Desktop\GPT_Prompts is a clean mail-drop/front door.
# Hidden home holds active rules, intake, processed source, and receipts.
# Local-only. No Git. No push. No public export. No delete of source content.

$ErrorActionPreference = "Stop"

$FrontDoor = Join-Path $env:USERPROFILE "Desktop\GPT_Prompts"
$HiddenRoot = Join-Path $FrontDoor ".GPT_PROMPTS_HOME"
$CurrentSet = Join-Path $HiddenRoot "CHAT_GATE_SYSTEM_PACKAGE"
$HiddenIntake = Join-Path $HiddenRoot "_PACKAGE_INTAKE"
$MailIntake = Join-Path $HiddenRoot "MAIL_INTAKE"
$Processed = Join-Path $HiddenIntake "PROCESSED"
$Receipts = Join-Path $HiddenIntake "RECEIPTS"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

New-Item -ItemType Directory -Path $FrontDoor,$HiddenRoot,$CurrentSet,$HiddenIntake,$MailIntake,$Processed,$Receipts -Force | Out-Null
attrib +h $HiddenRoot 2>$null

$Moved = New-Object System.Collections.Generic.List[string]
$Actions = New-Object System.Collections.Generic.List[string]

function Move-ContentsPreserve {
    param(
        [Parameter(Mandatory=$true)][string]$SourceDir,
        [Parameter(Mandatory=$true)][string]$DestDir,
        [Parameter(Mandatory=$true)][string]$Label
    )
    if (!(Test-Path -LiteralPath $SourceDir)) { return }
    New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
    $Items = Get-ChildItem -LiteralPath $SourceDir -Force -ErrorAction SilentlyContinue
    foreach ($Item in $Items) {
        Move-Item -LiteralPath $Item.FullName -Destination $DestDir -Force
        $Moved.Add("$Label :: $($Item.Name)") | Out-Null
    }
    # Remove only the now-empty visible shell folder if empty.
    $Left = @(Get-ChildItem -LiteralPath $SourceDir -Force -ErrorAction SilentlyContinue)
    if ($Left.Count -eq 0) {
        Remove-Item -LiteralPath $SourceDir -Force
        $Actions.Add("Removed empty visible shell folder: $SourceDir") | Out-Null
    } else {
        $Actions.Add("Visible shell folder not empty after move: $SourceDir") | Out-Null
    }
}

# 1. Move visible active rule room behind the front door, preserving its folder identity inside hidden home.
$VisibleActive = Join-Path $FrontDoor "CHAT_GATE_SYSTEM_PACKAGE"
Move-ContentsPreserve -SourceDir $VisibleActive -DestDir $CurrentSet -Label "ACTIVE_RULE_FILE"

# 2. Move visible package intake behind the front door.
$VisibleIntake = Join-Path $FrontDoor "_PACKAGE_INTAKE"
Move-ContentsPreserve -SourceDir $VisibleIntake -DestDir $HiddenIntake -Label "INTAKE_FILE"

# 3. Collect remaining visible front-door drops as mail.
$MailSession = Join-Path $MailIntake $Stamp
New-Item -ItemType Directory -Path $MailSession -Force | Out-Null

$Drops = Get-ChildItem -LiteralPath $FrontDoor -Force -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -ne ".GPT_PROMPTS_HOME" -and
    $_.Name -ne "desktop.ini"
}

foreach ($Drop in $Drops) {
    Move-Item -LiteralPath $Drop.FullName -Destination $MailSession -Force
    $Moved.Add("MAIL_DROP :: $($Drop.Name)") | Out-Null
}

# 4. If a complete package installer appears in mail intake, run it from the mail copy.
$Installer = Get-ChildItem -LiteralPath $MailSession -Filter "INSTALL_COMPLETE_CHAT_GATE_SYSTEM_PACKAGE.ps1" -File -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
if ($Installer) {
    $Actions.Add("Complete package installer found in mail; running installer: $($Installer.FullName)") | Out-Null
    Unblock-File $Installer.FullName -ErrorAction SilentlyContinue
    pwsh -NoProfile -ExecutionPolicy Bypass -File $Installer.FullName

    # Installer may recreate visible active folder. Pull it behind the front door again.
    if (Test-Path -LiteralPath $VisibleActive) {
        Move-ContentsPreserve -SourceDir $VisibleActive -DestDir $CurrentSet -Label "POST_INSTALL_ACTIVE_RULE_FILE"
    }
}

# 5. Verify required current-set files.
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

$Missing = New-Object System.Collections.Generic.List[string]
foreach ($R in $Required) {
    if (!(Test-Path -LiteralPath (Join-Path $CurrentSet $R))) {
        $Missing.Add($R) | Out-Null
    }
}

# 6. Visible-front-door check: normal view, excluding hidden home and desktop.ini.
$VisibleNow = Get-ChildItem -LiteralPath $FrontDoor -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -ne "desktop.ini"
}

$Receipt = Join-Path $Receipts "GPT_PROMPTS_FRONT_DOOR_MAIL_DROP_FIX_V1.1_$Stamp.txt"
$Lines = @()
$Lines += "GPT_PROMPTS FRONT DOOR MAIL DROP FIX V1.1"
$Lines += "Timestamp: $Stamp"
$Lines += "Front door: $FrontDoor"
$Lines += "Hidden root: $HiddenRoot"
$Lines += "Current active set: $CurrentSet"
$Lines += "Hidden intake: $HiddenIntake"
$Lines += "Mail intake session: $MailSession"
$Lines += ""
$Lines += "Moved count: $($Moved.Count)"
$Lines += "Required current-set files: $($Required.Count)"
$Lines += "Missing current-set files: $($Missing.Count)"
$Lines += "Visible front-door item count after fix: $(@($VisibleNow).Count)"
$Lines += ""
$Lines += "Moved:"
$Lines += ($Moved -join [Environment]::NewLine)
$Lines += ""
$Lines += "Actions:"
$Lines += ($Actions -join [Environment]::NewLine)
$Lines += ""
$Lines += "Missing:"
$Lines += ($Missing -join [Environment]::NewLine)
$Lines += ""
$Lines += "Visible front-door items:"
$Lines += (($VisibleNow | ForEach-Object { $_.FullName }) -join [Environment]::NewLine)
$Lines += ""
$Lines += "Boundary:"
$Lines += "- Local-only."
$Lines += "- No Git."
$Lines += "- No push."
$Lines += "- No public export."
$Lines += "- No source-content delete."
$Lines += "- Active rules moved behind front door."
$Lines += "- Front door is mail drop only."
if (@($VisibleNow).Count -eq 0 -and $Missing.Count -eq 0) {
    $Verdict = "PASS / FRONT DOOR CLEAN / CURRENT SET HIDDEN AND COMPLETE"
} elseif (@($VisibleNow).Count -eq 0) {
    $Verdict = "PASS WITH REVIEW / FRONT DOOR CLEAN / CURRENT SET MISSING FILES"
} else {
    $Verdict = "REVIEW / FRONT DOOR STILL HAS VISIBLE ITEMS"
}
$Lines += "Verdict: $Verdict"

Set-Content -LiteralPath $Receipt -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8

Write-Host "GPT_PROMPTS FRONT DOOR FIX V1.1 COMPLETE"
Write-Host "Front door: $FrontDoor"
Write-Host "Hidden current set: $CurrentSet"
Write-Host "Receipt: $Receipt"
Write-Host "Moved count: $($Moved.Count)"
Write-Host "Visible front-door item count: $(@($VisibleNow).Count)"
Write-Host "Missing current-set files: $($Missing.Count)"
Write-Host "Verdict: $Verdict"
