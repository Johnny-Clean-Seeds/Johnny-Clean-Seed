param(
    [switch]$Execute,
    [switch]$PlanOnly,
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

$DropFileName = "CHAT_DROP_COPY__CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
$DesktopDrop = Join-Path $UserRoot "Desktop\$DropFileName"
$Desktop123Drop = Join-Path $Desk123 $DropFileName

New-Item -ItemType Directory -Force -Path $Desk123,$PorchRoot,$ToolsRoot,$ReceiptRoot,$PlanRoot | Out-Null

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ReceiptLocal = Join-Path $ReceiptRoot "PORCH_MOVE_DROPPER_RECEIPT_$Stamp.txt"
$PlanCsv = Join-Path $PlanRoot "PORCH_MOVE_DROPPER_PLAN_$Stamp.csv"
$PlanTxt = Join-Path $PlanRoot "PORCH_MOVE_DROPPER_PLAN_$Stamp.txt"

function Write-LocalReceiptLine {
    param([string]$Text)
    Add-Content -LiteralPath $ReceiptLocal -Value $Text -Encoding UTF8
}

function Test-ProjectLikeFile {
    param([System.IO.FileInfo]$File)

    $n = $File.Name
    $ext = $File.Extension.ToLowerInvariant()

    if ($n -match '^(desktop\.ini|Thumbs\.db)$') { return $false }
    if ($n -like 'CHAT_DROP_COPY__CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md') { return $false }

    $patterns = @(
        'CLEAN','KLEEN','SEED','MILK','MULE','HANDOFF','ROBOCOP','COCKPIT','CHAT_DROP_COPY',
        'SAVE_','RECEIPT','BOSS','WHIRLPOOL','SOURCE','COMMAND_CENTER','GATE','JUDGE',
        'PORCH','WATCHER','DROPPER','VBrain'
    )

    foreach ($p in $patterns) {
        if ($n.ToUpperInvariant().Contains($p.ToUpperInvariant())) { return $true }
    }

    if ($ext -in @('.ps1','.md','.url')) { return $true }

    return $false
}

function Get-RouteForFile {
    param([System.IO.FileInfo]$File)

    $n = $File.Name
    $upper = $n.ToUpperInvariant()
    $ext = $File.Extension.ToLowerInvariant()

    if ($upper -like '*BOSS*WHIRLPOOL*MULE*HANDOFF*' -or $upper -like '*BOSS_WHIRLPOOL_3_LAP_MULE_HANDOFF*') {
        return Join-Path $Desk123 "MULE_WORKSHOP\ASSISTANT_TO_MULE"
    }

    if ($upper -like '*MULE*HANDOFF*') {
        return Join-Path $Desk123 "MULE_WORKSHOP\ASSISTANT_TO_MULE"
    }

    if ($upper -like '*HANDOFF*') {
        return Join-Path $Desk123 "COMMAND_CENTER\HANDOFF_INBOX"
    }

    if ($upper -like 'SAVE_*.PS1') {
        return Join-Path $Desk123 "COMMAND_CENTER\SCRIPTS\SAVE_SCRIPTS"
    }

    if ($ext -eq '.ps1') {
        return Join-Path $Desk123 "COMMAND_CENTER\SCRIPTS\INCOMING"
    }

    if ($upper -like '*ROBOCOP*' -and $ext -eq '.zip') {
        return Join-Path $Desk123 "TOOL_PACKS\ROBOCOP"
    }

    if ($ext -eq '.zip') {
        return Join-Path $Desk123 "TOOL_PACKS\INCOMING_ZIPS"
    }

    if ($upper -like 'CHAT_DROP_COPY__*') {
        return Join-Path $Desk123 "CHAT_COCKPIT\DROP_COPIES"
    }

    if ($ext -eq '.url') {
        return Join-Path $Desk123 "SOURCE_TRANSFER\URL_SHORTCUTS"
    }

    if ($ext -eq '.md') {
        return Join-Path $Desk123 "SOURCE_TRANSFER\MD_INCOMING"
    }

    if ($ext -eq '.txt') {
        return Join-Path $Desk123 "SOURCE_TRANSFER\TEXT_INCOMING"
    }

    if ($ext -in @('.png','.jpg','.jpeg','.webp','.gif','.bmp')) {
        return Join-Path $Desk123 "MEDIA_INTAKE\IMAGES"
    }

    return Join-Path $Desk123 "PORCH_SORTING_TABLE\NEEDS_REVIEW"
}

function Get-SafeDestination {
    param(
        [string]$Dir,
        [string]$FileName
    )

    New-Item -ItemType Directory -Force -Path $Dir | Out-Null
    $dest = Join-Path $Dir $FileName

    if (-not (Test-Path -LiteralPath $dest)) {
        return $dest
    }

    $base = [System.IO.Path]::GetFileNameWithoutExtension($FileName)
    $ext = [System.IO.Path]::GetExtension($FileName)
    $i = 1
    do {
        $candidate = Join-Path $Dir ("{0}__DUP_{1}_{2}{3}" -f $base, $Stamp, $i, $ext)
        $i++
    } while (Test-Path -LiteralPath $candidate)

    return $candidate
}

function Get-PorchFiles {
    $roots = @(
        (Join-Path $UserRoot "Desktop"),
        (Join-Path $UserRoot "Downloads"),
        $Desk123
    )

    $excludeDirs = @(
        $Repo,
        (Join-Path $UserRoot "Desktop\Jxhnny_Kleen_C3dz"),
        (Join-Path $UserRoot "Desktop\123\PORCH_WATCHER"),
        (Join-Path $UserRoot "Desktop\123\MULE_WORKSHOP"),
        (Join-Path $UserRoot "Desktop\123\COMMAND_CENTER"),
        (Join-Path $UserRoot "Desktop\123\MAIL_ROOM"),
        (Join-Path $UserRoot "Desktop\123\CHAT_COCKPIT"),
        (Join-Path $UserRoot "Desktop\123\TOOL_PACKS"),
        (Join-Path $UserRoot "Desktop\123\SOURCE_TRANSFER")
    ) | ForEach-Object { try { [System.IO.Path]::GetFullPath($_).TrimEnd('\') } catch { $_ } }

    $files = New-Object System.Collections.Generic.List[System.IO.FileInfo]

    foreach ($root in $roots) {
        if (-not (Test-Path -LiteralPath $root)) { continue }

        Get-ChildItem -LiteralPath $root -File -ErrorAction SilentlyContinue | ForEach-Object {
            $full = $_.FullName

            if ($PSCommandPath -and ($full -eq $PSCommandPath)) { return }
            if ($_.Name -eq "SAVE_AND_RUN_PORCH_MOVE_DROPPER_RULE_20260522.ps1") { return }
            if ($_.Name -eq $DropFileName -and $_.DirectoryName -eq (Join-Path $UserRoot "Desktop")) { return }

            if (Test-ProjectLikeFile $_) {
                $files.Add($_)
            }
        }
    }

    return $files
}

function Install-PorchDropperTool {
    $Tool = Join-Path $ToolsRoot "RUN_PORCH_MOVE_DROPPER_ONCE.ps1"
    $Readme = Join-Path $ToolsRoot "README_PORCH_MOVE_DROPPER.txt"

    $ToolContent = @'
param(
    [switch]$Execute
)

$ErrorActionPreference = "Stop"

$Name = "SAVE_AND_RUN_PORCH_MOVE_DROPPER_RULE_20260522.ps1"
$SearchRoots = @(
    "$env:USERPROFILE\Desktop\123",
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop"
)

$Found = Get-ChildItem $SearchRoots -Filter $Name -File -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $Found) {
    throw "Main porch dropper script not found: $Name"
}

$Target = "$env:USERPROFILE\Desktop\123\$Name"
Copy-Item -LiteralPath $Found.FullName -Destination $Target -Force
Unblock-File -LiteralPath $Target -ErrorAction SilentlyContinue

if ($Execute) {
    pwsh -NoProfile -ExecutionPolicy Bypass -File $Target -Execute -SkipGitSave
} else {
    pwsh -NoProfile -ExecutionPolicy Bypass -File $Target -PlanOnly -SkipGitSave
}
'@

    $ReadmeContent = @"
PORCH MOVE DROPPER

ROLE:
USER BUTTON / ONE-SHOT HOUSEKEEPER.

WHAT IT DOES:
Reads project-looking files sitting on the porch, classifies them by filename, and MOVES them to a lane under Desktop\123.

DEFAULT:
Plan only.

HOW TO USE - PLAN:
pwsh -NoProfile -ExecutionPolicy Bypass -File "$Tool"

HOW TO USE - MOVE:
pwsh -NoProfile -ExecutionPolicy Bypass -File "$Tool" -Execute

WHY IT EXISTS:
Porch files must not sit loose.
The default intake action is MOVE, not COPY.
Copy is only allowed for explicitly labeled export/mirror/drop-copy files.

SUCCESS:
A receipt appears in:
$ReceiptRoot

FAILURE:
The receipt or console says BLOCKED or FAILED.
Paste the bottom block into chat.

IMPORTANT:
This does not delete files.
This does not commit.
This does not push.
It moves loose porch files into lanes.
"@

    Set-Content -LiteralPath $Tool -Value $ToolContent -Encoding UTF8
    Set-Content -LiteralPath $Readme -Value $ReadmeContent -Encoding UTF8

    return $Tool
}

$InstalledTool = Install-PorchDropperTool

Write-LocalReceiptLine "PORCH MOVE DROPPER LOCAL RECEIPT — $Stamp"
Write-LocalReceiptLine ""
Write-LocalReceiptLine "Mode:"
if ($Execute) { Write-LocalReceiptLine "EXECUTE / MOVE FILES" } else { Write-LocalReceiptLine "PLAN ONLY / NO FILES MOVED" }
Write-LocalReceiptLine ""
Write-LocalReceiptLine "Rule:"
Write-LocalReceiptLine "Default intake/routing is MOVE, not COPY."
Write-LocalReceiptLine "Copy is allowed only for explicitly labeled export/mirror/drop-copy cases."
Write-LocalReceiptLine ""
Write-LocalReceiptLine "Installed tool:"
Write-LocalReceiptLine $InstalledTool
Write-LocalReceiptLine ""

$Files = @(Get-PorchFiles)
$Rows = New-Object System.Collections.Generic.List[object]

foreach ($f in $Files) {
    $route = Get-RouteForFile $f
    $dest = Get-SafeDestination -Dir $route -FileName $f.Name

    $Rows.Add([pscustomobject]@{
        Source = $f.FullName
        Route = $route
        Destination = $dest
        Action = if ($Execute) { "MOVE" } else { "PLAN" }
        Size = $f.Length
        LastWriteTime = $f.LastWriteTime
    })
}

$Rows | Export-Csv -LiteralPath $PlanCsv -NoTypeInformation -Encoding UTF8

Set-Content -LiteralPath $PlanTxt -Encoding UTF8 -Value @(
    "PORCH MOVE DROPPER PLAN — $Stamp",
    "",
    "Mode: " + $(if ($Execute) { "EXECUTE / MOVE FILES" } else { "PLAN ONLY / NO FILES MOVED" }),
    "Candidate count: $($Rows.Count)",
    "",
    "Plan CSV:",
    $PlanCsv,
    "",
    "Rule:",
    "Default intake/routing is MOVE, not COPY.",
    "Copy is allowed only for explicitly labeled export/mirror/drop-copy cases.",
    "",
    "Routes:"
)

foreach ($row in $Rows) {
    Add-Content -LiteralPath $PlanTxt -Encoding UTF8 -Value ("- {0} -> {1}" -f $row.Source, $row.Destination)
}

$MoveOk = 0
$MoveFailed = 0

if ($Execute) {
    foreach ($row in $Rows) {
        try {
            New-Item -ItemType Directory -Force -Path (Split-Path $row.Destination) | Out-Null
            Move-Item -LiteralPath $row.Source -Destination $row.Destination -Force
            $MoveOk++
            Write-LocalReceiptLine ("MOVED: {0} -> {1}" -f $row.Source, $row.Destination)
        }
        catch {
            $MoveFailed++
            Write-LocalReceiptLine ("FAILED MOVE: {0} -> {1} :: {2}" -f $row.Source, $row.Destination, $_.Exception.Message)
        }
    }
}

Write-LocalReceiptLine ""
Write-LocalReceiptLine "Candidate count: $($Rows.Count)"
Write-LocalReceiptLine "Moved OK: $MoveOk"
Write-LocalReceiptLine "Move failed: $MoveFailed"
Write-LocalReceiptLine "Plan CSV: $PlanCsv"
Write-LocalReceiptLine "Plan TXT: $PlanTxt"

if (-not $SkipGitSave) {
    if (-not (Test-Path -LiteralPath $Repo)) {
        Write-LocalReceiptLine "GIT SAVE BLOCKED: Repo not found: $Repo"
        Write-Host "BLOCKED - GIT SAVE NOT RUN / REPO NOT FOUND"
        Write-Host "Porch plan/execute receipt: $ReceiptLocal"
        exit 1
    }

    Set-Location -LiteralPath $Repo

    if (-not (Test-Path -LiteralPath ".git")) {
        Write-LocalReceiptLine "GIT SAVE BLOCKED: Not in git repo: $Repo"
        Write-Host "BLOCKED - GIT SAVE NOT RUN / NOT GIT REPO"
        Write-Host "Porch plan/execute receipt: $ReceiptLocal"
        exit 1
    }

    $DirtyBefore = git status --short
    if ($DirtyBefore) {
        Write-LocalReceiptLine "GIT SAVE BLOCKED: repo dirty before save."
        $DirtyBefore | ForEach-Object { Write-LocalReceiptLine $_ }
        Write-Host "BLOCKED - REPO NOT CLEAN"
        Write-Host "Porch plan/execute receipt: $ReceiptLocal"
        $DirtyBefore | ForEach-Object { Write-Host $_ }
        exit 1
    }

    $OldHead = (git rev-parse HEAD).Trim()

    $RulePath = "BRAIN_LEARNING/PORCH_WATCHER_MOVE_NOT_COPY_HOUSEKEEPING_RULE_20260522.md"
    $CapturePath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/PORCH_WATCHER_MOVE_NOT_COPY_FAILURE_CAPTURE_20260522.md"
    $CockpitPath = "HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
    $ReceiptPath = "PROOF_HISTORY/PORCH_WATCHER_MOVE_NOT_COPY_HOUSEKEEPING_RULE_RECEIPT_20260522.txt"
    $StatusPath = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"

    New-Item -ItemType Directory -Force -Path (Split-Path $RulePath),(Split-Path $CapturePath),(Split-Path $CockpitPath),(Split-Path $ReceiptPath),(Split-Path $StatusPath) | Out-Null

    $Rule = @"
# Porch Watcher / Move-Not-Copy Housekeeping Rule — 20260522

## Status

Type: project-wide housekeeping and dropper/routing rule.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not background automation by itself.
- This does not delete files.
- This does not make Desktop the source of truth.
- This does not replace source custody or proof gates.

## Core Rule

Default intake/routing is MOVE, not COPY.

Dropped, downloaded, generated, or porch-sitting project files must not be copied into place while the original is left hanging.

A porch/dropper tool should:

1. read the file name;
2. classify the object;
3. identify the correct lane;
4. MOVE the file to that lane;
5. write a receipt;
6. report blocked/unknown files instead of leaving silent clutter.

## Copy Exception

Copy is allowed only for intentional export/mirror/drop-copy cases.

Those copies must be clearly labeled as copies.

Examples:
- CHAT_DROP_COPY files for dragging into chat;
- exported receipts;
- intentional backup versions;
- intentional mirror/output artifacts.

If it is not an explicit copy/export/mirror/drop-copy case, do not copy by default.

## Porch Definition

Porch means loose intake area where files can pile up before placement, especially:

- Desktop
- Downloads
- root of Desktop\123
- tool download areas
- chat-generated artifact landing areas

Porch is not a permanent lane.

## Move Rule

A generated/downloaded project file must either:

- be moved to the correct lane;
- be explicitly exported as a labeled copy;
- be parked in a sorting lane with a reason;
- or produce a blocked receipt.

Do not leave it floating.

## Watcher/Dropper Requirement

The porch watcher/dropper must classify by name first.

High-confidence examples:

- BOSS_WHIRLPOOL_3_LAP_MULE_HANDOFF -> MULE_WORKSHOP/ASSISTANT_TO_MULE
- MULE_HANDOFF -> MULE_WORKSHOP/ASSISTANT_TO_MULE
- SAVE_*.ps1 -> COMMAND_CENTER/SCRIPTS/SAVE_SCRIPTS
- ROBOCOP*.zip -> TOOL_PACKS/ROBOCOP
- CHAT_DROP_COPY__* -> chat cockpit drop-copy lane or Desktop export
- *.url -> SOURCE_TRANSFER/URL_SHORTCUTS
- unknown project-like files -> PORCH_SORTING_TABLE/NEEDS_REVIEW

## Dirty Pattern

Dirty pattern:
copying a file into the right place while leaving the original at the porch.

Worse dirty pattern:
making a handoff/download/script and never proving it was placed.

Worst dirty pattern:
a porch full of loose project artifacts with no watcher, no receipt, no move, and no route.

## Clean Pattern

Clean pattern:

1. Create/download artifact.
2. Classify by name and job.
3. Move to correct lane.
4. Write receipt.
5. If chat-facing, export labeled CHAT drop-copy.
6. If unknown, move to sorting table with receipt.
7. Do not leave porch clutter.

## Relation to Final Judge Gate

Final Judge Gate starts the gate run and ends it.

For porch/dropper work it asks:

- Did the object have a job?
- Did the dropper identify the job?
- Did it route to the right lane?
- Did it move instead of copy when move was required?
- Did it write a receipt?
- Did it leave porch clutter?

## Short Form

Porch is not storage.

Default route is move, not copy.

Copy only when explicitly labeled as copy/export/mirror/drop-copy.

No loose packages.
"@

    $Capture = @"
# Porch Watcher / Move-Not-Copy Failure Capture — 20260522

## Status

Type: failure capture / correction-to-rule record.

Boundary:
- Capture only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Trigger

The user identified that files were being copied or left at the porch instead of being moved into correct lanes.

The user also noted there were many loose porch files.

## Founding Original / Source Root

User correction included:

- "wheres the fucking watcher dropper when i ddrop a file"
- "hwy is it not reading the name so you know what is in there and where to MOVE it to not copy"
- "do not fuckin copy files and leave them hanging that is a fucking rule adopt it now"
- "fix this problem now clean fix no bs all fixes all problems all ways right now"
- "dude you have 89 files sitting at the porch"
- "what a shit show lol"

## Clean Translation

Project intake must not leave loose artifacts at the porch.

The default file routing action is MOVE.

Copy is reserved for intentional labeled exports, mirrors, backups, or chat drop-copies.

A porch watcher/dropper needs to classify by filename, route to lane, move the file, and receipt the action.

## Repair

This save adds the project-wide housekeeping rule, updates the chat cockpit, exports the updated chat drop-copy, and installs a one-shot porch move dropper under Desktop\123/PORCH_WATCHER.

## Guardrail

Moving is not deleting.

If confidence is low, move to a sorting lane with receipt rather than guessing a final authority lane.
"@

    Set-Content -LiteralPath $RulePath -Value $Rule -Encoding UTF8
    Set-Content -LiteralPath $CapturePath -Value $Capture -Encoding UTF8

    if (Test-Path -LiteralPath $CockpitPath) {
        $CockpitText = Get-Content -LiteralPath $CockpitPath -Raw
    } else {
        $CockpitText = @"
# Chat House Rules Cockpit Card — Applied Version — 20260522

## Status

Type: in-chat assistant operating card / cockpit sheet.

Purpose: hold assistant-facing project rules close enough to use during live work.

Boundary:
- This does not replace Mr.Kleen.
- This does not rewrite doctrine.
- This does not promote new doctrine.
- This is a working cockpit card for chat behavior.
"@
    }

    $Marker = "## 2.26 Porch Watcher / Move-Not-Copy Housekeeping Rule"
    $Addendum = @"

---

$Marker

Porch is not storage.

Default intake/routing is MOVE, not COPY.

When a project file is dropped, downloaded, generated, or left at the porch:

1. read the filename;
2. classify the object;
3. identify the lane;
4. move it to that lane;
5. write a receipt;
6. if unknown, move it to a sorting table with a reason.

Copy is allowed only for intentional labeled exports, mirrors, backups, or drop-copies.

Blocked:
- do not copy files into place and leave the original hanging;
- do not leave generated scripts/downloads/handoffs at the porch;
- do not make the user hunt for the real file;
- do not route without receipt;
- do not delete to clean the porch.

Short form:
No loose packages. Move to lane. Copy only when explicitly labeled.
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
    $DesktopDropHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $DesktopDrop).Hash
    $Desktop123DropHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Desktop123Drop).Hash

    $GitReceipt = @"
PORCH WATCHER MOVE-NOT-COPY HOUSEKEEPING RULE RECEIPT — 20260522

Verdict:
PASS - PORCH WATCHER MOVE NOT COPY HOUSEKEEPING RULE SAVED

Old HEAD:
$OldHead

Saved project files:
$RulePath
SHA256: $RuleHash

$CapturePath
SHA256: $CaptureHash

$CockpitPath
SHA256: $CockpitHash

Exported Desktop chat drop-copy:
$DesktopDrop
SHA256: $DesktopDropHash

Exported Desktop\123 chat transfer copy:
$Desktop123Drop
SHA256: $Desktop123DropHash

Installed local porch dropper:
$InstalledTool

Local porch receipt:
$ReceiptLocal

Local porch plan:
$PlanCsv

Boundary:
Project-wide housekeeping rule, correction capture, cockpit addendum, labeled CHAT drop-copy export, and local one-shot porch dropper install only.
No doctrine promotion.
No active guide rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No background automation.
No delete action.

Short form:
No loose packages.
Default route is MOVE, not COPY.
Copy only when explicitly labeled.
"@

    Set-Content -LiteralPath $ReceiptPath -Value $GitReceipt -Encoding UTF8

    $StatusAppend = @"

## 20260522 — Porch Watcher / Move-Not-Copy Housekeeping Rule

Position before commit: $OldHead

Saved:
- $RulePath
- $CapturePath
- $CockpitPath
- $ReceiptPath

Exported:
- $DesktopDrop
- $Desktop123Drop

Installed local one-shot porch dropper:
- $InstalledTool

Local porch receipt:
- $ReceiptLocal

Verdict:
PASS - PORCH WATCHER MOVE NOT COPY HOUSEKEEPING RULE SAVED

Boundary:
Project-wide housekeeping rule, correction capture, cockpit addendum, labeled CHAT drop-copy export, and local one-shot porch dropper install only. No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No background automation. No delete action.

Short form:
No loose packages. Default route is MOVE, not COPY. Copy only when explicitly labeled.
"@

    Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

    git add -- $RulePath $CapturePath $CockpitPath $StatusPath
    git add -f -- $ReceiptPath

    $Staged = git diff --cached --name-only
    if (-not $Staged) {
        Write-LocalReceiptLine "GIT SAVE BLOCKED: no staged changes."
        Write-Host "BLOCKED - NO STAGED CHANGES"
        Write-Host "Porch plan/execute receipt: $ReceiptLocal"
        exit 1
    }

    git commit -m "Add porch move not copy housekeeping rule" | Out-Host
    git push origin main | Out-Host

    $NewHead = (git rev-parse HEAD).Trim()
    $RemoteHead = (git rev-parse origin/main).Trim()
    $FinalStatus = git status --short

    if ($NewHead -ne $RemoteHead) {
        Write-Host "BLOCKED - REMOTE HEAD DOES NOT MATCH"
        Write-Host "Old HEAD: $OldHead"
        Write-Host "New HEAD: $NewHead"
        Write-Host "Remote HEAD: $RemoteHead"
        Write-Host "Porch receipt: $ReceiptLocal"
        exit 1
    }

    if ($FinalStatus) {
        Write-Host "BLOCKED - FINAL STATUS NOT CLEAN"
        Write-Host "Old HEAD: $OldHead"
        Write-Host "New HEAD: $NewHead"
        Write-Host "Remote HEAD: $RemoteHead"
        $FinalStatus | ForEach-Object { Write-Host $_ }
        Write-Host "Porch receipt: $ReceiptLocal"
        exit 1
    }

    Write-Host "PASS - PORCH WATCHER MOVE NOT COPY HOUSEKEEPING RULE SAVED"
    Write-Host "Old HEAD: $OldHead"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    Write-Host "Final status: clean"
    Write-Host "Rule: $RulePath"
    Write-Host "Capture: $CapturePath"
    Write-Host "Cockpit: $CockpitPath"
    Write-Host "Desktop CHAT drop-copy: $DesktopDrop"
    Write-Host "Desktop 123 CHAT copy: $Desktop123Drop"
    Write-Host "Receipt: $ReceiptPath"
    Write-Host "Porch local receipt: $ReceiptLocal"
    Write-Host "Porch plan: $PlanCsv"
    if ($Execute) { Write-Host "Porch mode: EXECUTE / MOVE FILES" } else { Write-Host "Porch mode: PLAN ONLY / NO FILES MOVED" }
    Write-Host "Candidate count: $($Rows.Count)"
    Write-Host "Moved OK: $MoveOk"
    Write-Host "Move failed: $MoveFailed"
    Write-Host "Boundary: housekeeping rule, cockpit update, drop-copy export, and local one-shot dropper only; no doctrine promotion; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no background automation; no delete action."
} else {
    Write-Host "PASS - PORCH MOVE DROPPER LOCAL RUN COMPLETE"
    if ($Execute) { Write-Host "Porch mode: EXECUTE / MOVE FILES" } else { Write-Host "Porch mode: PLAN ONLY / NO FILES MOVED" }
    Write-Host "Candidate count: $($Rows.Count)"
    Write-Host "Moved OK: $MoveOk"
    Write-Host "Move failed: $MoveFailed"
    Write-Host "Receipt: $ReceiptLocal"
    Write-Host "Plan: $PlanCsv"
    Write-Host "Installed tool: $InstalledTool"
    Write-Host "Boundary: local porch route only; no git save; no delete."
}
