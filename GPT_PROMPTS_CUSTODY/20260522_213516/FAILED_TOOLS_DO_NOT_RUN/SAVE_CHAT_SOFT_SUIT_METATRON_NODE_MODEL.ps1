# SAVE_CHAT_SOFT_SUIT_METATRON_NODE_MODEL.ps1
# Purpose:
# Save the Chat Soft Suit / Metatron node / front-door return-home model into the GPT rule set workflow.
#
# Important user boundary:
# - This DOES NOT move anything into CURRENT.
# - CURRENT is user-controlled.
# - New/updated rules are written to READY_TO_DROP_IN_CHAT only.
# - If a same-name waiting rule already exists, it is overwritten with the newer/better same-name file.
# - GPT_Prompts root is the front door, not storage.
# - Tools/clutter are moved out of the front door into Desktop\123 custody.
# - Local-only. No Git. No push. No public export.

$ErrorActionPreference = "Stop"

$Root = Join-Path $env:USERPROFILE "Desktop\GPT_Prompts"
$Current = Join-Path $Root "CURRENT"
$Ready = Join-Path $Root "READY_TO_DROP_IN_CHAT"
$CustodyRoot = Join-Path $env:USERPROFILE "Desktop\123\GPT_PROMPTS_CUSTODY"
$Receipts = Join-Path $CustodyRoot "RECEIPTS"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$RunCustody = Join-Path $CustodyRoot $Stamp
$FailedTools = Join-Path $RunCustody "FAILED_TOOLS_DO_NOT_RUN"
$Archive = Join-Path $RunCustody "CUSTODY_ARCHIVE"
$IssueReview = Join-Path $RunCustody "ISSUE_REVIEW"

New-Item -ItemType Directory -Path $Root,$Current,$Ready,$CustodyRoot,$Receipts,$RunCustody,$FailedTools,$Archive,$IssueReview -Force | Out-Null

$Updated = New-Object System.Collections.Generic.List[string]
$CopiedBase = New-Object System.Collections.Generic.List[string]
$CreatedBase = New-Object System.Collections.Generic.List[string]
$Moved = New-Object System.Collections.Generic.List[string]
$Bell = New-Object System.Collections.Generic.List[string]

function Move-ToNode {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$NodeDir,
        [Parameter(Mandatory=$true)][string]$Label
    )
    if (!(Test-Path -LiteralPath $Path)) { return }
    New-Item -ItemType Directory -Path $NodeDir -Force | Out-Null
    $Leaf = Split-Path -Leaf $Path
    $Dest = Join-Path $NodeDir $Leaf
    if (Test-Path -LiteralPath $Dest) {
        $SafeLeaf = "{0}__COLLISION_{1}{2}" -f [IO.Path]::GetFileNameWithoutExtension($Leaf), (Get-Date -Format "HHmmssfff"), [IO.Path]::GetExtension($Leaf)
        if ((Get-Item -LiteralPath $Path).PSIsContainer) {
            $SafeLeaf = "$Leaf`__COLLISION_$(Get-Date -Format 'HHmmssfff')"
        }
        $Dest = Join-Path $NodeDir $SafeLeaf
    }
    Move-Item -LiteralPath $Path -Destination $Dest -Force
    $Moved.Add("$Label :: $Path -> $Dest") | Out-Null
}

function Find-BaseRule {
    param([Parameter(Mandatory=$true)][string]$Name)

    $CandidatePaths = @(
        (Join-Path $Ready $Name),
        (Join-Path $Current $Name),
        (Join-Path $Root "CHAT_GATE_SYSTEM_PACKAGE\$Name"),
        (Join-Path $Root ".GPT_PROMPTS_HOME\CHAT_GATE_SYSTEM_PACKAGE\$Name")
    )

    foreach ($P in $CandidatePaths) {
        if (Test-Path -LiteralPath $P) { return $P }
    }

    $Found = Get-ChildItem -LiteralPath $Root -Filter $Name -File -Recurse -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notlike "$Ready*" } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($Found) { return $Found.FullName }
    return $null
}

function Ensure-ReadyRule {
    param(
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][string]$Title
    )

    $Target = Join-Path $Ready $Name
    if (!(Test-Path -LiteralPath $Target)) {
        $Base = Find-BaseRule -Name $Name
        if ($Base) {
            Copy-Item -LiteralPath $Base -Destination $Target -Force
            $CopiedBase.Add("$Name <= $Base") | Out-Null
        } else {
            @(
                "# $Title",
                "",
                "STATUS: CHAT SOFT SUIT RULE / READY TO DROP IN CHAT / NOT CURRENT UNTIL USER MOVES IT",
                "",
                "NOTE:",
                "This file was created because no existing same-name base rule was found locally.",
                "It is waiting in READY_TO_DROP_IN_CHAT for user review/drop into chat.",
                "It must not be treated as CURRENT until the user moves it to CURRENT."
            ) | Set-Content -LiteralPath $Target -Encoding UTF8
            $CreatedBase.Add($Name) | Out-Null
        }
    }
    return $Target
}

function Upsert-Section {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Marker,
        [Parameter(Mandatory=$true)][string]$Section
    )

    $Text = ""
    if (Test-Path -LiteralPath $Path) {
        $Text = Get-Content -LiteralPath $Path -Raw
    }

    $Start = "<!-- $Marker START -->"
    $End = "<!-- $Marker END -->"
    $Block = "$Start`r`n$Section`r`n$End"
    $Pattern = [regex]::Escape($Start) + ".*?" + [regex]::Escape($End)

    if ($Text -match $Pattern) {
        $Text = [regex]::Replace($Text, $Pattern, $Block, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    } else {
        $Text = $Text.TrimEnd() + "`r`n`r`n" + $Block + "`r`n"
    }

    Set-Content -LiteralPath $Path -Value $Text -Encoding UTF8
    $Updated.Add((Split-Path -Leaf $Path)) | Out-Null
}

$Marker = "CHAT_SOFT_SUIT_METATRON_NODE_RETURN_HOME_MODEL"

$Section00 = @'
## Chat Soft Suit / Metatron Node / Return-Home Model

GPT_Prompts is the Chat Soft Suit workspace, not a general shed.

The root is the front-door node:
- it welcomes dropped files/packages;
- identifies what arrived;
- explains what is up;
- routes to the right friendly neighbor node/suit;
- writes or points to proof/status;
- returns the object to a known home state.

Node law:
A node is not only a folder. A node is a suited point with a home, purpose, checks, allowed paths, blocked paths, proof/status, neighbor handoff, and final judge.

Metatron law:
Each node may point in multiple lawful directions, but every route must return home. No line should leave loose debris, unknown state, or a half-current rule.

Return-home states:
- CURRENT;
- READY_TO_DROP_IN_CHAT;
- FAILED_TOOLS_DO_NOT_RUN;
- CUSTODY_ARCHIVE;
- RECEIPTS;
- ISSUE_REVIEW.

User-control law:
The assistant/local tool must not move new rules into CURRENT. The user moves reviewed/dropped rules into CURRENT. Until then, updated files remain READY_TO_DROP_IN_CHAT.

Bell law:
If READY_TO_DROP_IN_CHAT contains files that are missing from CURRENT or differ from CURRENT, ring the bell:
BELL: updated Chat Soft Suit files are waiting. They are not CURRENT until you move them.

Overwrite law:
If the same waiting rule updates again before the user moves it, overwrite the same stable filename in READY_TO_DROP_IN_CHAT. Do not create duplicate versions.
'@

$Section01 = @'
## Router Addendum — Chat Soft Suit Front Door Node

For GPT_Prompts, prompt packages, chat rules, rule drops, waiting files, current files, failed tools, or package clutter:

ASSISTANT: go to the Chat Soft Suit Front Door Node.

The Front Door Node must:
1. welcome/read what arrived;
2. identify whether it is a rule, source package, tool, failed tool, receipt, or unclear object;
3. route to the correct friendly neighbor node;
4. refuse to treat waiting files as CURRENT;
5. ring the bell when user action is needed;
6. return every object to a known home state.

Forks:
- GPT rule file -> READY_TO_DROP_IN_CHAT unless user has already moved it to CURRENT.
- accepted/current rule file -> CURRENT only by user action.
- failed/broken script -> FAILED_TOOLS_DO_NOT_RUN.
- old package/source/debris -> CUSTODY_ARCHIVE.
- proof/status -> RECEIPTS.
- unclear/conflicting/duplicate -> ISSUE_REVIEW.
'@

$Section08 = @'
## GPT_Prompts Chat Soft Suit Workspace Rule

`C:\Users\13527\Desktop\GPT_Prompts` is the Chat Soft Suit workspace.

It is only for GPT rule-set material that matches and flows with the build/model/concept/neighbors/cycles.

Visible working lanes:
- CURRENT
- READY_TO_DROP_IN_CHAT

Root/front door:
The root is only a drop-off/front-door node. It should not stay cluttered. Dropped items must be welcomed, identified, routed, and returned home.

CURRENT:
Only the user makes a rule current by moving it here after review/drop into chat.

READY_TO_DROP_IN_CHAT:
Assistant/local tool writes updated/new Chat Soft Suit rule files here. These are waiting for user action. They are not current.

Bell:
If READY_TO_DROP_IN_CHAT has waiting files, or has a same-name file that differs from CURRENT, tell the user.

Stable overwrite:
Update same-name waiting files in place. Do not create version clutter.

Blocked:
- Git add/commit/push;
- public export;
- doctrine promotion;
- failed tools sitting with rule files;
- source/archive/receipts cluttering the visible front door.
'@

$Section14 = @'
## Chat Soft Suit Node Map — Metatron Return-Home Shape

| Node/Suit | Home | Welcomes | Points To | Return-Home State |
|---|---|---|---|---|
| Front Door Node | GPT_Prompts root | raw drops/packages/files | Ready, Current, Failed Tool, Custody, Receipts, Issue Review | item sorted; root clean |
| Ready Node | READY_TO_DROP_IN_CHAT | new/updated rules | user chat drop, Bell, Current after user move | waiting for user |
| Current Node | CURRENT | user-accepted rules | Router, active Chat Suit use | current truth |
| Failed Tool Node | FAILED_TOOLS_DO_NOT_RUN | broken scripts/tools | Issue Review, Custody | blocked/not runnable |
| Custody Node | CUSTODY_ARCHIVE | old package/source/debris | Source Link, Issue Review | preserved source |
| Receipt Node | RECEIPTS | proof/status | Final Judge, Bell | proof stored |
| Issue Review Node | ISSUE_REVIEW | unclear/conflicting/duplicate objects | Stop/Fix, Ready, Custody, Failed Tool | issue named |

No node is king.
Each node can point in multiple ways.
Every route must close by returning the object to a known home state.
'@

$Section15 = @'
## Metatron Node Law / Friendly Suit Welcome

A Suit node behaves like a friendly point in a lawful node graph.

It must say:
- hello, this is my home;
- this is what arrived;
- this is what it means;
- these are the safe neighbor paths;
- this is the path I choose and why;
- this is the return-home state.

Metatron rule:
The node may point in more than one direction. The point is not one-way storage. It is a living route selector.

Return-home rule:
Every outward route must bring the object back to a known home/status. If the route cannot return home, route to ISSUE_REVIEW and stay blocked.
'@

$Section16 = @'
## Source Capture — Chat Soft Suit Front Door / Metatron Node Model

Captured points:
- GPT_Prompts is the Chat Soft Suit workspace.
- It is for GPT rule sets that match and flow with the build/model/concept/neighbors/cycles.
- Root is the package/file drop-off front door.
- The assistant/local tool sorts dropped items.
- READY_TO_DROP_IN_CHAT means user action is needed.
- CURRENT is only current after the user moves files there.
- If the user forgets, ring the bell.
- If a waiting rule updates again, overwrite the same stable filename.
- Bad tools do not live with rules.
- Receipts/source/custody do not clutter the visible Chat Soft Suit lanes.
- Each node is a friendly suited point.
- Each node can point in multiple directions by fit, risk, proof, boundary, route, and need.
- Think Metatron's Cube: lawful points and lines, not random folders.
- The route must also bring the object back home.
- No node is king.
- Drop -> welcome -> identify -> route -> proof/status -> return home.
'@

$SectionManifest = @'
## Chat Soft Suit Workspace / User Action Lanes

This package now recognizes the Chat Soft Suit workspace model.

Visible lanes:
- CURRENT
- READY_TO_DROP_IN_CHAT

CURRENT:
User-controlled current rule set. The assistant/local tool must not silently place new files here.

READY_TO_DROP_IN_CHAT:
Assistant-prepared new/updated rule files waiting for the user to drop into chat and then move into CURRENT.

Bell condition:
If READY_TO_DROP_IN_CHAT contains files missing from CURRENT or different from CURRENT, user action is waiting.

Boundary:
Local-only. No Git. No push. No public export. Not doctrine.
'@

$Targets = @(
    @{Name="00_LOAD_FIRST__CHAT_GATE_SYSTEM.md"; Title="LOAD FIRST — CHAT GATE SYSTEM"; Section=$Section00},
    @{Name="01_TASK_ROUTER_GATE.md"; Title="TASK ROUTER GATE"; Section=$Section01},
    @{Name="08_LOCAL_ONLY_PROMPT_PACKAGE_GATE.md"; Title="LOCAL-ONLY PROMPT PACKAGE GATE"; Section=$Section08},
    @{Name="14_CHAT_SUIT_HOUSE_LINK_MAP.md"; Title="CHAT SUIT HOUSE LINK MAP"; Section=$Section14},
    @{Name="15_RESPECTFUL_SUIT_MAP_AND_FORKS_GATE.md"; Title="RESPECTFUL SUIT MAP + FORKS GATE"; Section=$Section15},
    @{Name="16_SOURCE_LINKS_AND_PROOF.md"; Title="SOURCE LINKS AND PROOF"; Section=$Section16},
    @{Name="MANIFEST.md"; Title="CHAT GATE SYSTEM PACKAGE MANIFEST"; Section=$SectionManifest}
)

foreach ($T in $Targets) {
    $Path = Ensure-ReadyRule -Name $T.Name -Title $T.Title
    Upsert-Section -Path $Path -Marker $Marker -Section $T.Section
}

# Clean the visible front door into nodes. Do not touch CURRENT or READY_TO_DROP_IN_CHAT.
$AllowedRoot = @("CURRENT","READY_TO_DROP_IN_CHAT")
$RootItems = @(Get-ChildItem -LiteralPath $Root -Force -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -ne "desktop.ini" -and ($AllowedRoot -notcontains $_.Name)
})

foreach ($Item in $RootItems) {
    if ($Item.PSIsContainer) {
        Move-ToNode -Path $Item.FullName -NodeDir $Archive -Label "CUSTODY_ARCHIVE"
    } elseif ($Item.Extension -ieq ".ps1") {
        Move-ToNode -Path $Item.FullName -NodeDir $FailedTools -Label "FAILED_TOOL"
    } else {
        Move-ToNode -Path $Item.FullName -NodeDir $IssueReview -Label "ISSUE_REVIEW"
    }
}

# Bell scan: READY vs CURRENT.
$ReadyFiles = @(Get-ChildItem -LiteralPath $Ready -File -ErrorAction SilentlyContinue)
foreach ($RF in $ReadyFiles) {
    $CF = Join-Path $Current $RF.Name
    if (!(Test-Path -LiteralPath $CF)) {
        $Bell.Add("BELL: $($RF.Name) is READY but not in CURRENT.") | Out-Null
    } else {
        $RH = (Get-FileHash -Algorithm SHA256 -LiteralPath $RF.FullName).Hash
        $CH = (Get-FileHash -Algorithm SHA256 -LiteralPath $CF).Hash
        if ($RH -ne $CH) {
            $Bell.Add("BELL: $($RF.Name) is READY and differs from CURRENT.") | Out-Null
        }
    }
}

$VisibleAfter = @(Get-ChildItem -LiteralPath $Root -Force -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -ne "desktop.ini" -and ($AllowedRoot -notcontains $_.Name)
})

$Receipt = Join-Path $Receipts "CHAT_SOFT_SUIT_METATRON_NODE_MODEL_SAVE_$Stamp.txt"

$Verdict = if ($VisibleAfter.Count -eq 0) {
    "PASS / CHAT SOFT SUIT NODE MODEL SAVED TO READY / FRONT DOOR CLEAN"
} else {
    "REVIEW / CHAT SOFT SUIT NODE MODEL SAVED / FRONT DOOR STILL HAS UNEXPECTED ITEMS"
}

@(
"CHAT SOFT SUIT METATRON NODE MODEL SAVE RECEIPT",
"Timestamp: $Stamp",
"Root/front door: $Root",
"Current lane: $Current",
"Ready lane: $Ready",
"Custody root: $CustodyRoot",
"",
"Updated READY files count: $($Updated.Count)",
"Copied base count: $($CopiedBase.Count)",
"Created base count: $($CreatedBase.Count)",
"Moved root clutter count: $($Moved.Count)",
"Bell count: $($Bell.Count)",
"Unexpected root item count after cleanup: $($VisibleAfter.Count)",
"",
"Updated READY files:",
(($Updated | Sort-Object -Unique) -join [Environment]::NewLine),
"",
"Copied base:",
($CopiedBase -join [Environment]::NewLine),
"",
"Created base:",
($CreatedBase -join [Environment]::NewLine),
"",
"Moved root clutter:",
($Moved -join [Environment]::NewLine),
"",
"Bell:",
($Bell -join [Environment]::NewLine),
"",
"Unexpected root items:",
(($VisibleAfter | ForEach-Object { $_.FullName }) -join [Environment]::NewLine),
"",
"Boundary:",
"- Local-only.",
"- No Git.",
"- No push.",
"- No public export.",
"- Did not move anything into CURRENT.",
"- READY_TO_DROP_IN_CHAT contains waiting updates for user action.",
"",
"Verdict: $Verdict"
) | Set-Content -LiteralPath $Receipt -Encoding UTF8

Write-Host "CHAT SOFT SUIT METATRON NODE MODEL SAVE COMPLETE"
Write-Host "Ready lane: $Ready"
Write-Host "Current lane: $Current"
Write-Host "Receipt: $Receipt"
Write-Host "Updated READY files count: $($Updated.Count)"
Write-Host "Bell count: $($Bell.Count)"
Write-Host "Unexpected root item count after cleanup: $($VisibleAfter.Count)"
if ($Bell.Count -gt 0) {
    Write-Host ""
    Write-Host "BELL:"
    $Bell | ForEach-Object { Write-Host $_ }
}
Write-Host "Verdict: $Verdict"
