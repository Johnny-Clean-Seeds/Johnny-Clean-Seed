param(
    [switch]$ExecuteRootClean,
    [switch]$SkipGitSave
)

$ErrorActionPreference = "Stop"

$UserRoot = $env:USERPROFILE
$Repo = Join-Path $UserRoot "Desktop\Jxhnny_Kleen_C3dz"
$Desk123 = Join-Path $UserRoot "Desktop\123"
$PorchRoot = Join-Path $Desk123 "PORCH_WATCHER"
$ToolsRoot = Join-Path $PorchRoot "TOOLS"
$ReceiptRoot = Join-Path $PorchRoot "RECEIPTS"
$PlanRoot = Join-Path $PorchRoot "PLANS"
$DropBox = Join-Path $PorchRoot "DROPBOX_DROP_FILES_OR_FOLDERS_HERE"
$CommandEntry = Join-Path $Desk123 "COMMAND_CENTER\CURRENT_CONTEXT_CART"
$PackageLane = Join-Path $Desk123 "PACKAGE_INTAKE\PACKAGES"
$PackageBlocked = Join-Path $Desk123 "PACKAGE_INTAKE\BLOCKED"
$ChildJobConsumed = Join-Path $Desk123 "COMMAND_CENTER\CHILD_SHELL\JOB_RECORDS\CONSUMED"
$PickupLane = Join-Path $Desk123 "COMMAND_CENTER\PICKUP\PACKET_20260521_052444"
$SaveScriptLane = Join-Path $Desk123 "PORCH_WATCHER\TOOLS"
$DropFileName = "CHAT_DROP_COPY__CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
$DesktopDrop = Join-Path $UserRoot "Desktop\$DropFileName"
$Desktop123Drop = Join-Path $Desk123 $DropFileName

New-Item -ItemType Directory -Force -Path $Desk123,$PorchRoot,$ToolsRoot,$ReceiptRoot,$PlanRoot,$DropBox,$CommandEntry,$PackageLane,$PackageBlocked,$ChildJobConsumed,$PickupLane | Out-Null

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ReceiptLocal = Join-Path $ReceiptRoot "PORCH_EVENT_TRIGGER_PACKAGE_RECEIPT_$Stamp.txt"
$PlanCsv = Join-Path $PlanRoot "PORCH_EVENT_TRIGGER_ROOT_CLEAN_PLAN_$Stamp.csv"
$MailFile = Join-Path $CommandEntry "YOU_GOT_MAIL__PORCH_EVENT_TRIGGER_$Stamp.md"

function Add-Receipt {
    param([string]$Text)
    Add-Content -LiteralPath $ReceiptLocal -Value $Text -Encoding UTF8
}

function Add-Mail {
    param([string]$Text)
    Add-Content -LiteralPath $MailFile -Value $Text -Encoding UTF8
}

function Get-SafeDestination {
    param(
        [string]$Dir,
        [string]$Name
    )

    New-Item -ItemType Directory -Force -Path $Dir | Out-Null
    $dest = Join-Path $Dir $Name

    if (-not (Test-Path -LiteralPath $dest)) {
        return $dest
    }

    $base = [System.IO.Path]::GetFileNameWithoutExtension($Name)
    $ext = [System.IO.Path]::GetExtension($Name)
    if ([string]::IsNullOrWhiteSpace($base)) { $base = $Name; $ext = "" }

    $i = 1
    do {
        $candidate = Join-Path $Dir ("{0}__DUP_{1}_{2}{3}" -f $base, $Stamp, $i, $ext)
        $i++
    } while (Test-Path -LiteralPath $candidate)

    return $candidate
}

function Get-RootResidualPlan {
    $Rows = New-Object System.Collections.Generic.List[object]

    $root = $Desk123
    if (-not (Test-Path -LiteralPath $root)) { return $Rows }

    Get-ChildItem -LiteralPath $root -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
        $name = $_.Name
        $dest = $null
        $classification = $null
        $action = "IGNORE"

        switch -Regex ($name) {
            '^desktop\.ini$' {
                $classification = "SYSTEM_FILE"
                $action = "IGNORE"
                break
            }
            '^CHAT_DROP_COPY__CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522\.md$' {
                $classification = "INTENTIONAL_CHAT_DROP_COPY"
                $action = "KEEP_ALLOWED_COPY"
                break
            }
            '^CHILDJOB-.*\.childjob\.json$' {
                $classification = "CONSUMED_CHILDJOB_RECORD"
                $action = "MOVE"
                $dest = Get-SafeDestination -Dir $ChildJobConsumed -Name $name
                break
            }
            '^COPYABLE_SUMMARY\.txt$' {
                $classification = "PICKUP_PACKET_TEXT"
                $action = "MOVE"
                $dest = Get-SafeDestination -Dir $PickupLane -Name $name
                break
            }
            '^PACKET_HASHES\.json$' {
                $classification = "PICKUP_PACKET_HASHES"
                $action = "MOVE"
                $dest = Get-SafeDestination -Dir $PickupLane -Name $name
                break
            }
            '^SAVE_AND_RUN_PORCH_MOVE_DROPPER_RULE_20260522\.ps1$' {
                $classification = "PORCH_DROPPER_TOOL_SCRIPT"
                $action = "MOVE"
                $dest = Get-SafeDestination -Dir $SaveScriptLane -Name $name
                break
            }
            default {
                $classification = "ROOT_FILE_NEEDS_REVIEW"
                $action = "MOVE"
                $dest = Get-SafeDestination -Dir (Join-Path $Desk123 "PORCH_SORTING_TABLE\ROOT_FILES_NEEDS_REVIEW") -Name $name
            }
        }

        $Rows.Add([pscustomobject]@{
            ObjectType = "FILE"
            Name = $name
            Source = $_.FullName
            Classification = $classification
            Action = $action
            Destination = $dest
            Length = $_.Length
            LastWriteTime = $_.LastWriteTime
        })
    }

    return $Rows
}

function Get-DropBoxPackagePlan {
    $Rows = New-Object System.Collections.Generic.List[object]

    if (-not (Test-Path -LiteralPath $DropBox)) { return $Rows }

    Get-ChildItem -LiteralPath $DropBox -Directory -Force -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.Name -in @('.', '..')) { return }

        $dest = Get-SafeDestination -Dir $PackageLane -Name $_.Name
        $Rows.Add([pscustomobject]@{
            ObjectType = "FOLDER_PACKAGE"
            Name = $_.Name
            Source = $_.FullName
            Classification = "PACKAGE_BY_FOLDER_NAME_ONLY"
            Action = "MOVE_PACKAGE_AS_WHOLE_FOLDER"
            Destination = $dest
            Length = $null
            LastWriteTime = $_.LastWriteTime
        })
    }

    Get-ChildItem -LiteralPath $DropBox -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
        $route = Join-Path $Desk123 "PORCH_SORTING_TABLE\DROPBOX_FILES_NEEDS_CLASSIFICATION"
        if ($_.Name -match 'BOSS.*WHIRLPOOL.*HANDOFF|BOSS_WHIRLPOOL_3_LAP_MULE_HANDOFF') {
            $route = Join-Path $Desk123 "MULE_WORKSHOP\ASSISTANT_TO_MULE"
        } elseif ($_.Name -match 'HANDOFF') {
            $route = Join-Path $Desk123 "COMMAND_CENTER\HANDOFF_INBOX"
        } elseif ($_.Name -match '^SAVE_.*\.ps1$') {
            $route = Join-Path $Desk123 "COMMAND_CENTER\SCRIPTS\SAVE_SCRIPTS"
        } elseif ($_.Extension -eq ".zip") {
            $route = Join-Path $Desk123 "PACKAGE_INTAKE\ZIP_PACKAGES"
        }

        $dest = Get-SafeDestination -Dir $route -Name $_.Name
        $Rows.Add([pscustomobject]@{
            ObjectType = "FILE"
            Name = $_.Name
            Source = $_.FullName
            Classification = "DROPBOX_FILE_BY_FILENAME"
            Action = "MOVE"
            Destination = $dest
            Length = $_.Length
            LastWriteTime = $_.LastWriteTime
        })
    }

    return $Rows
}

function Install-EventDropperTool {
    $Tool = Join-Path $ToolsRoot "RUN_PORCH_EVENT_DROPPER_ONCE.ps1"
    $Readme = Join-Path $ToolsRoot "README_PORCH_EVENT_DROPPER.txt"

    $ToolContent = @"
param(
    [switch]`$ExecuteRootClean
)

`$ErrorActionPreference = "Stop"

`$Name = "SAVE_PORCH_DROP_EVENT_TRIGGER_AND_PACKAGE_RULE_20260522.ps1"
`$Tool = "$ToolsRoot\`$Name"

if (-not (Test-Path -LiteralPath `$Tool)) {
    `$Found = Get-ChildItem "`$env:USERPROFILE\Downloads","`$env:USERPROFILE\Desktop","`$env:USERPROFILE\Desktop\123","$ToolsRoot" -Filter `$Name -File -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if (-not `$Found) {
        throw "Main porch event script not found: `$Name"
    }

    Move-Item -LiteralPath `$Found.FullName -Destination `$Tool -Force
}

Unblock-File -LiteralPath `$Tool -ErrorAction SilentlyContinue

if (`$ExecuteRootClean) {
    pwsh -NoProfile -ExecutionPolicy Bypass -File `$Tool -ExecuteRootClean -SkipGitSave
} else {
    pwsh -NoProfile -ExecutionPolicy Bypass -File `$Tool -SkipGitSave
}
"@

    $ReadmeContent = @"
PORCH EVENT DROPPER

ROLE:
USER BUTTON / ONE-SHOT MAIL TRIGGER.

WHAT IT DOES:
Scans the porch dropbox and records a YOU GOT MAIL event where the assistant enters.

DROP FOLDER:
$DropBox

WHERE THE TRIGGER LANDS:
$CommandEntry

HOW TO USE:
1. Drop a file or folder into the DROPBOX folder.
2. Run RUN_PORCH_EVENT_DROPPER_ONCE.ps1.
3. The tool moves the object to the right lane and writes YOU_GOT_MAIL event.

FOLDER RULE:
A dropped folder is a package.
The tool records the folder name as the package identity.
It moves the whole folder as a package.
It does not scatter the internal files first.

FILE RULE:
A dropped file is classified by filename.
The tool moves it to a lane or sorting table.

SUCCESS:
A YOU_GOT_MAIL__PORCH_EVENT_TRIGGER file appears in:
$CommandEntry

FAILURE:
A receipt appears in:
$ReceiptRoot

BOUNDARY:
Default is MOVE, not COPY.
No delete.
No background automation.
"@

    Set-Content -LiteralPath $Tool -Value $ToolContent -Encoding UTF8
    Set-Content -LiteralPath $Readme -Value $ReadmeContent -Encoding UTF8

    return $Tool
}

$InstalledTool = Install-EventDropperTool

$RootRows = @(Get-RootResidualPlan)
$DropRows = @(Get-DropBoxPackagePlan)
$AllRows = @($RootRows + $DropRows)

$AllRows | Export-Csv -LiteralPath $PlanCsv -NoTypeInformation -Encoding UTF8

Set-Content -LiteralPath $MailFile -Encoding UTF8 -Value @(
    "# YOU GOT MAIL — PORCH EVENT TRIGGER — $Stamp",
    "",
    "## Status",
    "",
    "Type: Command Center entry trigger / porch event notice.",
    "",
    "Purpose: make dropped files/packages visible where the assistant walks in.",
    "",
    "Boundary:",
    "- This is an event trigger, not doctrine.",
    "- This does not create new house rules by itself.",
    "- This does not promote dropped material.",
    "- This records intake so the assistant sees it before acting.",
    "",
    "## Trigger Rule",
    "",
    "When a file/folder/package is dropped, record the event.",
    "",
    "For folders/packages:",
    "- record folder name only as package identity first;",
    "- move whole folder as a package;",
    "- open/review the package in the next intake step;",
    "- do not scatter internal files before package review.",
    "",
    "## Event Summary",
    "",
    "Timestamp: $Stamp",
    "Plan CSV: $PlanCsv",
    "Local receipt: $ReceiptLocal",
    "Candidate/event count: $($AllRows.Count)",
    "Root clean execute: $ExecuteRootClean",
    ""
)

foreach ($row in $AllRows) {
    Add-Mail ("- [{0}] {1} :: {2} -> {3}" -f $row.ObjectType, $row.Name, $row.Action, $row.Destination)
}

Set-Content -LiteralPath $ReceiptLocal -Encoding UTF8 -Value @(
    "PORCH DROP EVENT TRIGGER / PACKAGE INTAKE RECEIPT — $Stamp",
    "",
    "Mode:",
    $(if ($ExecuteRootClean) { "EXECUTE ROOT CLEAN + EVENT RECORD" } else { "EVENT RECORD / PLAN ONLY" }),
    "",
    "Installed tool:",
    $InstalledTool,
    "",
    "DropBox:",
    $DropBox,
    "",
    "Command Center event trigger:",
    $MailFile,
    "",
    "Plan CSV:",
    $PlanCsv,
    "",
    "Rule:",
    "Dropped file/folder/package intake must record the event where the assistant enters.",
    "Folders are package objects: record folder name first, move whole folder, open package later.",
    "Default route is MOVE, not COPY.",
    ""
)

$MovedOk = 0
$MovedFailed = 0

if ($ExecuteRootClean) {
    foreach ($row in $AllRows) {
        if ($row.Action -notmatch '^MOVE') {
            Add-Receipt ("KEPT/IGNORED: {0} :: {1}" -f $row.Name, $row.Classification)
            continue
        }

        try {
            New-Item -ItemType Directory -Force -Path (Split-Path $row.Destination) | Out-Null
            Move-Item -LiteralPath $row.Source -Destination $row.Destination -Force
            $MovedOk++
            Add-Receipt ("MOVED: {0} -> {1}" -f $row.Source, $row.Destination)
        }
        catch {
            $MovedFailed++
            Add-Receipt ("FAILED MOVE: {0} -> {1} :: {2}" -f $row.Source, $row.Destination, $_.Exception.Message)
        }
    }
}

Add-Receipt ""
Add-Receipt ("Event count: {0}" -f $AllRows.Count)
Add-Receipt ("Moved OK: {0}" -f $MovedOk)
Add-Receipt ("Move failed: {0}" -f $MovedFailed)
Add-Receipt ("Command Center mail trigger: {0}" -f $MailFile)

if (-not $SkipGitSave) {
    if (-not (Test-Path -LiteralPath $Repo)) {
        Write-Host "BLOCKED - REPO NOT FOUND"
        Write-Host "Local receipt: $ReceiptLocal"
        exit 1
    }

    Set-Location -LiteralPath $Repo

    if (-not (Test-Path -LiteralPath ".git")) {
        Write-Host "BLOCKED - NOT GIT REPO"
        Write-Host "Local receipt: $ReceiptLocal"
        exit 1
    }

    $DirtyBefore = git status --short
    if ($DirtyBefore) {
        Write-Host "BLOCKED - REPO NOT CLEAN"
        Write-Host "Local receipt: $ReceiptLocal"
        $DirtyBefore | ForEach-Object { Write-Host $_ }
        exit 1
    }

    $OldHead = (git rev-parse HEAD).Trim()

    $RulePath = "BRAIN_LEARNING/PORCH_DROP_EVENT_TRIGGER_AND_PACKAGE_INTAKE_RULE_20260522.md"
    $CapturePath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/PORCH_DROP_EVENT_TRIGGER_PACKAGE_INTAKE_CAPTURE_20260522.md"
    $CockpitPath = "HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
    $ReceiptPath = "PROOF_HISTORY/PORCH_DROP_EVENT_TRIGGER_PACKAGE_INTAKE_RECEIPT_20260522.txt"
    $StatusPath = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"

    New-Item -ItemType Directory -Force -Path (Split-Path $RulePath),(Split-Path $CapturePath),(Split-Path $CockpitPath),(Split-Path $ReceiptPath),(Split-Path $StatusPath) | Out-Null

    $Rule = @"
# Porch Drop Event Trigger + Package Intake Rule — 20260522

## Status

Type: project-wide housekeeping / assistant-awareness trigger rule.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not background automation.
- This does not delete files.
- This does not promote dropped files or packages.
- This does not override source custody.

## Core Rule

When a file, folder, or package is dropped, record the event.

The event trigger must land where the assistant walks in so it fires before work begins.

Short phrase:
BAM — YOU GOT MAIL.

## Event Trigger Must Include

Every porch/drop event record must identify:

- timestamp
- object name
- object type: file, folder package, zip package, handoff, script, receipt, etc.
- source path
- classification
- route
- action taken: moved, parked, kept as intentional copy, blocked
- destination path
- receipt path
- next required assistant action

## Where The Trigger Lands

The event must land in the Command Center entry/current-context lane or equivalent assistant entry lane.

Default:

Desktop\123\COMMAND_CENTER\CURRENT_CONTEXT_CART\YOU_GOT_MAIL__PORCH_EVENT_TRIGGER_<timestamp>.md

Reason:
The assistant sees this where it walks in.

## Package / Folder Rule

If a folder is dropped, treat it as a package object first.

Do not scatter its internal files from the outside.

Process:

1. record folder name as package identity;
2. move the whole folder to PACKAGE_INTAKE/PACKAGES or a package review lane;
3. write a package event/receipt;
4. the assistant opens the package in the next intake step;
5. only after opening/reviewing the package may internal items be sorted.

Short form:
Folder name first. Whole package first. Open package later.

## File Rule

If a file is dropped, classify by filename first.

Move it to the correct lane or a review/sorting lane.

Do not copy and leave the original hanging.

## Package Rule

Packages include:

- dropped folders
- zip files
- grouped packets
- bundled artifacts
- tool packs
- mule returns
- handoff folders

A package must stay together until reviewed as a package.

## Relation to Move-Not-Copy Rule

Default route is MOVE, not COPY.

Copy is allowed only for explicit labeled exports, mirrors, backups, or chat drop-copies.

A drop event must say when an object is kept as an allowed copy.

## Dirty Pattern

Dirty pattern:
A file/folder is dropped, moved, or copied without any event visible at the assistant entry point.

Worse dirty pattern:
A folder package is broken apart before package review.

Worst dirty pattern:
The assistant asks "where is the file?" after a drop because no mail trigger was written.

## Clean Pattern

Clean pattern:

1. Drop happens.
2. Event is recorded.
3. Object is classified by name.
4. File moves to lane, or folder moves as whole package.
5. Receipt is written.
6. Mail trigger appears where assistant enters.
7. Assistant opens the mail trigger before acting.

## Short Form

Drop means event.

Folder means package.

Move, receipt, and YOU GOT MAIL trigger.
"@

    $Capture = @"
# Porch Drop Event Trigger + Package Intake Capture — 20260522

## Status

Type: correction capture / event-trigger framing.

Boundary:
- Capture only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Trigger

The user clarified that moving files is not enough.

Every drop must record an event where the assistant enters, so it fires like mail.

The user then added that packages/folders need the same treatment.

## Founding Original / Source Root

User correction included:

- "be sure now when i drop a file in you RECORD THE EVENT"
- "this will be your trigger"
- "BE SURE the trigger lands where you walk in so it fires bam you got mail"
- "same for packahes"
- "if i drop a folder same thing folder name only you then open it as a package"

## Clean Translation

The porch/dropper must create an assistant-visible event trigger.

Dropped folders must be treated as packages by folder name first.

The assistant must not scatter internal folder contents until it opens the package for package intake.

## Repair

This save adds the rule, updates the cockpit, exports the chat drop-copy, installs/updates an event-aware porch dropper, creates a dropbox, and writes a Command Center YOU GOT MAIL trigger.
"@

    Set-Content -LiteralPath $RulePath -Value $Rule -Encoding UTF8
    Set-Content -LiteralPath $CapturePath -Value $Capture -Encoding UTF8

    if (Test-Path -LiteralPath $CockpitPath) {
        $CockpitText = Get-Content -LiteralPath $CockpitPath -Raw
    } else {
        $CockpitText = "# Chat House Rules Cockpit Card — Applied Version — 20260522`r`n"
    }

    $Marker = "## 2.27 Porch Drop Event Trigger + Package Intake Rule"
    $Addendum = @"

---

$Marker

Drop means event.

When a file, folder, or package is dropped, write a YOU GOT MAIL event where the assistant walks in.

Default trigger lane:
Desktop\123\COMMAND_CENTER\CURRENT_CONTEXT_CART\YOU_GOT_MAIL__PORCH_EVENT_TRIGGER_<timestamp>.md

The event must include:
- object name;
- object type;
- source path;
- classification;
- route;
- action taken;
- destination;
- receipt;
- next assistant action.

Folder/package rule:
If a folder is dropped, record the folder name as the package identity first.
Move the whole folder as a package.
Do not scatter internal files before opening/reviewing the package.

Short form:
Drop means event. Folder means package. Move, receipt, and YOU GOT MAIL trigger.
"@

    if ($CockpitText -notlike "*$Marker*") {
        Set-Content -LiteralPath $CockpitPath -Value ($CockpitText.TrimEnd() + $Addendum) -Encoding UTF8
    } else {
        $Pattern = [regex]::Escape($Marker) + ".*?(?=\r?\n---\r?\n|\z)"
        $NewCockpit = [regex]::Replace($CockpitText, $Pattern, $Addendum.TrimStart(), [System.Text.RegularExpressions.RegexOptions]::Singleline)
        Set-Content -LiteralPath $CockpitPath -Value $NewCockpit -Encoding UTF8
    }

    Copy-Item -LiteralPath $CockpitPath -Destination $DesktopDrop -Force
    Copy-Item -LiteralPath $CockpitPath -Destination $Desktop123Drop -Force

    $RuleHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $RulePath).Hash
    $CaptureHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CapturePath).Hash
    $CockpitHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CockpitPath).Hash
    $MailHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $MailFile).Hash

    $GitReceipt = @"
PORCH DROP EVENT TRIGGER + PACKAGE INTAKE RECEIPT — 20260522

Verdict:
PASS - PORCH DROP EVENT TRIGGER PACKAGE INTAKE RULE SAVED

Old HEAD:
$OldHead

Saved project files:
$RulePath
SHA256: $RuleHash

$CapturePath
SHA256: $CaptureHash

$CockpitPath
SHA256: $CockpitHash

Command Center mail trigger:
$MailFile
SHA256: $MailHash

Local receipt:
$ReceiptLocal

Local plan:
$PlanCsv

Installed event dropper:
$InstalledTool

DropBox:
$DropBox

Boundary:
Project-wide drop event trigger/package intake rule, correction capture, cockpit update, chat drop-copy export, local dropbox/event-dropper install, and local root residual plan only.
No doctrine promotion.
No active guide rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No background automation.
No delete action.

Short form:
Drop means event.
Folder means package.
Move, receipt, and YOU GOT MAIL trigger.
"@

    Set-Content -LiteralPath $ReceiptPath -Value $GitReceipt -Encoding UTF8

    $StatusAppend = @"

## 20260522 — Porch Drop Event Trigger + Package Intake Rule

Position before commit: $OldHead

Saved:
- $RulePath
- $CapturePath
- $CockpitPath
- $ReceiptPath

Local event trigger:
- $MailFile

Local receipt:
- $ReceiptLocal

Local plan:
- $PlanCsv

Installed tool:
- $InstalledTool

DropBox:
- $DropBox

Verdict:
PASS - PORCH DROP EVENT TRIGGER PACKAGE INTAKE RULE SAVED

Boundary:
Project-wide drop event trigger/package intake rule, correction capture, cockpit update, chat drop-copy export, local dropbox/event-dropper install, and local root residual plan only. No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No background automation. No delete action.

Short form:
Drop means event. Folder means package. Move, receipt, and YOU GOT MAIL trigger.
"@

    Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

    git add -- $RulePath $CapturePath $CockpitPath $StatusPath
    git add -f -- $ReceiptPath

    $Staged = git diff --cached --name-only
    if (-not $Staged) {
        Write-Host "BLOCKED - NO STAGED CHANGES"
        Write-Host "Local receipt: $ReceiptLocal"
        exit 1
    }

    git commit -m "Add porch drop event package intake rule" | Out-Host
    git push origin main | Out-Host

    $NewHead = (git rev-parse HEAD).Trim()
    $RemoteHead = (git rev-parse origin/main).Trim()
    $FinalStatus = git status --short

    if ($NewHead -ne $RemoteHead) {
        Write-Host "BLOCKED - REMOTE HEAD DOES NOT MATCH"
        Write-Host "Old HEAD: $OldHead"
        Write-Host "New HEAD: $NewHead"
        Write-Host "Remote HEAD: $RemoteHead"
        Write-Host "Local receipt: $ReceiptLocal"
        exit 1
    }

    if ($FinalStatus) {
        Write-Host "BLOCKED - FINAL STATUS NOT CLEAN"
        Write-Host "Old HEAD: $OldHead"
        Write-Host "New HEAD: $NewHead"
        Write-Host "Remote HEAD: $RemoteHead"
        $FinalStatus | ForEach-Object { Write-Host $_ }
        Write-Host "Local receipt: $ReceiptLocal"
        exit 1
    }

    Write-Host "PASS - PORCH DROP EVENT TRIGGER PACKAGE INTAKE RULE SAVED"
    Write-Host "Old HEAD: $OldHead"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    Write-Host "Final status: clean"
    Write-Host "Rule: $RulePath"
    Write-Host "Capture: $CapturePath"
    Write-Host "Cockpit: $CockpitPath"
    Write-Host "Command Center mail trigger: $MailFile"
    Write-Host "Desktop CHAT drop-copy: $DesktopDrop"
    Write-Host "Desktop 123 CHAT copy: $Desktop123Drop"
    Write-Host "Receipt: $ReceiptPath"
    Write-Host "Local receipt: $ReceiptLocal"
    Write-Host "Local plan: $PlanCsv"
    Write-Host "Installed event dropper: $InstalledTool"
    Write-Host "DropBox: $DropBox"
    Write-Host "Root clean execute: $ExecuteRootClean"
    Write-Host "Moved OK: $MovedOk"
    Write-Host "Move failed: $MovedFailed"
    Write-Host "Boundary: drop event trigger/package intake rule, cockpit update, drop-copy export, local dropbox/event-dropper install, and local root residual plan only; no doctrine promotion; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no background automation; no delete action."
} else {
    Write-Host "PASS - PORCH DROP EVENT LOCAL RUN COMPLETE"
    Write-Host "Command Center mail trigger: $MailFile"
    Write-Host "Local receipt: $ReceiptLocal"
    Write-Host "Local plan: $PlanCsv"
    Write-Host "Installed event dropper: $InstalledTool"
    Write-Host "DropBox: $DropBox"
    Write-Host "Root clean execute: $ExecuteRootClean"
    Write-Host "Moved OK: $MovedOk"
    Write-Host "Move failed: $MovedFailed"
    Write-Host "Boundary: local event trigger/package intake run only; no git save; no delete."
}
